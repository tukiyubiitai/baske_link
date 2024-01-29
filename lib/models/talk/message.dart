import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  //本文
  final String message;

  //自分かどうか
  final bool isMe;

  //送った時間
  final Timestamp sendTime;

  //自分の名前
  final String myName;

  //相手の名前
  final String recipient;

  //メッセージの既読・未読
  final bool isRead;

  Message(
      {required this.message,
      required this.isMe,
      required this.sendTime,
      required this.myName,
      required this.recipient,
      required this.isRead});
}
