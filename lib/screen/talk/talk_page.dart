import 'package:basketball_app/models/talkroom.dart';
import 'package:basketball_app/repository/room_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../models/message.dart';
import '../../utils/authentication.dart';
import '../../widgets/common_widgets/progress_dialog.dart';

class TalkPage extends StatefulWidget {
  final TalkRoom talkRoom;

  TalkPage(this.talkRoom);

  @override
  State<TalkPage> createState() => _TalkPageState();
}

class _TalkPageState extends State<TalkPage> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    RoomFirestore.updateMessageReadStatus(widget.talkRoom.roomId as String,
        Authentication.myAccount!.id, widget.talkRoom.talkUser!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(widget.talkRoom.talkUser!.name),
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: RoomFirestore.fetchMessageSnapshot(
                  widget.talkRoom.roomId as String),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ShowProgressIndicator();
                }
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: ListView.builder(
                        physics: const RangeMaintainingScrollPhysics(),
                        //画面幅を超えた時にスクロールできるように
                        shrinkWrap: true,
                        //listItemを上に配置
                        reverse: true,
                        //上にスクロール
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];
                          final Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;
                          final Message message = Message(
                            message: data["message"],
                            isMe: Authentication.myAccount!.id ==
                                data["sender_id"],
                            sendTime: data["send_time"],
                            userName: Authentication.myAccount!.name,
                            recipient: data["recipient_id"],
                          );
                          return Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              right: 10,
                              left: 10,
                              bottom: index == 0 ? 18 : 0,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              textDirection: message.isMe
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              children: [
                                message.isMe
                                    ? Container(
                                        constraints: BoxConstraints(
                                            //最高幅を７割くらい
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: message.isMe
                                              ? Colors.green
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(message.message.toString()),
                                      )
                                    : Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            // 画像がない場合の背景色（灰色など）
                                            backgroundImage: widget.talkRoom
                                                        .talkUser!.imagePath !=
                                                    ""
                                                ? NetworkImage(widget
                                                    .talkRoom
                                                    .talkUser!
                                                    .imagePath as String)
                                                : null,
                                            // 画像がある場合はNetworkImageを使用し、ない場合はnullを指定
                                            radius: 20,
                                            child: widget.talkRoom.talkUser!
                                                        .imagePath ==
                                                    ""
                                                ? const Icon(
                                                    Icons.person, // 代替の人のアイコン
                                                    size: 40, // アイコンのサイズを調整できます
                                                    color: Colors
                                                        .white, // アイコンの色を設定できます
                                                  )
                                                : null, // 画像がある場合はchildに何も表示しない
                                          ),
                                          const SizedBox(width: 5),
                                          Container(
                                            constraints: BoxConstraints(
                                                //最高幅を７割くらい
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: message.isMe
                                                  ? Colors.green
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                                message.message.toString()),
                                          ),
                                        ],
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  intl.DateFormat("HH:mm")
                                      .format(message.sendTime.toDate()),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        }),
                  );
                } else {
                  return const Center(
                    child: Text("メッセージがありません"),
                  );
                }
              }),
          //メッセージ入力
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 60,
                      bottom: 10,
                    ),
                    child: TextField(
                      controller: controller,
                      maxLines: null, // テキストエリアを複数行の入力に設定
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Type a message!",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                      onSubmitted: (text) async {
                        if (text.isNotEmpty) {
                          await RoomFirestore.sendMessage(
                            roomId: widget.talkRoom.roomId as String,
                            message: text,
                            talkUserId: widget.talkRoom.talkUser!.id,
                          );
                          controller.clear();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          //送信ボタン
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, bottom: 14),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: IconButton(
                  onPressed: () async {
                    final text = controller.text;
                    if (text.isNotEmpty) {
                      await RoomFirestore.sendMessage(
                        roomId: widget.talkRoom.roomId as String,
                        message: text,
                        talkUserId: widget.talkRoom.talkUser!.id,
                      );
                      controller.clear();
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
