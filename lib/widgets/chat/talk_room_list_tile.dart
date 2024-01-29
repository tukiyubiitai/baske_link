import 'package:basketball_app/infrastructure/firebase/message_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/talk/talkroom.dart';
import '../../views/chat/talk_page.dart';

class TalkRoomListTile extends StatelessWidget {
  final TalkRoom talkRoom;
  final String myUid;

  const TalkRoomListTile({
    Key? key,
    required this.talkRoom,
    required this.myUid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int myUnreadMessageCount = talkRoom.unreadMessageCount!
        .where((map) => map.containsKey(myUid))
        .map((map) => map[myUid]!)
        .first;

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 8.0,
          ),
          trailing: Column(
            children: [
              if (talkRoom.lastTime != null)
                Text(
                  MessageFirestore.calculateRelativeTime(
                    talkRoom.lastTime as Timestamp,
                  ),
                  style: const TextStyle(color: Colors.white38, fontSize: 13),
                ),
              SizedBox(
                height: 3,
              ),
              if (myUnreadMessageCount > 0)
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  padding: const EdgeInsets.all(1.0),
                  child: Center(
                    child: Text(
                      myUnreadMessageCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: talkRoom.talkUser!.imagePath != ""
                ? NetworkImage(talkRoom.talkUser!.imagePath as String)
                : null,
            radius: 30,
            child: talkRoom.talkUser!.imagePath == ""
                ? const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  )
                : null,
          ),
          title: Text(
            talkRoom.talkUser!.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          subtitle: Text(
            talkRoom.lastMessage ?? "",
            style: const TextStyle(
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TalkPage(
                  talkRoom: talkRoom,
                ),
              ),
            );
          },
        ),
        Container(
          height: 1,
          color: Colors.white,
        ),
      ],
    );
  }
}
