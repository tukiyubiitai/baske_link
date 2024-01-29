// import 'package:flutter/material.dart';
//
// import '../../account/model/account.dart';
// import '../model/game_model.dart';
// import '../screens/team_post_item.dart';
//
// class TeamPostWidget extends StatefulWidget {
//   final Map<String, dynamic> postData;
//   final Map<String, Account> userData;
//   final String postId; // 投稿のId
//   const TeamPostWidget(
//       {super.key,
//       required this.postData,
//       required this.postId,
//       required this.userData});
//
//   @override
//   State<TeamPostWidget> createState() => _TeamPostWidgetState();
// }
//
// class _TeamPostWidgetState extends State<TeamPostWidget> {
//   Account? postAccount; // 投稿したアカウント情報
//   @override
//   void initState() {
//     super.initState();
//     // widget.data["post_account_id"] と一致するアカウント情報を userData マップから取得
//     if (widget.userData.containsKey(widget.postData["post_account_id"])) {
//       postAccount = widget.userData[widget.postData["post_account_id"]];
//       print("これがpostAccount: $postAccount");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TeamPostItem(
//       postData: widget.postData,
//       postId: widget.postId,
//       userData: {},
//     ); // listItemウィ
//   }
// }
//
// class GamePostWidget extends StatefulWidget {
//   final Map<String, dynamic> data;
//   final String id; // id を追加
//
//   final Map<String, Account> userData;
//
//   const GamePostWidget(
//       {super.key,
//       required this.data,
//       required this.id,
//       required this.userData});
//
//   @override
//   State<GamePostWidget> createState() => _GamePostWidgetState();
// }
//
// class _GamePostWidgetState extends State<GamePostWidget> {
//   Account? postAccount; // 投稿したアカウント情報
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if (widget.userData.containsKey(widget.data["post_account_id"])) {
//       postAccount = widget.userData[widget.data["post_account_id"]];
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> ageList = List<String>.from(widget.data["ageList"]);
//     List<String> locationTageList =
//         List<String>.from(widget.data["locationTagList"]);
//     GamePost post = GamePost(
//       id: widget.id,
//       postAccountId: widget.data["post_account_id"],
//       locationTagList: locationTageList,
//       prefecture: widget.data["prefecture"],
//       teamName: widget.data["teamName"],
//       note: widget.data["note"],
//       imageUrl: widget.data["imageUrl"],
//       createdTime: widget.data["created_time"],
//       ageList: ageList,
//       level: widget.data["level"],
//       member: widget.data["member"],
//       type: 'game',
//     );
//
//     return SizedBox();
//     // return GameListItemWidget(
//     //   recruitment: widget.data,
//     //   postId: post.id,
//     //   postAccountData: postAccount as Account,
//     // );
//   }
// }
