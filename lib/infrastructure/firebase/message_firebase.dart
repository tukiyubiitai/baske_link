import 'package:basketball_app/infrastructure/firebase/room_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/account/account.dart';
import '../../models/talk/talkroom.dart';

class MessageFirestore {
  static final FirebaseFirestore _firestoreInstance =
      FirebaseFirestore.instance;

  static final CollectionReference<Map<String, dynamic>> _roomCollection =
      _firestoreInstance.collection("room");

  // 送信時刻をもとに相対時間を計算する関数
  static String calculateRelativeTime(Timestamp sendTime) {
    final now = Timestamp.now();
    final difference = now.seconds - sendTime.seconds;

    if (difference < 60) {
      return '$difference秒前';
    } else if (difference < 3600) {
      final minutes = (difference / 60).floor();
      return '$minutes分前';
    } else if (difference < 86400) {
      final hours = (difference / 3600).floor();
      return '$hours時間前';
    } else if (difference < 604800) {
      final days = (difference / 86400).floor();
      return '$days日前';
    } else {
      final weeks = (difference / 604800).floor();
      return '$weeks週間前';
    }
  }

  // メッセージの保存
  Future<void> sendMessageToFirestore({
    required Account myAccount,
    required String roomId,
    required String message,
    required String recipientId,
  }) async {
    final sendTime = Timestamp.now();
    final messageCollection = _roomCollection.doc(roomId).collection("message");

    // メッセージを保存（サブコレクション）
    await messageCollection.add({
      "message": message,
      "sender_id": myAccount.id,
      "send_time": sendTime,
      "user_name": myAccount.name,
      "recipient_id": recipientId,
      "isRead": false,
    });

    // ルーム情報を更新
    await _roomCollection.doc(roomId).update({
      "last_message": message,
      "last_sendTime": sendTime,
      "created_time": Timestamp.now(),
    });
  }

  // (TalkPage)トークを開いた時にメッセージを未読から既読にする
  Future<void> updateMessageReadStatus(
      String roomId, String myUid, String talkUserId) async {
    // messageCollectionを取得
    final messageCollection = _roomCollection.doc(roomId).collection('message');

    // recipient_idが自分(myUid)で、かつisReadがfalseのメッセージを取得
    final querySnapshot = await messageCollection
        .where('recipient_id', isEqualTo: myUid)
        .where('isRead', isEqualTo: false)
        .get();

    // 取得したメッセージのisReadをtrueに変更
    for (final doc in querySnapshot.docs) {
      await doc.reference.update({'isRead': true});
    }
    int unreadMessageCount =
        await RoomFirestore().getUnreadMessageCount(roomId, myUid);
    await _roomCollection.doc(roomId).update({
      "unreadMessageCount": [
        {myUid: unreadMessageCount}
      ],
    });
  }

  Future<QuerySnapshot> fetchRawRoomMessages(TalkRoom talkRoom) async {
    try {
      return await FirebaseFirestore.instance
          .collection('room')
          .doc(talkRoom.roomId)
          .collection('message')
          .orderBy('send_time', descending: true)
          .get();
    } catch (e) {
      throw Exception('データの取得に失敗しました $e');
    }
  }
}
