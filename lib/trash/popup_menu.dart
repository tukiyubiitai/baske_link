// import 'package:basketball_app/account/model/account.dart';
// import 'package:basketball_app/post/screens/team_post_page.dart';
// import 'package:flutter/material.dart';
//
// import '../../authentication/authentication_page.dart';
// import '../../authentication/utils/authentication.dart';
// import '../../post/post_report.dart';
// import '../../post/repository/posts_firebase.dart';
// import '../../post/screens/game_post_page.dart';
// import '../../talk/repository/room_firebase.dart';
// import '../../widgets/common_widgets/dialogs.dart';
// import '../../widgets/common_widgets/report_dialog.dart';
// import '../../widgets/common_widgets/snackbar_utils.dart';
// import '../repository/users_firebase.dart';
//
// class Choice {
//   const Choice({required this.title, required this.icon});
//
//   final String title;
//   final IconData icon;
// }
//
// const List<Choice> userChoices = <Choice>[
//   Choice(title: 'ログアウト', icon: Icons.logout),
//   Choice(title: 'アカウント削除', icon: Icons.cancel),
// ];
//
// const List<Choice> postsChoices = <Choice>[
//   Choice(title: '編集する', icon: Icons.edit),
//   Choice(title: '投稿削除', icon: Icons.delete),
// ];
// const List<Choice> userBlock = <Choice>[
//   Choice(title: 'このユーザーをブロックする', icon: Icons.block),
//   Choice(title: 'このユーザーを報告する', icon: Icons.report),
// ];
// const List<Choice> postBlock = <Choice>[
//   // Choice(title: 'この投稿をブロックする', icon: Icons.block),
//   Choice(title: 'この投稿を報告する', icon: Icons.report),
// ];
//
// //ユーザーをブロックまたは報告
// class UserBlockAndReport extends StatelessWidget {
//   final Account talkUser;
//
//   final String myAccountId;
//
//   final String roomId;
//
//   const UserBlockAndReport(
//       {required this.talkUser,
//       required this.myAccountId,
//       required this.roomId,
//       Key? key});
//
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<Choice>(
//       color: Colors.white,
//       icon: const Icon(
//         Icons.more_horiz,
//         size: 25,
//         color: Colors.white,
//       ),
//       elevation: 50,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(25),
//       ),
//       onSelected: (Choice choice) async {
//         if (choice.title == 'このユーザーをブロックする') {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return CustomAlertDialog(
//                 title: "${talkUser.name} をブロックしますか？",
//                 message: "このユーザーからメッセージが来ることはありません",
//                 confirmButtonText: "ブロックする",
//                 onCancel: () {
//                   Navigator.of(context).pop();
//                 },
//                 onConfirm: () async {
//                   // ユーザーをブロックする処理
//                   await UserFirestore().blockUser(myAccountId, talkUser.id);
//                   //ブロックしたユーザーとのトークルームを削除
//                   await RoomFirestore.deleteRooms(roomId);
//                   showSnackBar(
//                     context: context,
//                     text: 'ユーザーをブロックしました',
//                     backgroundColor: Colors.red,
//                     textColor: Colors.white,
//                   );
//                 },
//               );
//             },
//           );
//         } else if (choice.title == 'このユーザーを報告する') {
//           await showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 //報告のダイアログを表示
//                 return ReportDialog();
//               });
//         }
//       },
//       itemBuilder: (BuildContext context) {
//         return userBlock.map((Choice choice) {
//           return PopupMenuItem<Choice>(
//             value: choice,
//             child: Row(
//               children: [
//                 Icon(
//                   choice.icon,
//                   color: Colors.red,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   choice.title,
//                   style: TextStyle(
//                     color: Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList();
//       },
//     );
//   }
// }
//
// //投稿を報告する
// class PostReport extends StatelessWidget {
//   final String reportedUserId;
//
//   const PostReport(this.reportedUserId, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<Choice>(
//       color: Colors.white,
//       icon: const Icon(
//         Icons.more_horiz,
//         size: 25,
//       ),
//       elevation: 50,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(25),
//       ),
//       onSelected: (Choice choice) async {
//         if (choice.title == 'この投稿を報告する') {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     ReportPostPage(reportedUserId: reportedUserId)),
//           );
//         }
//       },
//       itemBuilder: (BuildContext context) {
//         return postBlock.map((Choice choice) {
//           return PopupMenuItem<Choice>(
//             value: choice,
//             child: Row(
//               children: [
//                 Icon(
//                   choice.icon,
//                   color: Colors.red,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   choice.title,
//                   style: TextStyle(
//                     color: Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList();
//       },
//     );
//   }
// }
//
// //ログアウト　アカウント削除
// class UserActionsMenu extends StatelessWidget {
//   const UserActionsMenu({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<Choice>(
//       color: Colors.white,
//       icon: const Icon(
//         Icons.more_horiz,
//         size: 25,
//       ),
//       elevation: 50,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(25),
//       ),
//       onSelected: (Choice choice) {
//         if (choice.title == 'ログアウト') {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return CustomAlertDialog(
//                 title: "ログアウト",
//                 message: "本当にログアウトしますか？",
//                 confirmButtonText: "はい",
//                 onCancel: () {
//                   Navigator.of(context).pop(); // ダイアログを閉じる
//                 },
//                 onConfirm: () async {
//                   await Authentication.signOut(context: context);
//                   showSnackBar(
//                       context: context,
//                       text: 'ログアウトしました',
//                       backgroundColor: Colors.white,
//                       textColor: Colors.black);
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const LoginAndSignupPage(),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//
//         } else if (choice.title == 'アカウント削除') {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return CustomAlertDialog(
//                 title: "アカウント削除",
//                 message: "データは復元できませんがよろしいですか？",
//                 confirmButtonText: "削除",
//                 onCancel: () {
//                   Navigator.of(context).pop(); // ダイアログを閉じる
//                 },
//                 onConfirm: () async {
//                   await UserFirestore().deleteCurrentUser();
//                   showSnackBar(
//                       context: context,
//                       text: 'アカウントを削除しました',
//                       backgroundColor: Colors.white,
//                       textColor: Colors.black);
//
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const LoginAndSignupPage(),
//                     ),
//                         (route) => false, // すべてのページを破棄するため、falseを返す
//                   );
//                 },
//               );
//             },
//           );
//         }
//       },
//       itemBuilder: (BuildContext context) {
//         return userChoices.map((Choice choice) {
//           return PopupMenuItem<Choice>(
//             value: choice,
//             child: Row(
//               children: [
//                 Icon(
//                   choice.icon,
//                   color: choice.title == 'ログアウト' ? Colors.black : Colors.red,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   choice.title,
//                   style: TextStyle(
//                     color: choice.title == 'ログアウト' ? Colors.black : Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList();
//       },
//     );
//   }
// }
//
// //投稿編集と投稿削除
// class PostsActions extends StatefulWidget {
//   final String postId;
//   final String postType;
//   final String _accountId;
//   final String? imageUrl;
//   final String? headerUrl;
//   final String editingType;
//
//   PostsActions(
//       {super.key,
//       required this.postId,
//       required this.postType,
//       required String accountId,
//       this.imageUrl,
//       this.headerUrl,
//       required this.editingType})
//       : _accountId = accountId;
//
//   @override
//   State<PostsActions> createState() => _PostsActionsState();
// }
//
// class _PostsActionsState extends State<PostsActions> {
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<Choice>(
//       elevation: 50,
//       color: Colors.white,
//       icon: const Icon(
//         Icons.edit,
//         size: 25,
//         color: Colors.white,
//       ),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(25),
//       ),
//       onSelected: (Choice choice) {
//         if (choice.title == '投稿削除') {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return CustomAlertDialog(
//                 title: "投稿削除",
//                 message: "本当に削除しますか？",
//                 confirmButtonText: "削除",
//                 onCancel: () {
//                   Navigator.of(context).pop(); // ダイアログを閉じる
//                 },
//                 onConfirm: () async {
//                   //投稿がどの投稿かを選別する
//                   if (widget.postType == "team") {
//                     String imageUrl = widget.imageUrl ?? '';
//                     String headerUrl = widget.headerUrl ?? '';
//                     //投稿と画像を削除
//                     await PostFirestore().deleteTeamPostsByPostId(
//                         widget.postId, widget._accountId, imageUrl, headerUrl);
//                     if (widget.editingType == "detailPage") {
//                       //detailPageから呼ばれた場合は画面更新と画面遷移が必要
//                       setState(() {});
//                       Navigator.of(context).pop();
//                     }
//                   } else {
//                     String gameUrl = widget.imageUrl ?? '';
//                     //投稿と画像を削除
//                     await PostFirestore().deleteGamePostsByPostId(
//                         widget.postId, widget._accountId, gameUrl);
//                     if (widget.editingType == "detailPage") {
//                       //detailPageから呼ばれた場合は画面更新と画面遷移が必要
//                       setState(() {});
//                       Navigator.of(context).pop();
//                     }
//                   }
//                 },
//               );
//             },
//           );
//         } else if (choice.title == "編集する") {
//           //投稿がどの投稿かを選別する
//           if (widget.postType == "team") {
//             Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//               return TeamPostPage(
//                 isEditing: true,
//                 postId: widget.postId,
//               );
//             }));
//           } else {
//             Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//               return GamePostPage(
//                 isEditing: true,
//                 postId: widget.postId,
//               );
//             }));
//           }
//         }
//       },
//       itemBuilder: (BuildContext context) {
//         return postsChoices.map((Choice choice) {
//           return PopupMenuItem<Choice>(
//             value: choice,
//             child: Row(
//               children: [
//                 Icon(
//                   choice.icon,
//                   color: choice.title == '編集する' ? Colors.black : Colors.red,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   choice.title,
//                   style: TextStyle(
//                     color: choice.title == '編集する' ? Colors.black : Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList();
//       },
//     );
//   }
// }
