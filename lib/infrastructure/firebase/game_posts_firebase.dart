import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/account/account.dart';
import '../../models/posts/game_model.dart';
import '../../utils/error_handler.dart';
import 'account_firebase.dart';

class GamePostFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;

  static final CollectionReference users =
      _firestoreInstance.collection("users");

  static final CollectionReference gamePosts =
      _firestoreInstance.collection('gamePosts');

//gamePost保存
  static Future<bool> gameAddPost(GamePost newGamePost) async {
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
      "imageUrl": newGamePost.imagePath,
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
      "imageUrl": newGamePost.imagePath,
      "note": newGamePost.note,
      "type": newGamePost.type,
    });
    print("投稿完了");
    return true;
  }

//gamePost更新
  static Future<bool> updateGameInDatabase(
      String postId, GamePost updatedPost) async {
    await gamePosts.doc(postId).update({
      "post_account_id": updatedPost.postAccountId,
      "locationTagList": updatedPost.locationTagList,
      "prefecture": updatedPost.prefecture,
      "level": updatedPost.level,
      "teamName": updatedPost.teamName,
      "member": updatedPost.member,
      "ageList": updatedPost.ageList,
      "created_time": Timestamp.now(),
      "imageUrl": updatedPost.imagePath,
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
      "imageUrl": updatedPost.imagePath,
      "note": updatedPost.note,
    });

    print("投稿更新完了");
    return true;
  }

  Future<GamePostData> fetchGamePosts(Query query) async {
    try {
      // Firestoreクエリを実行し、結果を取得
      final result = await query.get();
      Map<String, Account> userData = {};
      List<GamePost> gamePostList = [];
      List<String> accountIds = [];

      // Firestoreから取得した各ドキュメントに対して処理を行う
      for (var doc in result.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String accountId = data["post_account_id"];
        accountIds.add(accountId);

        // 投稿データをGamePostオブジェクトに変換し、リストに追加
        gamePostList.add(GamePost.fromFirestore(doc));
      }
      // アカウントデータの取得
      userData = await AccountFirestore.fetchAccountsData(accountIds);
      // 投稿データとユーザーデータを含むTeamPostDataオブジェクトを作成して返す
      return GamePostData(posts: gamePostList, users: userData);
    } catch (e) {
      // エラーの記録や適切なエラーハンドリングをここに追加
      print('データの取得に失敗しました: $e');
      // 必要に応じてカスタムエラーを投げるか、nullや空のデータを返す
      throw e;
    }
  }

  //gamePost取得
  Future<GamePostData> getGamePosts() async {
    try {
      // Firestoreからチームの投稿データを取得
      final query = gamePosts.orderBy("created_time", descending: true);
      GamePostData gamePostData = await fetchGamePosts(query);
      return gamePostData;
    } catch (e) {
      print("投稿読み込みエラー　${getErrorMessage(e)}");
      throw e;
    }
  }

//自分のgamePostを取得
  Future<List<GamePost>?> getMyGamePostFromIds(List<String> postIds) async {
    try {
      // 各投稿IDに対応するFirebaseドキュメントのFutureを作成し、リストに格納
      var gamePostFutures =
          postIds.map((id) => gamePosts.doc(id).get()).toList();

      // すべての非同期処理（Firebaseからのデータ取得）が完了するのを待つ
      var docs = await Future.wait(gamePostFutures);

      // 取得したドキュメントからGamePostオブジェクトを作成
      var gamePostList = docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        List<String> locationTagList =
            List<String>.from(data["locationTagList"]);
        List<String> ageList = List<String>.from(data["ageList"]);

        // データ変換してGamePostオブジェクトを作成
        return GamePost(
            id: doc.id,
            postAccountId: data["post_account_id"],
            locationTagList: locationTagList,
            teamName: data["teamName"],
            level: data["level"],
            prefecture: data["prefecture"],
            createdTime: data["created_time"],
            member: data["member"],
            ageList: ageList,
            imagePath: data["imageUrl"],
            note: data["note"],
            type: 'game');
      }).toList();

      print("自分のGamePostを取得完了");
      return gamePostList;
    } on FirebaseException catch (e) {
      print("投稿取得エラー: ${getErrorMessage(e)}");
      throw e;
    }
  }

// gamePost編集の読み込み
  Future<List<GamePost>?> getGamePostFromIds(String postId) async {
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
          imagePath: data["imageUrl"],
          note: data["note"],
          type: 'game',
        );
        gamePostList.add(post);
      }
      print("GamePostを取得完了FromIds");
      return gamePostList;
    } catch (e) {
      print("投稿取得エラー: $e");
      throw e;
    }
  }
}
