import 'package:basketball_app/repository/users_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/account.dart';
import '../models/talkroom.dart';
import '../utils/authentication.dart';

//chatルーム作成

/*
isRead = 　trueは既読状態 falseは未読状態
isHidden = trueは非表示 falseは表示
 */

class RoomFirestore {
  static final FirebaseFirestore _firestoreInstance =
      FirebaseFirestore.instance;

  static final CollectionReference<Map<String, dynamic>> _roomCollection =
      _firestoreInstance.collection("room");

  static final joinedRoomSnapshot = _roomCollection.snapshots();

  // チャットルームを作成する関数
  static Future<void> createTalkRoom(
      Map<String, dynamic> userData, String myUid) async {
    final userName = userData["name"];
    final talkUserId = userData["user_id"];

    try {
      // 自分と相手のチャットルームが存在するかを確認するため、探す
      final existingRoom = await findTalkRoom(myUid, talkUserId);

      if (existingRoom != null) {
        print('同じユーザとのトークルームは既に存在します');
        return; // 既存のトークルームがある場合はここで処理を終了
      }

      // 新しいトークルームを作成
      final newRoomData = {
        "joined_user_ids": [talkUserId, myUid],
        "read_user": [
          {talkUserId: true},
          {myUid: true}
        ],
        "created_time": Timestamp.now(),
      };

      final roomReference = await _roomCollection.add(newRoomData);

      // 自分 (myUid) に対する未読フラグのドキュメントを追加
      final isReadMyUidCollection =
          roomReference.collection('isRead').doc(myUid);
      await isReadMyUidCollection.set({myUid: true});

      // 相手 (talkUserId) に対する未読フラグのドキュメントを追加
      final isReadUserIdCollection =
          roomReference.collection('isRead').doc(talkUserId);
      await isReadUserIdCollection.set({talkUserId: true});

      print('トークルームが作成されました: $userName');
    } catch (e) {
      // エラーハンドリング: エラーメッセージを共通の関数で処理
      print("トークルームが上手く作成されませんでした$e");
    }
  }

  //自分と相手のチャットルームが存在するかを探す
  static Future<QueryDocumentSnapshot<Map<String, dynamic>>?> findTalkRoom(
      String myUid, String talkUserId) async {
    try {
      final querySnapshot = await _roomCollection
          .where("joined_user_ids", arrayContains: talkUserId)
          .get();

      final docs = querySnapshot.docs;

      for (final doc in docs) {
        final data = doc.data();
        final joinedUserIds = data["joined_user_ids"] as List<dynamic>;
        if (joinedUserIds.contains(myUid)) {
          return doc;
        }
      }
      return null;
    } catch (e) {
      print("findChatRoomでエラーが発生しました$e");
      return null;
    }
  }

//自分が参加しているルームを取得する
  Future<List<TalkRoom>?> fetchJoinedRooms(QuerySnapshot snapshot) async {
    try {
      String myUid = Authentication.myAccount!.id;
      List<TalkRoom> talkRooms = []; //自分が参加しているトークルームのリスト
      Account? talkUser;

      // トークルームを作成時間の逆順で取得
      final snapshot =
          await _roomCollection.orderBy("created_time", descending: true).get();

      //// 取得したトークルームに対する処理
      await Future.forEach(snapshot.docs, (doc) async {
        //ログインユーザーがチャットルームに参加しているかどうかを確認しています。
        if (doc.data()["joined_user_ids"].contains(myUid)) {
          //ログインユーザーがそのチャットルームに参加している場合
          late String talkUserId;
          doc.data()["joined_user_ids"].forEach((id) {
            // ログインユーザー以外のid（対話相手のid）を talkUserId に設定
            if (id != myUid) {
              talkUserId = id;
              return;
            }
          });

          talkUser =
              await UserFirestore.fetchProfile(talkUserId); //対話相手のプロフィール情報を取得
          //非表示設定をチェック
          final isHidden = await checkAndSetIsHidden(doc.id, myUid, talkUserId);

          //自分が参加しているトークが未読か既読かをチェックする
          final isRead = await checkRead(
            doc.id,
            myUid,
          );

          // 非表示設定がfalseの場合のみトークルームを作成
          if (isHidden == false) {
            final talkRoom = TalkRoom(
              //ルームID
              roomId: doc.id,
              //相手の情報
              talkUser: talkUser,
              //最後のメッセージ
              lastMessage: doc.data()['last_message'],
              //最後に送信された時間
              lastTime: doc.data()["last_sendTime"],
              //既読true 未読false
              isRead: isRead,
            );
            talkRooms.add(talkRoom);
          }
        }
      });
      return talkRooms;
    } catch (e) {
      print("参加しているルームの取得失敗 == $e");
    }
    return null;
  }

  // トークルームを非表示にする関数
  static Future<void> hideTalkRoom(String roomId, String myUid) async {
    try {
      final isDeletedCollection =
          _roomCollection.doc(roomId).collection('isHidden');
      // ドキュメントのフィールドを直接アップデート
      await isDeletedCollection.doc(myUid).update({myUid: true});
    } catch (e) {
      print('トークルームの非表示設定に失敗しました: $e');
    }
  }

  // (TalkPage)トークを開いた時にメッセージを未読から既読にする
  static Future<void> updateMessageReadStatus(
      String roomId, String myUid, String talkUserId) async {
    try {
      //isReadサブコレクションを取得
      final isReadCollection = _roomCollection.doc(roomId).collection('isRead');
      final isReadMySnapshot =
          await isReadCollection.doc(myUid).get(); //自分のisRead
      final isReadUserSnapshot =
          await isReadCollection.doc(talkUserId).get(); //相手のisRead

      if (isReadMySnapshot.data()?[myUid] == false) {
        // 自分が未読の場合
        await isReadCollection.doc(myUid).update({myUid: true}); //自分を既読に変更

        if (isReadUserSnapshot.data()?[talkUserId] == false) {
          // 相手も未読の場合
          await _roomCollection.doc(roomId).update({
            "read_user": [
              {talkUserId: false}, //相手は未読に
              {myUid: true} //自分は既読
            ],
          });
        } else {
          // 相手が既読の場合
          await _roomCollection.doc(roomId).update({
            "read_user": [
              {talkUserId: true}, //相手は既読
              {myUid: true} //自分も既読
            ],
          });
        }
      }
    } catch (e) {
      print('既読処理に失敗しました: $e');
    }
  }

  //非表示のトークルームを全て表示させる
  Future<void> updateIsHiddenForUser(String myUid) async {
    try {
      // ユーザーが含まれるトークルームの一覧を取得
      final querySnapshot = await _roomCollection
          .where("joined_user_ids", arrayContains: myUid)
          .get();

      // 各トークルームに対して非表示設定
      for (final doc in querySnapshot.docs) {
        final roomId = doc.id;
        final isDeletedCollection =
            _roomCollection.doc(roomId).collection('isHidden');

        // ユーザーの非表示設定を表示に更新
        await isDeletedCollection.doc(myUid).update({myUid: false});
      }
    } catch (e) {
      print('トークルームを表示に失敗しました: $e');
      return;
    }
  }

  //非表示設定のチェック サブコレクションisHiddenの作成
  static Future<bool> checkAndSetIsHidden(
      String roomId, String myUid, String talkUserId) async {
    try {
      final isHiddenRef = _roomCollection.doc(roomId).collection('isHidden');
      final myUidField = {myUid: false};
      final talkUserField = {talkUserId: true};

      // myUidがtrueのデータを検索
      final myUidSnapshot =
          await isHiddenRef.where(myUid, isEqualTo: true).get();

      if (myUidSnapshot.docs.isNotEmpty) {
        return true; // 非表示設定が有効
      }

      // myUidがfalseのデータを検索
      final myUidFalseSnapshot =
          await isHiddenRef.where(myUid, isEqualTo: false).get();

      if (myUidFalseSnapshot.docs.isNotEmpty) {
        return false; // 非表示設定が無効
      }

      // データが存在しない場合、新しいデータをセット
      await isHiddenRef.doc(myUid).set(myUidField);
      //相手はメッセージを送られてくるまで表示を無効
      await isHiddenRef.doc(talkUserId).set(talkUserField);
      return false; // デフォルトは非表示設定が無効
    } catch (e) {
      print('エラー: $e');
      return false; // エラー発生時もデフォルトは非表示設定が無効
    }
  }

  //トークの未読または既読状態をチェック
  static Future<bool> checkRead(String roomId, String myUid) async {
    try {
      final isReadCollection = _roomCollection.doc(roomId).collection('isRead');
      final isReadMySnapshot = await isReadCollection.doc(myUid).get();
      if (isReadMySnapshot.data()?[myUid] == true) {
        return true; // 既読ならtrueを返す
      } else {
        return false; // 未読ならfalseを返す
      }
    } catch (e) {
      print('エラー: $e');
      return false;
    }
  }

  // 特定のチャットルームのメッセージを取得するストリーム
  static Stream<QuerySnapshot> fetchMessageSnapshot(String roomId) {
    return _roomCollection
        .doc(roomId)
        .collection("message")
        .orderBy("send_time", descending: true)
        .snapshots();
  }

// 送信時刻をもとに相対時間を計算する関数
  String calculateRelativeTime(Timestamp sendTime) {
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

  //メッセージ送信時に呼ばれる
  static Future<void> sendMessage(
      {required String roomId,
      required String message,
      required String talkUserId}) async {
    try {
      final isHiddenCollection =
          _roomCollection.doc(roomId).collection('isHidden');
      final messageCollection =
          _roomCollection.doc(roomId).collection("message");
      final isReadCollection = _roomCollection.doc(roomId).collection('isRead');
      final sendTime = Timestamp.now();

      // talkUserの非表示設定をチェック
      final isHiddenSnapshot = await isHiddenCollection.doc(talkUserId).get();
      // talkUserの既読状態をチェック
      final isReadSnapshot = await isReadCollection.doc(talkUserId).get();

      //existsは指定されたドキュメントが存在するか
      if (isHiddenSnapshot.exists &&
          isHiddenSnapshot.data()?[talkUserId] == true) {
        // もし talkUser が非表示に設定されていた場合、表示に変更
        await isHiddenCollection
            .doc(talkUserId)
            .update({talkUserId: false}); //talkUserを表示させる
      }

      if (isReadSnapshot.data()?[talkUserId] == true) {
        // もし talkUser が既読の場合、未読に設定（サブコレクション）
        await isReadCollection.doc(talkUserId).update({talkUserId: false});
      }

      String myName = Authentication.myAccount!.name;
      String myUid = Authentication.myAccount!.id;

      // メッセージを保存（サブコレクション）
      await messageCollection.add({
        "message": message,
        "sender_id": Authentication.myAccount!.id,
        "send_time": sendTime,
        "user_name": myName,
        "recipient_id": talkUserId
      });

      // ルーム情報を更新
      await _roomCollection.doc(roomId).update({
        "last_message": message,
        "last_sendTime": sendTime,
        "created_time": Timestamp.now(),
        "read_user": [
          {talkUserId: false}, //相手を未読にする
          {myUid: true}
        ],
      });
    } catch (e) {
      print("メッセージの送信失敗: $e");
    }
  }

  //roomを削除
  static Future<void> deleteRooms(String roomId) async {
    DocumentReference docRef = _roomCollection.doc(roomId);
    await deleteSubCollection(roomId);
    await docRef.delete().then((_) {
      print("ドキュメントが削除されました");
    }).catchError((error) {
      print("エラーが発生しました： $error");
    });
  }

  //サブコレクションの削除
  static Future<void> deleteSubCollection(String roomId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      var isHiddenCollection = firestore.collection("room/$roomId/isHidden");
      var isHiddenSnapshots = await isHiddenCollection.get();
      for (var doc in isHiddenSnapshots.docs) {
        await doc.reference.delete();
      }
      print("サブコレクションisHidden削除完了");

      var messageCollection = firestore.collection("room/$roomId/message");
      var messageSnapshots = await messageCollection.get();
      for (var doc in messageSnapshots.docs) {
        await doc.reference.delete();
      }
      print("サブコレクションmessage削除完了");

      var isReadCollection = firestore.collection("room/$roomId/isRead");
      var isReadSnapshots = await isReadCollection.get();
      for (var doc in isReadSnapshots.docs) {
        await doc.reference.delete();
      }
      print("サブコレクションisRead削除完了");
    } catch (e) {
      print("サブコレクションの削除に失敗しました $e");
    }
  }

  //削除するときに自分が参加しているルームを取得する
  Future<List<TalkRoom>> getJoinedRooms(String myUid) async {
    try {
      final querySnapshot = await _roomCollection
          .where("joined_user_ids", arrayContains: myUid)
          .orderBy("created_time", descending: true)
          .get();

      final List<TalkRoom> talkRooms = [];

      for (final doc in querySnapshot.docs) {
        late String talkUserId;
        doc.data()["joined_user_ids"].forEach((id) {
          if (id != myUid) {
            talkUserId = id;
            return;
          }
        });

        final talkUser = await UserFirestore.fetchProfile(talkUserId);

        final talkRoom = TalkRoom(
          roomId: doc.id,
          talkUser: talkUser,
          lastMessage: doc.data()['last_message'],
          lastTime: doc.data()["last_sendTime"],
        );

        talkRooms.add(talkRoom);
      }

      return talkRooms;
    } catch (e) {
      print("参加しているルームの取得失敗 == $e");
      return [];
    }
  }
}
