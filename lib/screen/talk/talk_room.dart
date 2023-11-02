import 'package:basketball_app/models/chat_post.dart';
import 'package:basketball_app/screen/talk/talk_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/account.dart';
import '../utils/authentication.dart';
import '../utils/progress_dialog.dart';
import '../utils/room_firebase.dart';
import '../utils/snackbar_utils.dart';

class TalkRoomPage extends StatefulWidget {
  @override
  State<TalkRoomPage> createState() => _TalkRoomPageState();
}

class _TalkRoomPageState extends State<TalkRoomPage> {
  final Account myAccount = Authentication.myAccount!; // 現在のユーザーを取得

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final myAccountId = myAccount.id; // ユーザーのUIDを取得
    return _isLoading
        ? ShowProgressIndicator()
        : Scaffold(
            backgroundColor: Colors.indigo[900],
            appBar: AppBar(
              backgroundColor: Colors.indigo[900],
              title: Text('ChatRoom'),
              actions: [
                IconButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("非表示のトークルームを表示させますか？"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "キャンセル",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await RoomFirestore()
                                      .updateIsHiddenForUser(myAccount.id);
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "表示させる",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.open_in_browser))
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: RoomFirestore.joinedRoomSnapshot,
              builder: (context, streamSnapshot) {
                if (streamSnapshot.hasData) {
                  // チャットルームリストの取得を試みる
                  return FutureBuilder<List<TalkRoom>?>(
                    future:
                        RoomFirestore().fetchJoinedRooms(streamSnapshot.data!),
                    // 自分が参加しているトークルームを取得する
                    builder: (context, futureSnapshot) {
                      if (futureSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return ShowProgressIndicator();
                      } else if (futureSnapshot.hasData) {
                        List<TalkRoom>? talkRooms = futureSnapshot.data;
                        if (talkRooms!.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/talk.png',
                                height: 250,
                              ),
                              Text(
                                "トークをはじめよう！",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "投稿からトークを開始できます",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          );
                        }

                        return ListView.builder(
                          itemCount: talkRooms.length,
                          itemBuilder: (context, index) {
                            return Slidable(
                              key: UniqueKey(),
                              endActionPane: ActionPane(
                                extentRatio: 0.5,
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text("トーク内容は削除されません。"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: Text(
                                                    "キャンセル",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                TextButton(
                                                  //リストから削除
                                                  onPressed: () async {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    String roomId =
                                                        talkRooms[index].roomId
                                                            as String;
                                                    // isHiddenをtrueに
                                                    await RoomFirestore
                                                        .hideTalkRoom(roomId,
                                                            myAccountId);
                                                    showSnackBar(
                                                        context: context,
                                                        text: "非表示にしました",
                                                        backgroundColor:
                                                            Colors.white,
                                                        textColor:
                                                            Colors.black);
                                                    setState(() {
                                                      // リストからアイテムを削除
                                                      _isLoading = false;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "非表示",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                    label: '非表示',
                                  ),
                                  SlidableAction(
                                    onPressed: (_) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "このトークルームを削除します。よろしいですか？"),
                                              content: Text("相手のトークも消えます。"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: Text(
                                                    "キャンセル",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    String roomId =
                                                        talkRooms[index].roomId
                                                            as String;
                                                    print(myAccountId);
                                                    await RoomFirestore
                                                        .deleteRooms(roomId);
                                                    showSnackBar(
                                                        context: context,
                                                        text: "削除しました",
                                                        backgroundColor:
                                                            Colors.white,
                                                        textColor:
                                                            Colors.black);
                                                    setState(() {});
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "削除",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    label: '削除',
                                  ),
                                ],
                              ),
                              child: buildTalkRoomListTile(talkRooms[index]),
                            );
                          },
                        );
                      } else {
                        return Center(
                            child: Text(
                          "トークルームの取得に失敗しました",
                          style: TextStyle(color: Colors.white),
                        ));
                      }
                    },
                  );
                } else {
                  return ShowProgressIndicator();
                }
              },
            ),
          );
  }

  Widget buildTalkRoomListTile(TalkRoom talkRoom) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 8.0,
          ),
          trailing: talkRoom.lastTime != null
              ? Text(
                  RoomFirestore()
                      .calculateRelativeTime(talkRoom.lastTime as Timestamp),
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                )
              : null,
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: talkRoom.talkUser!.imagePath != ""
                ? NetworkImage(talkRoom.talkUser!.imagePath as String)
                : null,
            radius: 30,
            child: talkRoom.talkUser!.imagePath == ""
                ? Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  )
                : null,
          ),
          title: Text(
            talkRoom.talkUser!.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          subtitle: Text(
            talkRoom.lastMessage ?? "",
            style: TextStyle(
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TalkPage(talkRoom),
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
