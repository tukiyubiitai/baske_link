import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/game_model.dart';
import '../models/team_model.dart';

//投稿をfirestoreに保存したり、それを取得する

class PostFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;

  static final CollectionReference users =
      _firestoreInstance.collection("users");

  static final CollectionReference teamPosts =
      _firestoreInstance.collection("teamPosts");

  static final CollectionReference gamePosts =
      _firestoreInstance.collection('gamePosts');

  //チームメンバー募集投稿を保存
  static Future<dynamic> teamAddPost(TeamPost newTeamPost) async {
    try {
      //サブコレクションを作成
      //_userPosts = my_posts
      final CollectionReference userPosts =
          users.doc(newTeamPost.postAccountId).collection("my_posts");

      //teamPosts コレクションに新しいドキュメントとして保存されます。
      var result = await teamPosts.add({
        "post_account_id": newTeamPost.postAccountId,
        "location": newTeamPost.locationTagList,
        "created_time": Timestamp.now(),
        "prefecture": newTeamPost.prefecture,
        "goal": newTeamPost.goal,
        "activityTime": newTeamPost.activityTime,
        "memberCount": newTeamPost.memberCount,
        "teamName": newTeamPost.teamName,
        "age": newTeamPost.ageList,
        "searchCriteria": newTeamPost.searchCriteria,
        "headerUrl": newTeamPost.headerUrl,
        "cost": newTeamPost.cost,
        "imageUrl": newTeamPost.imageUrl,
        "target": newTeamPost.targetList,
        "note": newTeamPost.note,
        "prefectureAndLocation": newTeamPost.prefectureAndLocation,
        "type": newTeamPost.type,
      });

      //特定のユーザーの my_posts サブコレクション内の新しいドキュメントとして保存
      //result.id = teamPostに追加されたドキュメントID
      userPosts.doc(result.id).set({
        "post_id": result.id,
        "location": newTeamPost.locationTagList,
        "created_time": Timestamp.now(),
        "prefecture": newTeamPost.prefecture,
        "goal": newTeamPost.goal,
        "activityTime": newTeamPost.activityTime,
        "memberCount": newTeamPost.memberCount,
        "teamName": newTeamPost.teamName,
        "age": newTeamPost.ageList,
        "searchCriteria": newTeamPost.searchCriteria,
        "headerUrl": newTeamPost.headerUrl,
        "cost": newTeamPost.cost,
        "imageUrl": newTeamPost.imageUrl,
        "target": newTeamPost.targetList,
        "note": newTeamPost.note,
        "prefectureAndLocation": newTeamPost.prefectureAndLocation,
        "type": newTeamPost.type,
      });
      print("投稿完了");
      return true;
    } on FirebaseException catch (e) {
      print("投稿エラー $e");
      return false;
    }
  }

  //練習試合の投稿を保存
  static Future<dynamic> gameAddPost(GamePost newGamePost) async {
    try {
      final CollectionReference userPosts =
          users.doc(newGamePost.postAccountId).collection("my_game_posts");
      var result = await gamePosts.add({
        "post_account_id": newGamePost.postAccountId,
        "locationTagList": newGamePost.locationTagList,
        "prefecture": newGamePost.prefecture,
        "level": newGamePost.level,
        "teamName": newGamePost.teamName,
        "member": newGamePost.member,
        "ageList": newGamePost.ageList,
        "created_time": Timestamp.now(),
        "imageUrl": newGamePost.imageUrl,
        "note": newGamePost.note,
        "type": newGamePost.type,
      });
      userPosts.doc(result.id).set({
        "post_id": result.id,
        "locationTagList": newGamePost.locationTagList,
        "prefecture": newGamePost.prefecture,
        "level": newGamePost.level,
        "teamName": newGamePost.teamName,
        "member": newGamePost.member,
        "ageList": newGamePost.ageList,
        "created_time": Timestamp.now(),
        "imageUrl": newGamePost.imageUrl,
        "note": newGamePost.note,
        "type": newGamePost.type,
      });
      print("投稿完了");
      return true;
    } on FirebaseException catch (e) {
      print("投稿エラー $e");
      return false;
    }
  }

  //自分のチームメンバー募集投稿を取得
  static Future<List<TeamPost>?> getMyTeamPostFromIds(List<String> ids) async {
    List<TeamPost> teamPostList = [];
    try {
      // ids = ドキュメントIDが複数入ったリスト
      await Future.forEach(ids, (String id) async {
        //teamPostsに一致するidがあれば、その情報を取得
        var doc = await teamPosts.doc(id).get();
        //Firestoreから取得したデータ（doc）は、動的な性質を持っており、異なる型のデータを含むことがあるため、
        // 取得したデータを型安全な方法で操作するために、データを Map<String, dynamic> 型に変換しています。
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<String> locationTagList = List<String>.from(data["location"]);
        List<String> targetList = List<String>.from(data["target"]);
        List<String> ageList = List<String>.from(data["age"]);
        List<String> prefectureAndLocation = [
          ...locationTagList,
          data["prefecture"]
        ];
        // 投稿情報を取得してTeamPostオブジェクトを作成
        TeamPost post = TeamPost(
          id: doc.id,
          postAccountId: data["post_account_id"],
          locationTagList: locationTagList,
          prefecture: data["prefecture"],
          goal: data["goal"],
          activityTime: data["activityTime"],
          memberCount: data["memberCount"],
          teamName: data["teamName"],
          targetList: targetList,
          // List<String>に変換
          ageList: ageList,
          // List<String>に変換
          note: data["note"],
          imageUrl: data["imageUrl"],
          createdTime: data["created_time"],
          searchCriteria: data["searchCriteria"],
          cost: data["cost"],
          prefectureAndLocation: prefectureAndLocation,
          headerUrl: data["headerUrl"],
          type: "team",
        );
        teamPostList.add(post);
      });
      print("自分の投稿を取得完了");
      return teamPostList;
    } on FirebaseException catch (e) {
      print("投稿取得エラー: $e");
      return null;
    }
  }

  //自分の練習試合投稿を取得
  static Future<List<GamePost>?> getMyGamePostFromIds(List<String> ids) async {
    List<GamePost> gamePostList = [];
    try {
      await Future.forEach(ids, (String id) async {
        var doc = await gamePosts.doc(id).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<String> locationTagList =
            List<String>.from(data["locationTagList"]);

        List<String> ageList = List<String>.from(data["ageList"]);

        // 投稿情報を取得してTeamPostオブジェクトを作成
        GamePost post = GamePost(
            id: doc.id,
            postAccountId: data["post_account_id"],
            locationTagList: locationTagList,
            teamName: data["teamName"],
            level: data["level"],
            prefecture: data["prefecture"],
            createdTime: data["created_time"],
            member: data["member"],
            ageList: ageList,
            imageUrl: data["imageUrl"],
            note: data["note"],
            type: 'game');
        gamePostList.add(post);
      });
      print("自分の投稿を取得完了");
      return gamePostList;
    } on FirebaseException catch (e) {
      print("投稿取得エラー: $e");
      return null;
    }
  }

  //チームメンバー募集を更新
  static Future<dynamic> updateTeamPost(
      String postId, TeamPost updatedPost) async {
    try {
      await teamPosts.doc(postId).update({
        "location": updatedPost.locationTagList,
        "prefecture": updatedPost.prefecture,
        "goal": updatedPost.goal,
        "activityTime": updatedPost.activityTime,
        "memberCount": updatedPost.memberCount,
        "teamName": updatedPost.teamName,
        "target": updatedPost.targetList,
        "age": updatedPost.ageList,
        "note": updatedPost.note,
        "imageUrl": updatedPost.imageUrl,
        "searchCriteria": updatedPost.searchCriteria,
        "cost": updatedPost.cost,
        "headerUrl": updatedPost.headerUrl,
        "created_time": Timestamp.now(),
        "prefectureAndLocation": [
          ...updatedPost.locationTagList,
          updatedPost.prefecture,
          // "type":updatedPost.
        ],
      });

      // ユーザーの投稿も更新
      final CollectionReference userPosts =
          users.doc(updatedPost.postAccountId).collection("my_posts");

      await userPosts.doc(postId).update({
        "location": updatedPost.locationTagList,
        "prefecture": updatedPost.prefecture,
        "goal": updatedPost.goal,
        "activityTime": updatedPost.activityTime,
        "memberCount": updatedPost.memberCount,
        "teamName": updatedPost.teamName,
        "target": updatedPost.targetList,
        "age": updatedPost.ageList,
        "note": updatedPost.note,
        "imageUrl": updatedPost.imageUrl,
        "searchCriteria": updatedPost.searchCriteria,
        "cost": updatedPost.cost,
        "headerUrl": updatedPost.headerUrl,
        "created_time": Timestamp.now(),
        "prefectureAndLocation": [
          ...updatedPost.locationTagList,
          updatedPost.prefecture
        ],
      });

      print("投稿更新完了");
      return true;
    } on FirebaseException catch (e) {
      print("投稿更新エラー: $e");
      return false;
    }
  }

  //練習試合投稿を更新
  static Future<dynamic> updateGamePost(
      String postId, GamePost updatedPost) async {
    try {
      await gamePosts.doc(postId).update({
        "post_account_id": updatedPost.postAccountId,
        "locationTagList": updatedPost.locationTagList,
        "prefecture": updatedPost.prefecture,
        "level": updatedPost.level,
        "teamName": updatedPost.teamName,
        "member": updatedPost.member,
        "ageList": updatedPost.ageList,
        "created_time": Timestamp.now(),
        "imageUrl": updatedPost.imageUrl,
        "note": updatedPost.note,
      });

      // ユーザーの投稿も更新
      final CollectionReference userPosts =
          users.doc(updatedPost.postAccountId).collection("my_game_posts");

      await userPosts.doc(postId).update({
        "post_account_id": updatedPost.postAccountId,
        "locationTagList": updatedPost.locationTagList,
        "prefecture": updatedPost.prefecture,
        "level": updatedPost.level,
        "teamName": updatedPost.teamName,
        "member": updatedPost.member,
        "ageList": updatedPost.ageList,
        "created_time": Timestamp.now(),
        "imageUrl": updatedPost.imageUrl,
        "note": updatedPost.note,
      });

      print("投稿更新完了");
      return true;
    } on FirebaseException catch (e) {
      print("投稿更新エラー: $e");
      return false;
    }
  }

  // post_account_idからチームメンバー投稿情報を取得する
  static Future<List<TeamPost>?> getTeamPostsByAccountId(
      String postAccountId) async {
    List<TeamPost> posts = [];
    try {
      QuerySnapshot querySnapshot = await teamPosts
          .where("post_account_id", isEqualTo: postAccountId)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<String> locationList = List<String>.from(data["location"]);
        List<String> targetList = List<String>.from(data["target"]);
        List<String> ageList = List<String>.from(data["age"]);
        List<String> prefectureAndLocation = [
          ...locationList,
          data["prefecture"]
        ];
        // 投稿情報を取得してPostInfoオブジェクトを作成
        TeamPost post = TeamPost(
          id: doc.id,
          postAccountId: data["post_account_id"],
          locationTagList: locationList,
          prefecture: data["prefecture"],
          goal: data["goal"],
          activityTime: data["activityTime"],
          memberCount: data["memberCount"],
          teamName: data["teamName"],
          targetList: targetList,
          // List<String>に変換
          ageList: ageList,
          // List<String>に変換
          note: data["note"],
          imageUrl: data["imageUrl"],
          createdTime: data["created_time"],
          searchCriteria: data["searchCriteria"],
          cost: data["cost"],
          prefectureAndLocation: prefectureAndLocation,
          headerUrl: data["headerUrl"],
          type: 'team',
        );
        posts.add(post);
      }

      print("投稿情報取得完了");
      print(posts);

      return posts;
    } on FirebaseException catch (e) {
      print("投稿情報取得エラー: $e");
      return null;
    }
  }

  // ドキュメントidから一致する投稿を取得する
  static Future<List<TeamPost>?> getTeamPostById(String postId) async {
    List<TeamPost> posts = [];
    try {
      QuerySnapshot querySnapshot =
          await teamPosts.where(FieldPath.documentId, isEqualTo: postId).get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<String> locationTagList = List<String>.from(data["location"]);
        List<String> targetList = List<String>.from(data["target"]);
        List<String> ageList = List<String>.from(data["age"]);
        List<String> prefectureAndLocation = [
          ...locationTagList,
          data["prefecture"]
        ];
        // 投稿情報を取得してTeamPostオブジェクトを作成
        TeamPost post = TeamPost(
          id: doc.id,
          postAccountId: data["post_account_id"],
          locationTagList: locationTagList,
          prefecture: data["prefecture"],
          goal: data["goal"],
          activityTime: data["activityTime"],
          memberCount: data["memberCount"],
          teamName: data["teamName"],
          targetList: targetList,
          // List<String>に変換
          ageList: ageList,
          // List<String>に変換
          note: data["note"],
          imageUrl: data["imageUrl"],
          createdTime: data["created_time"],
          searchCriteria: data["searchCriteria"],
          cost: data["cost"],
          prefectureAndLocation: prefectureAndLocation,
          headerUrl: data["headerUrl"],
          type: 'team',
        );
        posts.add(post);
      }

      print("投稿情報取得完了");
      print(posts);

      return posts;
    } on FirebaseException catch (e) {
      print("投稿情報取得エラー: $e");
      return null;
    }
  }

  //ドキュメントidから一致する投稿を取得する
  static Future<List<GamePost>?> getGamePostFromIds(String postId) async {
    List<GamePost> gamePostList = [];
    try {
      QuerySnapshot querySnapshot =
          await gamePosts.where(FieldPath.documentId, isEqualTo: postId).get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<String> locationTagList =
            List<String>.from(data["locationTagList"]);
        List<String> ageList = List<String>.from(data["ageList"]);
        GamePost post = GamePost(
            postAccountId: data["post_account_id"],
            locationTagList: locationTagList,
            teamName: data["teamName"],
            level: data["level"],
            prefecture: data["prefecture"],
            createdTime: data["created_time"],
            member: data["member"],
            ageList: ageList,
            imageUrl: data["imageUrl"],
            note: data["note"],
            type: 'game');
        gamePostList.add(post);
      }
      print("自分の投稿を取得完了");
      return gamePostList;
    } on FirebaseException catch (e) {
      print("投稿取得エラー: $e");
      return null;
    }
  }

  //画像をアップロード
  static Future<String?> uploadImage(
      String? imagePath, String? defaultValue) async {
    if (imagePath != null) {
      //新しく画像を追加した場合
      if (defaultValue != null) {
        //古い画像をstorageから削除
        await PostFirestore().deletePhotoData(defaultValue);
      }
      //新しく画像を追加した場合をupload
      return await PostFirestore.uploadImageFromPathToFirebaseStorage(
          imagePath);
    } else {
      //新しく画像がない場合は元々の画像を返す
      return defaultValue;
    }
  }

  //画像をstorageにアップロード
  static Future<String?> uploadImageFromPathToFirebaseStorage(
      String imagePath) async {
    File imageFile = File(imagePath);

    try {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Firebase Storageのルートリファレンスを取得
      Reference referenceRoot = FirebaseStorage.instance.ref();

      // アップロードする画像ファイルのパスを指定
      Reference referenceDirImages =
          referenceRoot.child('images/$uniqueFileName');

      // 画像ファイルをアップロード
      await referenceDirImages.putFile(imageFile);

      // アップロード後のダウンロードURLを取得
      String downloadURL = await referenceDirImages.getDownloadURL();
      print('Image uploaded to Firebase Storage. Download URL: $downloadURL');
      return downloadURL;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

  // Firebase Storageから画像を削除
  Future<void> deletePhotoData(String url) async {
    try {
      final storageReference = FirebaseStorage.instance.refFromURL(url);
      await storageReference.delete();
    } catch (e) {
      print(e);
    }
  }

  //投稿IDから一致するTeamPostsの投稿とusersサブコレクションmy_postsのを削除
  Future<void> deleteTeamPostsByPostId(String postId, String myAccountId,
      String imageUrl, String headerUrl) async {
    try {
      if (imageUrl.isNotEmpty) {
        await PostFirestore().deletePhotoData(imageUrl.toString());
      }
      if (headerUrl.isNotEmpty) {
        await PostFirestore().deletePhotoData(headerUrl.toString());
      }
      QuerySnapshot querySnapshot = await teamPosts.get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // 各ドキュメントのIDと指定したpostIdが一致するかを確認
        if (doc.id == postId) {
          await doc.reference.delete();
        }
      }

      print('ユーザーのTeamPostsを削除しました!');
    } on FirebaseException catch (e) {
      print('TeamPosts削除エラー: $e');
    }
    try {
      // usersコレクション内のmy_game_postsサブコレクションを参照
      var collection = users.doc(myAccountId).collection("my_posts");

      // サブコレクション内の投稿をクエリして一致するものを削除
      QuerySnapshot snapshots =
          await collection.where("post_id", isEqualTo: postId).get();
      for (QueryDocumentSnapshot doc in snapshots.docs) {
        // 各ドキュメントのIDと指定したpostIdが一致するかを確認
        if (doc.id == postId) {
          await doc.reference.delete();
        }
      }
      print("my_postsから投稿を削除しました");
    } catch (e) {
      print("my_postsの削除に失敗しました: $e");
    }
  }

  //投稿IDから一致するGamePostsの投稿を削除とusersサブコレクションmy_game_postsのを削除
  Future<void> deleteGamePostsByPostId(
      String postId, String myAccountId, String imageUrl) async {
    try {
      if (imageUrl.isNotEmpty) {
        await PostFirestore().deletePhotoData(imageUrl.toString());
      }
      QuerySnapshot querySnapshot = await gamePosts.get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // 各ドキュメントのIDと指定したpostIdが一致するかを確認
        if (doc.id == postId) {
          await doc.reference.delete();
        }
      }

      print('ユーザーのGamePostsを削除しました!');
    } on FirebaseException catch (e) {
      print('GamePosts削除エラー: $e');
    }
    try {
      // usersコレクション内のmy_game_postsサブコレクションを参照
      var collection = users.doc(myAccountId).collection("my_game_posts");

      // サブコレクション内の投稿をクエリして一致するものを削除
      QuerySnapshot snapshots =
          await collection.where("post_id", isEqualTo: postId).get();
      for (QueryDocumentSnapshot doc in snapshots.docs) {
        // 各ドキュメントのIDと指定したpostIdが一致するかを確認
        if (doc.id == postId) {
          await doc.reference.delete();
        }
      }

      print("my_game_postsから投稿を削除しました");
    } catch (e) {
      print("my_game_postsの削除に失敗しました: $e");
    }
  }

  //アカウントを削除する際にユーザーのIDを取得することで該当するTeamPostsをすべて削除する
  Future<void> deleteAllTeamPostsByUser(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await teamPosts.where("post_account_id", isEqualTo: userId).get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // 削除するデータを特定し、削除
        await teamPosts.doc(doc.id).delete();
      }

      print('ユーザーのTeamPostsを削除しました!');
    } on FirebaseException catch (e) {
      print('TeamPosts削除エラー: $e');
    }
  }

  //アカウントを削除する際にユーザーのIDを取得することで該当するGamePostsをすべて削除する
  Future<void> deleteAllGamePostsByUser(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await gamePosts.where("post_account_id", isEqualTo: userId).get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // 削除するデータを特定し、削除
        await gamePosts.doc(doc.id).delete();
      }

      print('ユーザーのGamePostsを削除しました!');
    } on FirebaseException catch (e) {
      print('GamePosts削除エラー: $e');
    }
  }

  //サブコレクション(my_posts)の削除
  Future<void> deleteMyPosts(String myAccountId) async {
    var collection = users.doc(myAccountId).collection("my_posts");
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
    print("my_posts削除完了");
  }

  //サブコレクション(my_game_posts)の削除
  Future<void> deleteMyGamePosts(String myAccountId) async {
    var collection = users.doc(myAccountId).collection("my_game_posts");
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
    print("my_game_posts削除完了");
  }
}
