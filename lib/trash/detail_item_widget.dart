// import 'package:basketball_app/post/widgets/post_list_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../account/model/account.dart';
// import '../../account/repository/users_firebase.dart';
// import '../../account/widgets/account_circle.dart';
// import '../../account/widgets/popup_menu.dart';
// import '../../authentication/utils/authentication.dart';
// import '../../talk/repository/room_firebase.dart';
// import '../../talk/screens/talk_room.dart';
// import '../model/game_model.dart';
// import '../model/team_model.dart';
//
// class TeamPostDetailItem extends StatefulWidget {
//   final List<TeamPost> posts;
//   final String postId;
//
//   final Account postAccountData;
//
//   const TeamPostDetailItem({
//     super.key,
//     required this.posts,
//     required this.postId,
//     required this.postAccountData,
//   });
//
//   @override
//   State<TeamPostDetailItem> createState() => _TeamPostDetailItemState();
// }
//
// class _TeamPostDetailItemState extends State<TeamPostDetailItem> {
//   @override
//   void initState() {
//     super.initState();
//     if (widget.posts[0].postAccountId == Authentication.myAccount!.id) {
//       isEdited = true;
//     }
//   }
//
//   bool isEdited = false;
//
//   @override
//   Widget build(BuildContext context) {
//     print("これが画像です: ${widget.postAccountData.imagePath}");
//     DateTime createAtDateTime = widget.posts[0].createdTime.toDate();
//     String formattedCreatedAt =
//         DateFormat('yyyy/MM/dd').format(createAtDateTime);
//     return Scaffold(
//       backgroundColor: Colors.indigo[900],
//       appBar: AppBar(
//         title: const Text("詳細ページ"),
//         elevation: 0,
//         backgroundColor: Colors.indigo[900],
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); // 画面遷移を戻る処理
//           },
//         ),
//         actions: [
//           isEdited
//               ? PostsActions(
//                   postId: widget.postId,
//                   postType: widget.posts[0].type,
//                   accountId: widget.posts[0].postAccountId,
//                   imageUrl: widget.posts[0].imageUrl != null
//                       ? widget.posts[0].imageUrl
//                       : null,
//                   headerUrl: widget.posts[0].headerUrl != null
//                       ? widget.posts[0].headerUrl
//                       : null,
//                   editingType: 'detailPage',
//                 )
//               : UserActionsMenu()
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             // 背景画像を配置したい場合
//             Container(
//               margin: const EdgeInsets.all(20),
//               // padding: EdgeInsets.only(right: 13),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.white,
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 5,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(10),
//                         topRight: Radius.circular(10),
//                       ),
//                       child: ColorFiltered(
//                         colorFilter: ColorFilter.mode(
//                           Colors.black.withOpacity(0.5), // 透明度を調整して画像を暗くします
//                           BlendMode.srcATop,
//                         ),
//                         child: widget.posts[0].headerUrl != null
//                             ? Image.network(
//                                 widget.posts[0].headerUrl!,
//                                 width: double.infinity,
//                                 height: 125,
//                                 fit: BoxFit.cover,
//                               )
//                             : Image.asset(
//                                 'assets/images/headerImage.jpg',
//                                 width: double.infinity,
//                                 height: 125,
//                                 fit: BoxFit.cover,
//                               ),
//                       )),
//                   Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           ClipRRect(
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(10),
//                             ),
//                             child: Container(
//                               height: 40,
//                               width: 60,
//                               decoration: const BoxDecoration(
//                                 color: Colors.indigo,
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   widget.posts[0].prefecture,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 "更新日：$formattedCreatedAt",
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 15.0, top: 30),
//                               child: Row(
//                                 children: [
//                                   widget.posts[0].imageUrl != null
//                                       ? ImageCircle(
//                                           imagePath: widget.posts[0].imageUrl!)
//                                       : NoImageCircle(),
//                                   const SizedBox(
//                                     width: 10,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Column(
//                               children: [
//                                 Text(
//                                   widget.posts[0].teamName,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20,
//                                       color: Colors.black),
//                                   overflow: TextOverflow.visible,
//                                   maxLines: 3,
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         widget.posts[0].searchCriteria
//                                             .toString(),
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 16),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             PostIconWithText(
//                               icon: Icons.location_on,
//                               text: widget.posts[0].locationTagList.join(", "),
//                               color: Colors.indigo,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             const SizedBox(height: 5),
//                             PostIconWithText(
//                               icon: Icons.calendar_month,
//                               text: widget.posts[0].activityTime,
//                               color: Colors.black,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             const SizedBox(height: 20),
//                             Container(
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.black12, width: 1.0), // 下線
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             PostIconWithTwoText(
//                                 icon: Icons.groups,
//                                 text1: "メンバー",
//                                 text2: widget.posts[0].memberCount.toString()),
//                             const SizedBox(height: 8),
//                             Container(
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.black12, width: 1.0), // 下線
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             PostIconWithTextWithList(
//                               icon: Icons.group_add,
//                               text: "年齢層",
//                               list: widget.posts[0].ageList,
//                               color: Colors.indigo,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             const SizedBox(height: 8),
//                             Container(
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.black12, width: 1.0), // 下線
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             PostIconWithTextWithList(
//                               icon: Icons.account_circle,
//                               text: "募集中",
//                               list: widget.posts[0].targetList,
//                               color: Colors.black,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             const SizedBox(height: 8),
//                             Container(
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.black12, width: 1.0), // 下線
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             PostIconWithTwoText(
//                                 icon: Icons.currency_yen,
//                                 text1: "費用",
//                                 text2: widget.posts[0].cost.toString()),
//                             const SizedBox(height: 8),
//                             Container(
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.black12, width: 1.0), // 下線
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             PostIconWithTwoText(
//                                 icon: Icons.flag,
//                                 text1: "目標",
//                                 text2: widget.posts[0].goal.toString()),
//                             const SizedBox(height: 8),
//                             Container(
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.black12, width: 1.0), // 下線
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 8,
//                             ),
//                             const Text(
//                               "投稿者",
//                               style: TextStyle(
//                                   color: Colors.orange,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 widget.postAccountData.imagePath != null
//                                     ? Container(
//                                         width: 60,
//                                         height: 60,
//                                         decoration: const BoxDecoration(
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: CircleAvatar(
//                                           radius: 50,
//                                           foregroundImage: NetworkImage(
//                                             widget.postAccountData.imagePath
//                                                 .toString(),
//                                           ),
//                                         ),
//                                       )
//                                     : Container(
//                                         width: 60,
//                                         height: 60,
//                                         decoration: const BoxDecoration(
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: CircleAvatar(
//                                           radius: 50,
//                                           foregroundImage: AssetImage(
//                                             'assets/images/basketball_icon.png',
//                                           ),
//                                         ),
//                                       ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   widget.postAccountData.name,
//                                   style: const TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold),
//                                 )
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             Container(
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.black12, width: 1.0), // 下線
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             const Center(
//                               child: Text(
//                                 "チーム詳細",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 15,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Container(
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 border: Border.all(width: 0.5),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   widget.posts[0].note.toString(),
//                                   overflow: TextOverflow.visible,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Center(
//                               child: TextButton(
//                                 onPressed: () async {
//                                   // ボタンが押されたときの処理
//
//                                   // ダイアログを表示
//                                   showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return AlertDialog(
//                                         title: const Text(
//                                           "トークルームを作成",
//                                           style: TextStyle(
//                                               color: Colors.indigo,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         content: const Text(
//                                             "投稿ユーザーとのトークルームを作成してもよろしいですか？"),
//                                         actions: <Widget>[
//                                           // キャンセルボタン
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.of(context)
//                                                   .pop(); // ダイアログを閉じる
//                                             },
//                                             child: const Text("キャンセル"),
//                                           ),
//                                           // OKボタン
//                                           TextButton(
//                                             onPressed: () async {
//                                               // ダイアログを閉じる
//                                               Navigator.of(context).pop();
//
//                                               // 投稿者のpost_account_idからuserId(user情報)を取得
//                                               final userData =
//                                                   await UserFirestore()
//                                                       .getUserInfo(
//                                                 widget.posts[0].postAccountId,
//                                               );
//
//                                               // 自分のuserIdを取得
//                                               final myUid =
//                                                   Authentication.myAccount!.id;
//
//                                               // chatルーム作成する
//                                               RoomFirestore.createTalkRoom(
//                                                   userData!, myUid);
//
//                                               // トークページに遷移
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       const TalkRoomPage(),
//                                                 ),
//                                               );
//                                             },
//                                             child: const Text("OK"),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   );
//                                 },
//                                 child: isEdited
//                                     ? const Text("")
//                                     : const Text(
//                                         "メッセージを送ってみる",
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 30,
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class GamePostDetailItem extends StatefulWidget {
//   final List<GamePost> posts;
//   final String postId;
//
//   final Account postAccountData;
//
//   const GamePostDetailItem({
//     super.key,
//     required this.posts,
//     required this.postId,
//     required this.postAccountData,
//   });
//
//   @override
//   State<GamePostDetailItem> createState() => _GamePostDetailItemState();
// }
//
// class _GamePostDetailItemState extends State<GamePostDetailItem> {
//   @override
//   void initState() {
//     super.initState();
//     if (widget.posts[0].postAccountId == Authentication.myAccount!.id) {
//       isEdited = true;
//     }
//   }
//
//   bool isEdited = false;
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime createAtDateTime = widget.posts[0].createdTime.toDate();
//     String formattedCreatedAt =
//         DateFormat('yyyy/MM/dd').format(createAtDateTime);
//     return Scaffold(
//       backgroundColor: Colors.indigo[900],
//       appBar: AppBar(
//         title: const Text("詳細ページ"),
//         elevation: 0,
//         backgroundColor: Colors.indigo[900],
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); // 画面遷移を戻る処理
//           },
//         ),
//         actions: [
//           PostsActions(
//             postId: widget.postId,
//             postType: widget.posts[0].type,
//             accountId: widget.posts[0].postAccountId,
//             imageUrl: widget.posts[0].imageUrl != null
//                 ? widget.posts[0].imageUrl
//                 : null,
//             editingType: 'detailPage',
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             // 背景画像を配置したい場合
//             Container(
//               margin: const EdgeInsets.all(20),
//               // padding: EdgeInsets.only(right: 13),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.white,
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 5,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(10),
//                         topRight: Radius.circular(10),
//                       ),
//                       child: ColorFiltered(
//                         colorFilter: ColorFilter.mode(
//                           Colors.black.withOpacity(0.5), // 透明度を調整して画像を暗くします
//                           BlendMode.srcATop,
//                         ),
//                         child: widget.posts[0].imageUrl != null
//                             ? Image.network(
//                                 widget.posts[0].imageUrl!,
//                                 width: double.infinity,
//                                 height: 125,
//                                 fit: BoxFit.cover,
//                               )
//                             : Image.asset(
//                                 'assets/images/headerImage.jpg',
//                                 width: double.infinity,
//                                 height: 125,
//                                 fit: BoxFit.cover,
//                               ),
//                       )),
//                   Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           ClipRRect(
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(10),
//                             ),
//                             child: Container(
//                               height: 40,
//                               width: 60,
//                               decoration: const BoxDecoration(
//                                 color: Colors.orange,
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   widget.posts[0].prefecture,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 "更新日：$formattedCreatedAt",
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 15.0, top: 15),
//                               child: Row(
//                                 children: [
//                                   widget.posts[0].imageUrl != null
//                                       ? ImageCircle(
//                                           imagePath: widget.posts[0].imageUrl
//                                               .toString())
//                                       : NoImageCircle(),
//                                   const SizedBox(
//                                     width: 10,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Text(
//                               widget.posts[0].teamName,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 25,
//                                   color: Colors.black),
//                               maxLines: 3,
//                               overflow: TextOverflow.visible,
//                             ),
//                             const SizedBox(height: 15),
//                             PostIconWithText(
//                               icon: Icons.location_on,
//                               text: widget.posts[0].locationTagList.join(", "),
//                               color: Colors.indigo,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             const SizedBox(height: 8),
//                             Container(
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.black12, width: 1.0), // 下線
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             PostIconWithTextWithList(
//                               icon: Icons.group_add,
//                               text: "年齢層",
//                               list: widget.posts[0].ageList,
//                               color: Colors.black,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             const SizedBox(height: 8),
//                             Container(
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.black12, width: 1.0), // 下線
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             PostIconWithTwoText(
//                                 icon: Icons.groups,
//                                 text1: "メンバー",
//                                 text2: widget.posts[0].member),
//                             const SizedBox(height: 8),
//                             Container(
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.black12, width: 1.0), // 下線
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Row(
//                               children: [
//                                 const Text("レベル"),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 LevelTextWidgets(level: widget.posts[0].level),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             Container(
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.black12, width: 1.0), // 下線
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 8,
//                             ),
//                             const Text(
//                               "投稿者",
//                               style: TextStyle(
//                                   color: Colors.orange,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 widget.postAccountData.imagePath != null
//                                     ? Container(
//                                         width: 60,
//                                         height: 60,
//                                         decoration: const BoxDecoration(
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: CircleAvatar(
//                                           radius: 50,
//                                           foregroundImage: NetworkImage(
//                                             widget.postAccountData.imagePath
//                                                 .toString(),
//                                           ),
//                                         ),
//                                       )
//                                     : Container(
//                                         width: 60,
//                                         height: 60,
//                                         decoration: const BoxDecoration(
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: const CircleAvatar(
//                                           radius: 50,
//                                           foregroundImage: AssetImage(
//                                             'assets/images/basketball_icon.png',
//                                           ),
//                                         ),
//                                       ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   widget.postAccountData.name,
//                                   style: const TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold),
//                                 )
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 16,
//                             ),
//                             Container(
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.black12, width: 1.0), // 下線
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             const Center(
//                               child: Text(
//                                 "詳細",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 15,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Container(
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 border: Border.all(width: 0.5),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   widget.posts[0].note.toString(),
//                                   overflow: TextOverflow.visible,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Center(
//                               child: TextButton(
//                                 onPressed: () async {
//                                   // ボタンが押されたときの処理
//
//                                   // ダイアログを表示
//                                   showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return AlertDialog(
//                                         title: const Text(
//                                           "トークルームを作成",
//                                           style: TextStyle(
//                                               color: Colors.indigo,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         content: const Text(
//                                             "投稿ユーザーとのトークルームを作成してもよろしいですか？"),
//                                         actions: <Widget>[
//                                           // キャンセルボタン
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.of(context)
//                                                   .pop(); // ダイアログを閉じる
//                                             },
//                                             child: const Text("キャンセル"),
//                                           ),
//                                           // OKボタン
//                                           TextButton(
//                                             onPressed: () async {
//                                               // ダイアログを閉じる
//                                               Navigator.of(context).pop();
//
//                                               // 投稿者のpost_account_idからuserData(user情報)を取得
//                                               final userData =
//                                                   await UserFirestore()
//                                                       .getUserInfo(
//                                                 widget.posts[0].postAccountId,
//                                               );
//
//                                               // 自分のuserIdを取得
//                                               final myUid =
//                                                   Authentication.myAccount!.id;
//
//                                               // chatルーム作成する
//                                               RoomFirestore.createTalkRoom(
//                                                   userData!, myUid);
//
//                                               // トークページに遷移
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       const TalkRoomPage(),
//                                                 ),
//                                               );
//                                             },
//                                             child: const Text("OK"),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   );
//                                 },
//                                 child: isEdited
//                                     ? const Text("")
//                                     : const Text(
//                                         "メッセージを送ってみる",
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 30,
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
