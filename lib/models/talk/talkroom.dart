import 'package:cloud_firestore/cloud_firestore.dart';

import '../account/account.dart';

class TalkRoom {
  final String? title; // チャットルーム名（例: ユーザー名）
  final String? lastMessage; // メッセージテキスト
  final Account? talkUser; //相手
  final String? roomId; //トークルームID
  final Timestamp? lastTime; //最後にメッセージが送信された時間

  final List<Map<String, int>>? unreadMessageCount;

  TalkRoom({
    this.title,
    this.lastMessage,
    this.talkUser,
    this.roomId,
    this.lastTime,
    this.unreadMessageCount,
  });
}
