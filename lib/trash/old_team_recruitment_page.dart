// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../../models/account/account.dart';
// import '../../services/posts_firebase.dart';
// import '../../services/users_firebase.dart';
// import '../../utils/snackbar_utils.dart';
// import '../../widgets/modal_sheet.dart';
// import '../../widgets/progress_indicator.dart';
// import '../../widgets/teams/team_post_item.dart';
//
// class TeamRecruitmentPage extends StatelessWidget {
//   const TeamRecruitmentPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.indigo[900],
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.indigoAccent,
//         //絞り込み検索
//         onPressed: () {
//           showModalBottomSheet<String>(
//             backgroundColor: Colors.transparent,
//             isScrollControlled: true,
//             context: context,
//             builder: (context) {
//               return StatefulBuilder(
//                   builder: (BuildContext context, Function setSheetState) {
//                 return ModalBottomSheetContent(
//                   type: 'team',
//                 );
//               });
//             },
//           );
//         },
//         child: const Icon(Icons.manage_search),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//                 stream: PostFirestore.teamPosts
//                     .orderBy("created_time", descending: true)
//                     .snapshots(),
//                 builder: (context, postSnapshot) {
//                   if (postSnapshot.connectionState == ConnectionState.waiting) {
//                     // データが読み込まれていない状態
//                     return ShowProgressIndicator(
//                       textColor: Colors.black,
//                       indicatorColor: Colors.indigo,
//                     );
//                   } else if (postSnapshot.hasError) {
//                     showErrorSnackBar(context: context, text: 'エラーが発生しました');
//
//                     // エラーが発生した場合
//                     return Center(
//                       child: Text(
//                         "データの読み込み中にエラーが発生しました ${postSnapshot.error}",
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     );
//                   } else if (!postSnapshot.hasData ||
//                       postSnapshot.data!.docs.isEmpty) {
//                     // データが存在しない場合
//                     return const Center(
//                       child: Text(
//                         "何も投稿がありません",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     );
//                   } else {
//                     //投稿を繰り返し取得しpost_account_idを取得する
//                     List<String> postAccountIds = [];
//                     for (var doc in postSnapshot.data!.docs) {
//                       Map<String, dynamic> data =
//                           doc.data() as Map<String, dynamic>;
//                       if (!postAccountIds.contains(data["post_account_id"])) {
//                         postAccountIds.add(data["post_account_id"]);
//                         print("これがpostAccountIds: $postAccountIds");
//                       }
//                     }
//                     return FutureBuilder<Map<String, Account>?>(
//                         future: UserFirestore.getPostUserMap(postAccountIds),
//                         builder: (context, userSnapshot) {
//                           //ユーザー情報の取得が完了しているかどうかをチェック
//                           if (userSnapshot.hasData &&
//                               userSnapshot.connectionState ==
//                                   ConnectionState.done) {
//                             Map<String, Account>? userData = userSnapshot.data;
//                             return ListView.builder(
//                               itemCount: postSnapshot.data!.docs.length,
//                               // データの長さを指定
//                               itemBuilder: (BuildContext context, int index) {
//                                 Map<String, dynamic> postData =
//                                     postSnapshot.data!.docs[index].data()
//                                         as Map<String, dynamic>;
//                                 return TeamPostItem(
//                                   //投稿のid
//                                   postId: postSnapshot.data!.docs[index].id,
//                                   //投稿のデータ
//                                   postData: postData,
//                                   //自分のId
//                                   userData: userData as Map<String, Account>,
//                                 );
//                               },
//                             );
//                           } else if (userSnapshot.hasError) {
//                             return Center(
//                               child: Text(
//                                 "データの読み込み中にエラーが発生しました ${userSnapshot.hasError}",
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             );
//                           } else {
//                             return ShowProgressIndicator(
//                               textColor: Colors.black,
//                               indicatorColor: Colors.indigo,
//                             );
//                           }
//                         });
//                   }
//                 }),
//           ),
//         ],
//       ),
//     );
//   }
// }
