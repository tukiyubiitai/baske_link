import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/account/account.dart';
import '../../models/posts/team_model.dart';
import 'account_firebase.dart';

class TeamPostFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;

  static final CollectionReference teamPosts =
      _firestoreInstance.collection("teamPosts");
  static final CollectionReference users =
      _firestoreInstance.collection("users");

  static Future<bool> teamAddPost(TeamPost newTeamPost) async {
    //サブコレクションを作成
    //_userPosts = my_posts
    final CollectionReference userPosts =
        users.doc(newTeamPost.postAccountId).collection("my_posts");

    //teamPosts コレクションに新しいドキュメントとして保存されます。
    var result = await teamPosts.add({
      "post_account_id": newTeamPost.postAccountId,
      "locationTagList": newTeamPost.locationTagList,
      "created_time": Timestamp.now(),
      "prefecture": newTeamPost.prefecture,
      "goal": newTeamPost.goal,
      "activityTime": newTeamPost.activityTime,
      "memberCount": newTeamPost.memberCount,
      "teamName": newTeamPost.teamName,
      "age": newTeamPost.ageList,
      "teamAppeal": newTeamPost.teamAppeal,
      "headerUrl": newTeamPost.headerUrl,
      "cost": newTeamPost.cost,
      "imageUrl": newTeamPost.imagePath,
      "target": newTeamPost.targetList,
      "note": newTeamPost.note,
      "type": newTeamPost.type,
    });

    //特定のユーザーの my_posts サブコレクション内の新しいドキュメントとして保存
    //result.id = teamPostに追加されたドキュメントID
    userPosts.doc(result.id).set({
      "post_id": result.id,
      "locationTagList": newTeamPost.locationTagList,
      "created_time": Timestamp.now(),
      "prefecture": newTeamPost.prefecture,
      "goal": newTeamPost.goal,
      "activityTime": newTeamPost.activityTime,
      "memberCount": newTeamPost.memberCount,
      "teamName": newTeamPost.teamName,
      "age": newTeamPost.ageList,
      "teamAppeal": newTeamPost.teamAppeal,
      "headerUrl": newTeamPost.headerUrl,
      "cost": newTeamPost.cost,
      "imageUrl": newTeamPost.imagePath,
      "target": newTeamPost.targetList,
      "note": newTeamPost.note,
      "type": newTeamPost.type,
    });
    print("投稿完了");
    return true;
  }

  //teamPost更新
  static Future<bool> updateTeamInDatabase(
      String postId, TeamPost updatedPost) async {
    await teamPosts.doc(postId).update({
      "locationTagList": updatedPost.locationTagList,
      "prefecture": updatedPost.prefecture,
      "goal": updatedPost.goal,
      "activityTime": updatedPost.activityTime,
      "memberCount": updatedPost.memberCount,
      "teamName": updatedPost.teamName,
      "target": updatedPost.targetList,
      "age": updatedPost.ageList,
      "note": updatedPost.note,
      "imageUrl": updatedPost.imagePath,
      "teamAppeal": updatedPost.teamAppeal,
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
      "locationTagList": updatedPost.locationTagList,
      "prefecture": updatedPost.prefecture,
      "goal": updatedPost.goal,
      "activityTime": updatedPost.activityTime,
      "memberCount": updatedPost.memberCount,
      "teamName": updatedPost.teamName,
      "target": updatedPost.targetList,
      "age": updatedPost.ageList,
      "note": updatedPost.note,
      "imageUrl": updatedPost.imagePath,
      "teamAppeal": updatedPost.teamAppeal,
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
  }

  //teamPost編集の時の読み込み
  Future<List<TeamPost>?> getTeamPostById(String postId) async {
    List<TeamPost> posts = [];

    QuerySnapshot querySnapshot =
        await teamPosts.where(FieldPath.documentId, isEqualTo: postId).get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<String> locationTagList = List<String>.from(data["locationTagList"]);
      List<String> targetList = List<String>.from(data["target"]);
      List<String> ageList = List<String>.from(data["age"]);
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
        imagePath: data["imageUrl"],
        createdTime: data["created_time"],
        teamAppeal: data["teamAppeal"],
        cost: data["cost"],
        headerUrl: data["headerUrl"],
        type: 'team',
      );
      posts.add(post);
    }

    print("投稿情報取得完了");
    print(posts);

    return posts;
  }

  // 投稿データとユーザーデータを含むTeamPostDataを返す
  Future<TeamPostData> fetchTeamPosts(Query query) async {
    final result = await query.get();
    List<Future<Account>> userDataFutures = [];
    List<TeamPost> teamPostList = [];

    for (var doc in result.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String accountId = data["post_account_id"];

      Account? user = await AccountFirestore.fetchUserData(accountId);
      // 各アカウントのデータを取得するFutureをリストに追加
      userDataFutures.add(Future.value(user));
      // 投稿データをTeamPostオブジェクトに変換し、リストに追加
      teamPostList.add(TeamPost.fromFirestore(doc));
    }

    // すべてのユーザーデータのFutureを並列で実行
    List<Account> userData = await Future.wait(userDataFutures);

    // 投稿データとユーザーデータを含むTeamPostDataオブジェクトを作成して返す
    return TeamPostData(posts: teamPostList, users: userData);
  }

  Future<List<TeamPost>?> getMyTeamPostFromIds(List<String> postIds) async {
    // 各投稿IDに対応するFirebaseドキュメントのFutureを作成、リストに格納
    var teamPostFutures = postIds.map((id) => teamPosts.doc(id).get()).toList();

    // すべての非同期処理（Firebaseからのデータ取得）が完了するのを待つ
    var docs = await Future.wait(teamPostFutures);

    // 取得したドキュメントからTeamPostオブジェクトを作成
    var teamPostList = docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;

      List<String> locationTagList = List<String>.from(data["locationTagList"]);
      List<String> targetList = List<String>.from(data["target"]);
      List<String> ageList = List<String>.from(data["age"]);
      // データ変換してTeamPostオブジェクトを作成
      return TeamPost(
        id: doc.id,
        postAccountId: data["post_account_id"],
        locationTagList: locationTagList,
        prefecture: data["prefecture"],
        goal: data["goal"],
        activityTime: data["activityTime"],
        memberCount: data["memberCount"],
        teamName: data["teamName"],
        targetList: targetList,
        ageList: ageList,
        note: data["note"],
        imagePath: data["imageUrl"],
        createdTime: data["created_time"],
        teamAppeal: data["teamAppeal"],
        cost: data["cost"],
        headerUrl: data["headerUrl"],
        type: "team",
      );
    }).toList();

    print("自分のteamPostを取得完了");
    return teamPostList;
  }
}
