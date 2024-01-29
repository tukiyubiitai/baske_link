// import 'package:basketball_app/infrastructure/firebase/posts_firebase.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
// import '../../../../domain/types/account/account.dart';
// import '../../../../domain/types/posts/team_model.dart';
//
// part 'team_post_provider.g.dart';
//
// @riverpod
// class TeamPostNotifier extends _$TeamPostNotifier {
//   @override
//   Future<TeamPostData> build() async {
//     // Firestoreからチームの投稿データを取得
//     final postSnapshot = await PostFirestore.teamPosts
//         .orderBy("created_time", descending: true)
//         .get();
//
//     // ユーザーデータと投稿データを保存するためのマップとリスト
//     Map<String, Account> userData = {};
//     List<TeamPost> teamPostList = [];
//
//     // 取得した投稿データに対する処理
//     for (var doc in postSnapshot.docs) {
//       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//       String accountId = data["post_account_id"];
//
//       // userDataにまだ含まれていないアカウントIDのユーザーデータを取得
//       if (!userData.containsKey(accountId)) {
//         var userDoc = await FirebaseFirestore.instance
//             .collection("users")
//             .doc(accountId)
//             .get();
//         Map<String, dynamic> userDataMap =
//             userDoc.data() as Map<String, dynamic>;
//         userData[accountId] = Account(
//           name: userDataMap["name"],
//           id: accountId,
//           myToken: userDataMap["myToken"],
//           imagePath: userDataMap["image_path"],
//         );
//       }
//       // 投稿データをリストに追加
//       teamPostList.add(TeamPost.fromFirestore(doc));
//     }
//
//     // 投稿データとユーザーデータを含む新しいオブジェクトを作成
//     TeamPostData teamPostData =
//         TeamPostData(posts: teamPostList, users: userData);
//
//     // UI用に投稿リストとユーザーデータを更新
//     return teamPostData;
//   }
//
// // ユーザーデータの再読み込みを行うメソッド
//   Future<void> reloadTeamPostData() async {
//     final newTeamPostData = await build();
//     state = AsyncValue.data(newTeamPostData);
//   }
// }
