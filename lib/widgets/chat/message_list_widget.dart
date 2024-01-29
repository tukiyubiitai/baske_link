import 'package:basketball_app/models/talk/talkroom.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../models/talk/message.dart';

class MessageListWidget extends StatelessWidget {
  final List<Message> messages;
  final TalkRoom talkRoom;

  const MessageListWidget(
      {Key? key, required this.messages, required this.talkRoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: Text(
          "メッセージがありません",
          style: TextStyle(color: Colors.black),
        ),
      );
    }

    return ListView.builder(
      physics: const RangeMaintainingScrollPhysics(),
      shrinkWrap: true,
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final readStatusWidget = message.isMe && message.isRead
            ? Text(
                "既読",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              )
            : null;

        return Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: index == 0 ? 18 : 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            textDirection: message.isMe ? TextDirection.rtl : TextDirection.ltr,
            children: [
              message.isMe
                  ? Container(
                      constraints: BoxConstraints(
                          //最高幅を７割くらい
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: message.isMe ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(message.message.toString()),
                    )
                  : Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          // 画像がない場合の背景色（灰色など）
                          backgroundImage: talkRoom.talkUser!.imagePath != ""
                              ? NetworkImage(
                                  talkRoom.talkUser!.imagePath as String)
                              : null,
                          // 画像がある場合はNetworkImageを使用し、ない場合はnullを指定
                          radius: 20,
                          child: talkRoom.talkUser!.imagePath == ""
                              ? const Icon(
                                  Icons.person, // 代替の人のアイコン
                                  size: 40, // アイコンのサイズを調整できます
                                  color: Colors.white, // アイコンの色を設定できます
                                )
                              : null, // 画像がある場合はchildに何も表示しない
                        ),
                        const SizedBox(width: 5),
                        Container(
                          constraints: BoxConstraints(
                              //最高幅を７割くらい
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: message.isMe ? Colors.green : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(message.message.toString()),
                        ),
                      ],
                    ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  readStatusWidget ?? SizedBox(),
                  Text(
                    intl.DateFormat("HH:mm").format(message.sendTime.toDate()),
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
