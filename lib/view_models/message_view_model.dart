import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/firebase/account_firebase.dart';
import '../../infrastructure/firebase/message_firebase.dart';
import '../../infrastructure/firebase/room_firebase.dart';
import '../../models/account/account.dart';
import '../../models/talk/message.dart';
import '../../models/talk/talkroom.dart';
import '../state/providers/account/account_notifier.dart';
import '../state/providers/chat/message_provider.dart';
import '../state/providers/chat/talk_room_provider.dart';

class MessageViewModel extends ChangeNotifier {
  //メッセージ送信時に呼ばれる
  Future<void> sendMessage(
      {required String message,
      required TalkRoom talkRoom,
      required WidgetRef ref}) async {
    try {
      final myAccount = ref.read(accountNotifierProvider);
      //ブロックリストに登録されている場合はメッセージは送っても保存されない
      if (AccountFirestore().isBlocked(myAccount.id, talkRoom.talkUser!.id) ==
          false) {
        return;
      }

      // 非表示設定と既読状態の更新
      await RoomFirestore().updateHiddenAndReadStatus(
          talkRoom.roomId as String, talkRoom.talkUser!.id, myAccount.id);

      // メッセージを保存（サブコレクション）
      MessageFirestore().sendMessageToFirestore(
          roomId: talkRoom.roomId as String,
          message: message,
          myAccount: myAccount,
          recipientId: talkRoom.talkUser!.id);

      //messageを追加して画面更新
      ref.read(messageNotifierProvider(talkRoom).notifier).addMessage(
            Message(
              message: message,
              isMe: true,
              sendTime: Timestamp.now(),
              myName: myAccount.name,
              recipient: talkRoom.talkUser!.id,
              isRead: false,
            ),
          );
      //トークルームを更新
      ref.read(talkRoomNotifierProvider.notifier).refreshTalkRooms();
    } catch (e) {
      print("メッセージの送信失敗: $e");
      throw e;
    }
  }

  // updateMessageReadStatusの完了状態をチェックする関数
  Future<void> checkAndUpdateMessageReadStatus(
      String roomId, String myUid, String talkUserId) async {
    try {
      // リポジトリ層のメソッドを呼び出し
      await MessageFirestore()
          .updateMessageReadStatus(roomId, myUid, talkUserId);

      // 成功の通知やログ
      print('既読状態の更新に成功しました。');
    } catch (e) {
      // 失敗した場合の処理（例: エラー通知）
      // 例外処理やエラー通知のロジックを実行
      print('既読状態の更新に失敗しました: $e');
      throw e;
    }
  }

  Future<List<Message>> fetchRoomMessages(
      TalkRoom talkRoom, Account myAccount) async {
    try {
      List<Message> _messages = [];
      QuerySnapshot snapshot =
          await MessageFirestore().fetchRawRoomMessages(talkRoom);

      _messages = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Message(
          message: data['message'],
          isMe: myAccount.id == data["sender_id"],
          sendTime: data['send_time'] as Timestamp,
          myName: myAccount.name,
          recipient: data['recipient_id'],
          isRead: data['isRead'],
        );
      }).toList();

      return _messages;
    } catch (e) {
      throw Exception('メッセージの取得に失敗しました $e');
    }
  }
}
