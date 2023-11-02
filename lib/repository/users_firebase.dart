import 'dart:io';

import 'package:basketball_app/repository/room_firebase.dart';
import 'package:basketball_app/utils/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../models/account.dart';
import '../models/talkroom.dart';
import 'posts_firebase.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final _firebaseAuth = FirebaseAuth.instance;
  static final CollectionReference users =
      _firestoreInstance.collection("users");

  //FirebaseFirestoreにアカウント登録
  static Future<dynamic> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set({
        "name": newAccount.name,
        "user_id": newAccount.id,
        "image_path": newAccount.imagePath,
      });
      print("新規ユーザー作成完了");
      return true;
    } on FirebaseException catch (e) {
      print("新規ユーザー作成エラー: $e");
      return false;
    }
  }

  //アカウント情報を取得して、そのユーザが存在するか確認する
  static Future<dynamic> checkUserExists(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        // データが存在する場合の処理
        Account myAccount = Account(
          id: data["user_id"],
          name: data["name"],
          myToken: data["myToken"],
          imagePath: data["image_path"] ?? "",
        );
        Authentication.myAccount = myAccount;
        print("ユーザー取得完了 : $myAccount");
        return true;
      } else {
        // データが存在しない場合の処理
        print("指定されたユーザーIDに対応するデータが存在しません");
        return false;
      }
    } on FirebaseException catch (e) {
      // 通信障害やFirebase関連のエラーが発生した場合の処理
      print("ユーザー取得エラー$e");
    } catch (e) {
      // それ以外の予期しない例外が発生した場合の処理
      print("予期しないエラーが発生しました: $e");
    }
  }

  //サインアウト
  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  //ユーザー編集
  static Future<dynamic> updateUser(Account updateAccount) async {
    try {
      users.doc(updateAccount.id).update({
        "name": updateAccount.name,
        "user_id": updateAccount.id,
        "image_path": updateAccount.imagePath,
      });
      print("ユーザー更新完了");
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  //ユーザを削除
  Future<void> deleteCurrentUser() async {
    final Account myAccount = Authentication.myAccount!; // 現在のユーザーを取得
    final myAccountId = myAccount.id; // ユーザーのUIDを取得
    List<TalkRoom?> talkRooms = [];
    String oldImagePath = myAccount.imagePath ?? '';
    print("これがID：　$myAccountId");
    try {
      if (oldImagePath.isNotEmpty) {
        await deleteImage(myAccountId); // deleteImage 関数を呼び出す
      }
      print("これがID：　$myAccountId");
      // ユーザーが投稿したTeamPostとGamePostを削除
      await PostFirestore().deleteAllTeamPostsByUser(myAccountId);
      await PostFirestore().deleteAllGamePostsByUser(myAccountId);

      //各サブコレクションも削除
      await PostFirestore().deleteMyPosts(myAccountId);
      await PostFirestore().deleteMyGamePosts(myAccountId);

      talkRooms = await RoomFirestore().getJoinedRooms(myAccountId);

      for (final talkRoom in talkRooms) {
        if (talkRoom != null) {
          await RoomFirestore.deleteRooms(talkRoom.roomId as String);
        }
      }

      // Firestoreからユーザー情報を削除
      await FirebaseFirestore.instance
          .collection('users')
          .doc(myAccountId)
          .delete();

      print('ユーザー情報を削除しました!');
      await _firebaseAuth.signOut();
      return;
    } catch (e) {
      print('ユーザー削除エラー: $e');
    }
  }

  //古い画像を削除
  Future<void> deleteImage(String userId) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('userImages/$userId');
      await ref.delete();
      print('画像の削除が完了しました');
    } catch (e) {
      print('画像の削除中にエラーが発生しました: $e');
    }
  }

//アイコン用の画像を円状に切り取り
  Future<dynamic> cropImage() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      cropStyle: CropStyle.circle, // 円形に切り抜く
    );
    return croppedFile;
  }

//画像をアップロードする
  Future<String?> uploadImage(String id, File image) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid; // ユーザーのUIDを取得
      final FirebaseStorage storageInstance = FirebaseStorage.instance;

      // ユーザーごとの保存場所を指定するために、ユーザーのUIDを含めたパスを作成します
      final Reference ref =
          storageInstance.ref().child('userImages').child(uid!);

      // 画像ファイルを指定した場所にアップロードします
      await ref.putFile(image);

      // アップロードされた画像のダウンロードURLを取得します
      String downloadUrl = await ref.getDownloadURL();
      print("image_path: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("エラーが出ました $e");
      return null;
    }
  }

//userIdから単一の投稿者の情報を取得する
  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("users") // "users"はFirestoreのコレクション名
          .doc(userId) // user_idに対応するドキュメントを指定
          .get();

      if (userSnapshot.exists) {
        // ドキュメントが存在する場合
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        print(userData);
        return userData;
      } else {
        // ドキュメントが存在しない場合
        return null;
      }
    } catch (e) {
      // エラーハンドリング
      print("ユーザー情報の取得エラー: $e");
      return null;
    }
  }

  //複数の投稿ユーザの情報
  static Future<Map<String, Account>?> getPostUserMap(
      List<String> accountIds) async {
    Map<String, Account> map = {};
    try {
      await Future.forEach(accountIds, (accountId) async {
        var doc = await users.doc(accountId).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Account postAccount = Account(
          name: data["name"],
          id: accountId,
          myToken: data["myToken"],
          imagePath: data["image_path"],
        );
        print("投稿ユーザー情報取得: ${postAccount.id}");
        map[accountId] = postAccount;
      });
      print("投稿ユーザー情報取得完了: $map[accountId]");
      return map;
    } on FirebaseException catch (e) {
      print("投稿ユーザー情報取得失敗");
      return null;
    }
  }

  //アカウント情報を取得
  static Future<Account?> fetchProfile(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        // データが存在する場合の処理
        Account user = Account(
          id: data["user_id"],
          name: data["name"],
          myToken: data["myToken"],
          imagePath: data["image_path"] ?? "",
        );
        return user;
      } else {
        // データが存在しない場合の処理
        print("指定されたユーザーIDに対応するデータが存在しません");
        return null;
      }
    } on FirebaseException catch (e) {
      // 通信障害やFirebase関連のエラーが発生した場合の処理
      print("ユーザー取得エラー$e");
    } catch (e) {
      // それ以外の予期しない例外が発生した場合の処理
      print("予期しないエラーが発生しました: $e");
    }
    return null;
  }

  Future<void> deleteUserImage(String imagePath, String myAccountId) async {
    try {
      // usersコレクションから特定のドキュメントを参照
      var userDoc = users.doc(myAccountId);

      // 特定のドキュメント内のimage_pathフィールドをnullに設定
      await userDoc.update({"image_path": null});

      print("image_pathを削除しました");
    } catch (e) {
      print("image_pathの削除に失敗しました: $e");
    }
  }
}
