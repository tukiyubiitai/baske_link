import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final bool isMe;
  final Timestamp sendTime;
  final String userName;
  final String recipient;

  Message(
      {required this.message,
      required this.isMe,
      required this.sendTime,
      required this.userName,
      required this.recipient});
}
