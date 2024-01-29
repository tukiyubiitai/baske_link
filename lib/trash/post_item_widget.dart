// //チーム募集 TeamListItemWidget
// class TeamListItemWidget extends StatefulWidget {
//   final Map<String, dynamic> recruitment;
//   final String postId;
//
//   final Account postAccountData;
//
//   const TeamListItemWidget({
//     super.key,
//     required this.recruitment,
//     required this.postId,
//     required this.postAccountData,
//   });
//
//   @override
//   State<TeamListItemWidget> createState() => _TeamListItemWidgetState();
// }
//
// class _TeamListItemWidgetState extends State<TeamListItemWidget> {
//   @override
//   Widget build(BuildContext context) {
//     // print("これが送られてきたuserData ${widget.userData.name}");
//     DateTime createAtDateTime = widget.recruitment["created_time"].toDate();
//     String formattedCreatedAt =
//         DateFormat('yyyy/MM/dd').format(createAtDateTime);
//
//     List<String> targetList = List<String>.from(widget.recruitment["target"]);
//     List<String> ageList = List<String>.from(widget.recruitment["age"]);
//     List<String> locationList =
//         List<String>.from(widget.recruitment["location"]);
//     return Stack(
//       children: [
//         // 背景画像を配置したい場合
//         Container(
//           margin: const EdgeInsets.all(20),
//           // padding: EdgeInsets.only(right: 13),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Colors.white,
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 5,
//                 offset: Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Stack(
//             children: [
//               ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(10),
//                     topRight: Radius.circular(10),
//                   ),
//                   child: ColorFiltered(
//                     colorFilter: ColorFilter.mode(
//                       Colors.black.withOpacity(0.5), // 透明度を調整して画像を暗くします
//                       BlendMode.srcATop,
//                     ),
//                     child: widget.recruitment["headerUrl"] != null
//                         ? Image.network(
//                             widget.recruitment["headerUrl"]!,
//                             width: double.infinity,
//                             height: 150,
//                             fit: BoxFit.cover,
//                           )
//                         : Image.asset(
//                             'assets/images/headerImage.jpg',
//                             width: double.infinity,
//                             height: 150,
//                             fit: BoxFit.cover,
//                           ),
//                   )),
//               Padding(
//                 padding: const EdgeInsets.only(right: 10.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ClipRRect(
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                           ),
//                           child: Container(
//                             height: 40,
//                             width: 60,
//                             decoration: const BoxDecoration(
//                               color: Colors.indigo,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 widget.recruitment["prefecture"],
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   "更新日：$formattedCreatedAt",
//                                   style: const TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//
//                     Padding(
//                       padding: const EdgeInsets.only(left: 16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 15.0, top: 40),
//                             child: Row(
//                               children: [
//                                 widget.recruitment["imageUrl"] != null
//                                     ? ImageCircle(
//                                         imagePath:
//                                             widget.recruitment["imageUrl"])
//                                     : NoImageCircle(),
//                               ],
//                             ),
//                           ),
//                           Column(
//                             children: [
//                               Text(
//                                 widget.recruitment["teamName"],
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 20,
//                                     color: Colors.black),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(
//                                 height: 20,
//                               ),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       widget.recruitment["searchCriteria"],
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 16),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           Container(
//                             decoration: const BoxDecoration(
//                               border: Border(
//                                 bottom: BorderSide(
//                                     color: Colors.black12, width: 1.0), // 下線
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           PostIconWithText(
//                             icon: Icons.location_on,
//                             text: locationList.join(", "),
//                             color: Colors.indigo,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           const SizedBox(height: 8),
//                           Container(
//                             decoration: const BoxDecoration(
//                               border: Border(
//                                 bottom: BorderSide(
//                                     color: Colors.black12, width: 1.0), // 下線
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           PostIconWithText(
//                             icon: Icons.calendar_month,
//                             text: widget.recruitment["activityTime"],
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           const SizedBox(height: 8),
//                           Container(
//                             decoration: const BoxDecoration(
//                               border: Border(
//                                 bottom: BorderSide(
//                                     color: Colors.black12, width: 1.0), // 下線
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           PostIconWithText(
//                             icon: Icons.group_add,
//                             text: ageList.join(', '),
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           const SizedBox(height: 8),
//                           Container(
//                             decoration: const BoxDecoration(
//                               border: Border(
//                                 bottom: BorderSide(
//                                     color: Colors.black12, width: 1.0), // 下線
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           PostIconWithList(
//                             icon: Icons.groups,
//                             list: targetList,
//                             color: Colors.indigo,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           const SizedBox(height: 8),
//                           Container(
//                             decoration: const BoxDecoration(
//                               border: Border(
//                                 bottom: BorderSide(
//                                     color: Colors.black12, width: 1.0), // 下線
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           const Text(
//                             "投稿者",
//                             style: TextStyle(
//                                 color: Colors.orange,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               widget.postAccountData.imagePath != null
//                                   ? Container(
//                                       width: 60,
//                                       height: 60,
//                                       decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: CircleAvatar(
//                                         radius: 50,
//                                         foregroundImage: NetworkImage(
//                                           widget.postAccountData.imagePath
//                                               as String,
//                                         ),
//                                       ),
//                                     )
//                                   : Container(
//                                       width: 60,
//                                       height: 60,
//                                       decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: const CircleAvatar(
//                                         radius: 50,
//                                         foregroundImage: AssetImage(
//                                           'assets/images/basketball_icon.png',
//                                         ),
//                                       ),
//                                     ),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               Text(
//                                 widget.postAccountData.name,
//                                 style: const TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15),
//                               )
//                             ],
//                           ),
//                           Center(
//                             child: TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => TeamPostDetailPage(
//                                       postId: widget.postId,
//                                       postAccountData: widget.postAccountData,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: const Text(
//                                 "詳細を見る",
//                                 style: TextStyle(
//                                     fontSize: 14, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // SizedBox(
//                     //   height: 20,
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// //練習試合 GameListItemWidget
// class GameListItemWidget extends StatefulWidget {
//   final String postId;
//   final Map<String, dynamic> recruitment;
//   final Account postAccountData;
//
//   const GameListItemWidget({
//     super.key,
//     required this.postId,
//     required this.recruitment,
//     required this.postAccountData,
//   });
//
//   @override
//   State<GameListItemWidget> createState() => _GameListItemWidgetState();
// }
//
// class _GameListItemWidgetState extends State<GameListItemWidget> {
//   @override
//   Widget build(BuildContext context) {
//     DateTime createAtDateTime = widget.recruitment["created_time"].toDate();
//     String formattedCreatedAt =
//         DateFormat('yyyy/MM/dd').format(createAtDateTime);
//
//     List<String> ageList = List<String>.from(widget.recruitment["ageList"]);
//     List<String> locationTagList =
//         List<String>.from(widget.recruitment["locationTagList"]);
//
//     return Stack(
//       children: [
//         // 背景画像を配置したい場合
//         Container(
//           margin: const EdgeInsets.all(20),
//           // padding: EdgeInsets.only(right: 13),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Colors.white,
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 5,
//                 offset: Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Stack(
//             children: [
//               ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(10),
//                     topRight: Radius.circular(10),
//                   ),
//                   child: ColorFiltered(
//                     colorFilter: ColorFilter.mode(
//                       Colors.black.withOpacity(0.5), // 透明度を調整して画像を暗くします
//                       BlendMode.srcATop,
//                     ),
//                     child: widget.recruitment["imageUrl"] != null
//                         ? Image.network(
//                             widget.recruitment["imageUrl"]!,
//                             width: double.infinity,
//                             height: 125,
//                             fit: BoxFit.cover,
//                           )
//                         : Image.asset(
//                             'assets/images/headerImage.jpg',
//                             width: double.infinity,
//                             height: 125,
//                             fit: BoxFit.cover,
//                           ),
//                   )),
//               Padding(
//                 padding: const EdgeInsets.only(right: 10.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ClipRRect(
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                           ),
//                           child: Container(
//                             height: 40,
//                             width: 60,
//                             decoration: const BoxDecoration(
//                               color: Colors.orange,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 widget.recruitment["prefecture"],
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               "更新日：$formattedCreatedAt",
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 15.0, top: 30),
//                             child: widget.recruitment["imageUrl"] != null
//                                 ? ImageCircle(
//                                     imagePath: widget.recruitment["imageUrl"])
//                                 : NoImageCircle(),
//                           ),
//                           Center(
//                             child: Text(
//                               widget.recruitment["teamName"],
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 20),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           Container(
//                             decoration: const BoxDecoration(
//                               border: Border(
//                                 bottom: BorderSide(
//                                     color: Colors.black12, width: 1.0), // 下線
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           PostIconWithText(
//                             icon: Icons.location_on,
//                             text: locationTagList.join(", "),
//                             color: Colors.indigo,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           const SizedBox(height: 5),
//                           Container(
//                             decoration: const BoxDecoration(
//                               border: Border(
//                                 bottom: BorderSide(
//                                     color: Colors.black12, width: 1.0), // 下線
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           PostIconWithText(
//                             icon: Icons.group_add,
//                             text: ageList.join(', '),
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           const SizedBox(height: 5),
//                           Container(
//                             decoration: const BoxDecoration(
//                               border: Border(
//                                 bottom: BorderSide(
//                                     color: Colors.black12, width: 1.0), // 下線
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           PostIconWithText(
//                             color: Colors.black,
//                             icon: Icons.groups,
//                             text: widget.recruitment["member"],
//                             fontWeight: FontWeight.w500,
//                           ),
//                           const SizedBox(height: 5),
//                           Container(
//                             decoration: const BoxDecoration(
//                               border: Border(
//                                 bottom: BorderSide(
//                                     color: Colors.black12, width: 1.0), // 下線
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           LevelTextWidgets(level: widget.recruitment["level"]),
//                           const SizedBox(height: 5),
//                           Container(
//                             decoration: const BoxDecoration(
//                               border: Border(
//                                 bottom: BorderSide(
//                                     color: Colors.black12, width: 1.0), // 下線
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           const Text(
//                             "投稿者",
//                             style: TextStyle(
//                                 color: Colors.orange,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               widget.postAccountData.imagePath != null
//                                   ? Container(
//                                       width: 60,
//                                       height: 60,
//                                       decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: CircleAvatar(
//                                         radius: 50,
//                                         foregroundImage: NetworkImage(
//                                           widget.postAccountData.imagePath
//                                               as String,
//                                         ),
//                                       ),
//                                     )
//                                   : Container(
//                                       width: 60,
//                                       height: 60,
//                                       decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: const CircleAvatar(
//                                         radius: 50,
//                                         foregroundImage: AssetImage(
//                                           'assets/images/basketball_icon.png',
//                                         ),
//                                       ),
//                                     ),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               Text(
//                                 widget.postAccountData.name,
//                                 style: const TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold),
//                               )
//                             ],
//                           ),
//                           Center(
//                             child: TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => GamePostDetailPage(
//                                       postId: widget.postId,
//                                       postAccountData: widget.postAccountData,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: const Text(
//                                 "詳細を見る",
//                                 style: TextStyle(
//                                     fontSize: 14, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // SizedBox(
//                     //   height: 20,
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
