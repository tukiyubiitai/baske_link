import 'package:cloud_firestore/cloud_firestore.dart';

class PostFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;

  static final CollectionReference users =
      _firestoreInstance.collection("users");

  static final CollectionReference gamePosts =
      _firestoreInstance.collection('gamePosts');

  static final CollectionReference teamPosts =
      _firestoreInstance.collection("teamPosts");

  Future<void> deleteAllTeamPostsByUser(String userId) async {
    QuerySnapshot querySnapshot = await PostFirestore.teamPosts
        .where("post_account_id", isEqualTo: userId)
        .get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // 削除するデータを特定し、削除
      await PostFirestore.teamPosts.doc(doc.id).delete();
    }

    print('ユーザーのTeamPostsを削除しました!');
  }

  //アカウントを削除する際にユーザーのIDを取得することで該当するGamePostsをすべて削除する
  Future<void> deleteAllGamePostsByUser(String userId) async {
    QuerySnapshot querySnapshot =
        await gamePosts.where("post_account_id", isEqualTo: userId).get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // 削除するデータを特定し、削除
      await gamePosts.doc(doc.id).delete();
    }

    print('ユーザーのGamePostsを削除しました!');
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
