import 'package:basketball_app/infrastructure/firebase/posts_firebase.dart';
import 'package:basketball_app/infrastructure/firebase/room_firebase.dart';
import 'package:basketball_app/infrastructure/firebase/storage_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

import '../../models/account/account.dart';
import '../../models/talk/talkroom.dart';
import '../../utils/error_handler.dart';
import 'authentication_service.dart';

class AccountFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users =
      _firestoreInstance.collection("users");

  final fcm = FirebaseMessaging.instance;

  final auth = FirebaseAuth.instance;

  //現在のユーザー情報の取得
  static Future<User?> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  // アカウントデータの取得
  static Future<Map<String, Account>> fetchAccountsData(
      List<String> accountIds) async {
    try {
      Map<String, Account> userData = {};

      // 各アカウントIDに対する非同期クエリを準備
      var fetchTasks = <Future<DocumentSnapshot>>[];
      for (String accountId in accountIds) {
        if (!userData.containsKey(accountId)) {
          fetchTasks.add(users.doc(accountId).get());
        }
      }

      // すべてのクエリを並行して実行
      var results = await Future.wait(fetchTasks);

      // 各クエリの結果を処理
      for (var result in results) {
        var userDataMap = result.data() as Map<String, dynamic>;
        String accountId = result.id;
        userData[accountId] = Account(
          name: userDataMap["name"],
          id: accountId,
          myToken: userDataMap["myToken"],
          imagePath: userDataMap["image_path"],
        );
      }

      return userData;
    } catch (e) {
      Logger().e("アカウント取得に失敗: ${getErrorMessage(e)}");
      throw DataLayerException(getErrorMessage(e));
    }
  }

  // ユーザーアカウント更新データを作成、Accountオブジェクトとして返す
  static Future<Account> prepareUpdatedUserAccountData(
      String userId,
      String name,
      String? imagePath,
      bool isImageDeleted,
      String oldImagePath) async {
    try {
      String? uploadedImageUrl;
      // 新しい画像が追加された場合
      if (imagePath != null &&
          imagePath.isNotEmpty &&
          imagePath != oldImagePath) {
        // 既存の画像があれば削除
        if (oldImagePath.isNotEmpty) {
          await ImageManager.deleteImage(oldImagePath);
        }
        // 新しい画像をアップロード
        String? directory = 'userImages';
        uploadedImageUrl =
            await ImageManager.uploadImage(imagePath, directory: directory);
      } else if (isImageDeleted) {
        // 画像が削除された場合
        uploadedImageUrl = null;
        await ImageManager.deleteImage(oldImagePath);
      }
      // 新しい画像URLがある場合はそれを使用し、ない場合は既存の画像URLを使用
      Account updateAccount = Account(
        id: userId,
        name: name,
        imagePath: uploadedImageUrl ?? oldImagePath,
      );
      return updateAccount;
    } catch (e) {
      Logger().e("ユーザー更新失敗: ${getErrorMessage(e)}");
      throw DataLayerException(getErrorMessage(e));
    }
  }

  //userIdからユーザー情報の取得処理
  static Future<Account?> fetchUserData(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await users.doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;
        return Account(
          id: data["user_id"],
          name: data["name"],
          myToken: data["myToken"] ?? "",
          imagePath: data["imagePath"] ?? "",
        );
      }
    } catch (e) {
      Logger().e("ユーザー情報取得に失敗: ${getErrorMessage(e)}");
      throw DataLayerException(getErrorMessage(e));
    }
    return null;
  }

  //アカウント情報を取得して、そのユーザが存在するか確認する
  static Future<bool> checkUserExists(
    String uid,
  ) async {
    //ユーザー情報を取得
    Account? account = await fetchUserData(uid);
    if (account != null) {
      //ユーザー情報を更新
      AuthenticationService.updateMyAccount(account);
      return true;
    } else {
      return false;
    }
  }

  //ブロックリストに追加処理
  Future<bool> blockUser(String myAccountId, String blockedUserId) async {
    try {
      //ユーザードキュメント取得
      final userDoc = await users.doc(myAccountId).get();

      if (userDoc.exists) {
        // ドキュメントからデータを取得し、Map型にキャスト
        final data = userDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          // ブロックリストを取得（存在しない場合は空のリストを使用）
          final blockList =
              (data['blockList'] as List<dynamic>?)?.cast<String>() ?? [];

          // ユーザーがブロックリストに含まれていない場合に追加
          if (!blockList.contains(blockedUserId)) {
            // ユーザーのブロックリストにブロックするユーザーIDを追加
            await users.doc(myAccountId).update({
              "blockList": FieldValue.arrayUnion([blockedUserId])
            });
          }
          // ブロック処理が成功したことを示すためにtrueを返す
          return true;
        }
      }
      return false;
    } catch (e) {
      Logger().e("ブロックリスト追加エラー: ${getErrorMessage(e)}");
      throw DataLayerException(getErrorMessage(e));
    }
  }

  //相手のfirestoreから自分のuserIdがblockListに入っていないかを確認する
  //ブロックされているとtrueを返す
  Future<bool> isBlocked(String talkUserId, String checkUserId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(talkUserId)
        .get();

    if (!userDoc.exists) {
      print('User does not exist');
      return false; // ユーザーが存在しない場合
    }

    final data = userDoc.data();
    final blockList =
        (data?['blockList'] as List<dynamic>?)?.cast<String>() ?? [];
    return blockList.contains(checkUserId); // ブロックリストに含まれているかどうか
  }

  //アカウント保存処理
  Future<bool> saveNewUserToFirestore(Account newAccount) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(newAccount.id)
          .set({
        "user_id": newAccount.id,
        'name': newAccount.name,
        'myToken': newAccount.myToken,
        'imagePath': newAccount.imagePath
      });
      AuthenticationService.updateMyAccount(newAccount);
      print("ユーザー登録完了");
      return true;
    } catch (e) {
      Logger().e("ユーザー登録失敗: ${getErrorMessage(e)}");
      throw DataLayerException(getErrorMessage(e));
    }
  }

  //ユーザー更新情報をfirestoreに保存
  Future<bool> saveUpdatedUserToFirestore(Account updateAccount) async {
    try {
      await users.doc(updateAccount.id).update({
        "name": updateAccount.name,
        "user_id": updateAccount.id,
        "imagePath": updateAccount.imagePath,
      });
      AuthenticationService.updateMyAccount(updateAccount);
      print("ユーザー更新完了");
      return true;
    } catch (e) {
      Logger().e("ユーザー更新失敗: $e,");
      throw DataLayerException(getErrorMessage(e));
    }
  }

  Future<bool> deleteCurrentUser(Account myAccount) async {
    final myAccountId = myAccount.id; // ユーザーのUIDを取得
    List<TalkRoom?> talkRooms = [];
    String oldImagePath = myAccount.imagePath ?? '';
    try {
      if (oldImagePath.isNotEmpty) {
        await ImageManager.deleteImage(oldImagePath); // deleteImage 関数を呼び出す
      }
      // ユーザーが投稿したTeamPostとGamePostを削除
      await PostFirestore().deleteAllTeamPostsByUser(myAccountId);
      await PostFirestore().deleteAllGamePostsByUser(myAccountId);

      //各サブコレクションも削除
      await PostFirestore().deleteMyPosts(myAccountId);
      await PostFirestore().deleteMyGamePosts(myAccountId);

      talkRooms = await RoomFirestore().getJoinedRooms(myAccountId);

      for (final talkRoom in talkRooms) {
        if (talkRoom != null) {
          //トークルーム削除
          await RoomFirestore()
              .deleteRoomAndSubCollections(talkRoom.roomId as String);
        }
      }

      // Firestoreからユーザー情報を削除
      await FirebaseFirestore.instance
          .collection('users')
          .doc(myAccountId)
          .delete();

      print('ユーザー情報を削除しました!');
      await auth.signOut();
      return true;
    } catch (e) {
      Logger().e("ユーザー削除失敗: $e,");
      throw DataLayerException(getErrorMessage(e));
    }
  }

  //複数の投稿ユーザの情報
  static Future<Map<String, Account>?> getPostUserMap(
      List<String> accountIds) async {
    Map<String, Account> map = {};

    // 各accountIdに対する非同期処理を一度に開始
    await Future.wait(accountIds.map((accountId) async {
      var doc = await users.doc(accountId).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Account postAccount = Account(
        name: data["name"],
        id: accountId,
        myToken: data["myToken"],
        imagePath: data["imagePath"],
      );
      map[accountId] = postAccount;
    }));

    return map;
  }
}
