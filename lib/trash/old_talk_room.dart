// import 'package:basketball_app/talk/model/talkroom.dart';
// import 'package:basketball_app/talk/screens/talk_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
//
// import '../../account/model/account.dart';
// import '../../authentication/utils/authentication.dart';
// import '../../widgets/common_widgets/snackbar_utils.dart';
// import '../repository/room_firebase.dart';
//
// class TalkRoomPage extends StatefulWidget {
//   const TalkRoomPage({super.key});
//
//   @override
//   State<TalkRoomPage> createState() => _TalkRoomPageState();
// }
//
// class _TalkRoomPageState extends State<TalkRoomPage> {
//   final Account myAccount = Authentication.myAccount!; // 現在のユーザーを取得
//
//   bool _isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final myAccountId = myAccount.id; // ユーザーのUIDを取得
//     return Scaffold(
//       backgroundColor: Colors.indigo[900],
//       appBar: AppBar(
//         backgroundColor: Colors.indigo[900],
//         title: const Text(
//           'ChatRoom',
//           style: TextStyle(color: Colors.white),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () async {
//                 showDialog(
//                   context: context,
//                   builder: (context) {
//                     return AlertDialog(
//                       title: const Text("非表示のトークルームを表示させますか？"),
//                       actions: <Widget>[
//                         TextButton(
//                           onPressed: () {
//                             setState(() {});
//                             Navigator.of(context).pop();
//                           },
//                           child: const Text(
//                             "キャンセル",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () async {
//                             await RoomFirestore()
//                                 .updateIsHiddenForUser(myAccount.id);
//                             setState(() {});
//                             Navigator.of(context).pop();
//                           },
//                           child: const Text(
//                             "表示させる",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//               icon: const Icon(Icons.open_in_browser))
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: RoomFirestore.joinedRoomSnapshot,
//         builder: (context, streamSnapshot) {
//           if (streamSnapshot.hasData) {
//             // チャットルームリストの取得を試みる
//             return FutureBuilder<List<TalkRoom>?>(
//               future: RoomFirestore().fetchJoinedRooms(streamSnapshot.data!),
//               // 自分が参加しているトークルームを取得する
//               builder: (context, futureSnapshot) {
//                 if (futureSnapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (futureSnapshot.hasData) {
//                   List<TalkRoom>? talkRooms = futureSnapshot.data;
//                   if (talkRooms!.isEmpty) {
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Center(
//                           child: Image.asset(
//                             'assets/images/talk.png',
//                             height: 250,
//                           ),
//                         ),
//                         const Text(
//                           "トークをはじめよう！",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const Text(
//                           "投稿からトークを開始できます",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w300,
//                           ),
//                         ),
//                       ],
//                     );
//                   }
//
//                   return ListView.builder(
//                       itemCount: talkRooms.length,
//                       itemBuilder: (context, index) {
//                         final String roomId = talkRooms[index].roomId as String;
//
//                         return Slidable(
//                           key: UniqueKey(),
//                           endActionPane: ActionPane(
//                             extentRatio: 0.5,
//                             motion: const ScrollMotion(),
//                             children: [
//                               SlidableAction(
//                                 onPressed: (_) {
//                                   showDialog(
//                                       context: context,
//                                       builder: (context) {
//                                         return AlertDialog(
//                                           content: const Text("トーク内容は削除されません。"),
//                                           actions: [
//                                             TextButton(
//                                               onPressed: () =>
//                                                   Navigator.of(context).pop(),
//                                               child: const Text(
//                                                 "キャンセル",
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                             ),
//                                             TextButton(
//                                               //リストから削除
//                                               onPressed: () async {
//                                                 // isHiddenをtrueに
//                                                 await RoomFirestore
//                                                     .hideTalkRoom(
//                                                         roomId, myAccountId);
//                                                 showSnackBar(
//                                                     context: context,
//                                                     text: "非表示にしました",
//                                                     backgroundColor:
//                                                         Colors.white,
//                                                     textColor: Colors.black);
//
//                                                 Navigator.of(context).pop();
//                                               },
//                                               child: const Text(
//                                                 "非表示",
//                                                 style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Colors.red),
//                                               ),
//                                             ),
//                                           ],
//                                         );
//                                       });
//                                 },
//                                 backgroundColor: Colors.grey,
//                                 foregroundColor: Colors.white,
//                                 label: '非表示',
//                               ),
//                               SlidableAction(
//                                 onPressed: (_) {
//                                   showDialog(
//                                       context: context,
//                                       builder: (context) {
//                                         return AlertDialog(
//                                           title: const Text(
//                                               "このトークルームを削除します。よろしいですか？"),
//                                           content: const Text("相手のトークも消えます。"),
//                                           actions: [
//                                             TextButton(
//                                               onPressed: () =>
//                                                   Navigator.of(context).pop(),
//                                               child: const Text(
//                                                 "キャンセル",
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                             ),
//                                             TextButton(
//                                               onPressed: () async {
//                                                 await RoomFirestore.deleteRooms(
//                                                     roomId);
//                                                 showSnackBar(
//                                                     context: context,
//                                                     text: "削除しました",
//                                                     backgroundColor:
//                                                         Colors.white,
//                                                     textColor: Colors.black);
//                                                 setState(() {});
//                                                 Navigator.of(context).pop();
//                                               },
//                                               child: const Text(
//                                                 "削除",
//                                                 style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Colors.red),
//                                               ),
//                                             ),
//                                           ],
//                                         );
//                                       });
//                                 },
//                                 backgroundColor: Colors.red,
//                                 foregroundColor: Colors.white,
//                                 label: '削除',
//                               ),
//                             ],
//                           ),
//                           child: buildTalkRoomListTile(
//                               talkRooms[index], myAccountId),
//                         );
//                       });
//                 } else {
//                   return const Center(
//                       child: Text(
//                     "トークルームの取得に失敗しました",
//                     style: TextStyle(color: Colors.white),
//                   ));
//                 }
//               },
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
//
//   Widget buildTalkRoomListTile(TalkRoom talkRoom, String myUid) {
//     final int myUnreadMessageCount = talkRoom.unreadMessageCount!
//         .where((map) => map.containsKey(myUid))
//         .map((map) => map[myUid]!)
//         .first;
//     return Column(
//       children: [
//         ListTile(
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 32.0,
//             vertical: 8.0,
//           ),
//           trailing: Column(
//             children: [
//               if (talkRoom.lastTime != null)
//                 Text(
//                   RoomFirestore().calculateRelativeTime(
//                     talkRoom.lastTime as Timestamp,
//                   ),
//                   style: const TextStyle(color: Colors.white38, fontSize: 13),
//                 ),
//               SizedBox(
//                 height: 3,
//               ),
//               if (myUnreadMessageCount > 0)
//                 Container(
//                   width: 25,
//                   height: 25,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.red,
//                   ),
//                   padding: const EdgeInsets.all(1.0),
//                   child: Center(
//                     child: Text(
//                       myUnreadMessageCount.toString(),
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           leading: CircleAvatar(
//             backgroundColor: Colors.grey,
//             backgroundImage: talkRoom.talkUser!.imagePath != ""
//                 ? NetworkImage(talkRoom.talkUser!.imagePath as String)
//                 : null,
//             radius: 30,
//             child: talkRoom.talkUser!.imagePath == ""
//                 ? const Icon(
//                     Icons.person,
//                     size: 40,
//                     color: Colors.white,
//                   )
//                 : null,
//           ),
//           title: Text(
//             talkRoom.talkUser!.name,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//           ),
//           subtitle: Text(
//             talkRoom.lastMessage ?? "",
//             style: const TextStyle(
//               color: Colors.white,
//             ),
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//           ),
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => TalkPage(talkRoom),
//               ),
//             );
//           },
//         ),
//         Container(
//           height: 1,
//           color: Colors.white,
//         ),
//       ],
//     );
//   }
// }
