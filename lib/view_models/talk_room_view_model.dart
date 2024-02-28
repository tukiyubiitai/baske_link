import 'package:basketball_app/infrastructure/firebase/room_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/account/account.dart';
import '../dialogs/snackbar.dart';
import '../state/providers/chat/chat_notifier.dart';

class TalkRoomViewModel extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference get room => firestore.collection("room");

  // トークルーム作成
  Future<bool> initiateChatRoomCreation(
    Account talkUserAccount,
    String myUid,
    WidgetRef ref,
  ) async {
    try {
      final result =
          await RoomFirestore().createTalkRoom(talkUserAccount, myUid);
      ref.read(talkRoomNotifierProvider.notifier).refreshTalkRooms();
      return result;
    } catch (e) {
      throw e;
    }
  }

  // トークルーム非表示
  Future<void> hideTalkRoom(String roomId, String myUid) async {
    try {
      final isDeletedCollection = room.doc(roomId).collection('isHidden');
      // ドキュメントのフィールドを直接アップデート
      await isDeletedCollection.doc(myUid).update({myUid: true});
    } catch (e) {
      print('トークルームの非表示設定に失敗しました: $e');
    }
  }

  // トークルーム削除
  Future<bool> deleteRoom(String roomId, WidgetRef ref) async {
    bool result = await RoomFirestore().deleteRoomAndSubCollections(roomId);
    if (result) {
      ref.read(talkRoomNotifierProvider.notifier).refreshTalkRooms();
      return true;
    } else {
      return false;
    }
  }

  // 非表示にしているトークルームを読み込む
  Future<void> hiddenForUser(String myUid, WidgetRef ref) async {
    try {
      final result = await RoomFirestore().updateIsHiddenForUser(myUid);
      if (result) {
        ref.read(talkRoomNotifierProvider.notifier).refreshTalkRooms();
        showSnackBar(
            context: ref.context,
            text: "読み込み完了しました",
            backgroundColor: Colors.white,
            textColor: Colors.black);
      }
    } catch (e) {
      // return handleError(e, ref.context);
    }
  }
}

//   Future<List<TalkRoom>?> fetchJoinedRooms(QuerySnapshot snapshot) async {
//     try {
//       String myUid = AuthenticationService.myAccount!.id;
//       List<TalkRoom> talkRooms = []; //自分が参加しているトークルームのリスト
//       Account? talkUser;
//
//       // トークルームを作成時間の逆順で取得
//       final snapshot =
//           await room.orderBy("created_time", descending: true).get();
//
//       //// 取得したトークルームに対する処理
//       await Future.forEach(snapshot.docs, (doc) async {
//         //ログインユーザーがチャットルームに参加しているかどうかを確認しています。
//         if (doc.data()["joined_user_ids"].contains(myUid)) {
//           //ログインユーザーがそのチャットルームに参加している場合
//           late String talkUserId;
//           doc.data()["joined_user_ids"].forEach((id) {
//             // ログインユーザー以外のid（対話相手のid）を talkUserId に設定
//             if (id != myUid) {
//               talkUserId = id;
//               return;
//             }
//           });
//
//           talkUser = await AccountFirestore.fetchProfile(
//               talkUserId); //対話相手のプロフィール情報を取得
//           //非表示設定をチェック
//           final isHidden = await RoomFirestore.checkAndSetIsHidden(
//               doc.id, myUid, talkUserId);
//
//           int unreadMessageCount =
//               await RoomFirestore().getUnreadMessageCount(doc.id, myUid);
//
//           // 非表示設定がfalseの場合のみトークルームを作成
//           if (isHidden == false) {
//             final talkRoom = TalkRoom(
//               //ルームID
//               roomId: doc.id,
//               //相手の情報
//               talkUser: talkUser,
//               //最後のメッセージ
//               lastMessage: doc.data()['last_message'],
//               //最後に送信された時間
//               lastTime: doc.data()["last_sendTime"],
//               //未読メッセージの数
//               unreadMessageCount: [
//                 // {talkUserId: 0},
//                 {myUid: unreadMessageCount}
//               ],
//             );
//             talkRooms.add(talkRoom);
//           }
//         }
//       });
//       return talkRooms;
//     } catch (e) {
//       print("参加しているルームの取得失敗 == $e");
//       throw e;
//     }
//   }

// トークルームを非表示にする関数
