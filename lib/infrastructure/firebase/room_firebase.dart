import 'package:basketball_app/infrastructure/firebase/account_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/account/account.dart';
import '../../models/talk/talkroom.dart';
import '../../utils/error_handler.dart';

//chatルーム作成

/*
isHidden = trueは非表示 falseは表示
 */

class RoomFirestore {
  static final FirebaseFirestore _firestoreInstance =
      FirebaseFirestore.instance;

  static final CollectionReference<Map<String, dynamic>> _roomCollection =
      _firestoreInstance.collection("room");

  static final joinedRoomSnapshot = _roomCollection.snapshots();

  //未読のメッセージの数を取得
  Future<int> getUnreadMessageCount(String roomId, String myUid) async {
    final messageCollection = _roomCollection.doc(roomId).collection('message');

    // recipient_idが自分(myUid)で、かつisReadがfalseのメッセージを取得
    final querySnapshot = await messageCollection
        .where('recipient_id', isEqualTo: myUid)
        .where('isRead', isEqualTo: false)
        .get();

    return querySnapshot.docs.length;
  }

  //非表示のトークルームを全て表示させる
  Future<bool> updateIsHiddenForUser(String myUid) async {
    // 自分が含まれるトークルームの一覧を取得
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
    return true;
  }

  //非表示設定のチェック サブコレクションisHiddenの作成
  static Future<bool> checkAndSetIsHidden(
      String roomId, String myUid, String talkUserId) async {
    final isHiddenRef = _roomCollection.doc(roomId).collection('isHidden');
    final myUidField = {myUid: false};
    // final talkUserField = {talkUserId: true};

    // myUidがtrueのデータを検索
    final myUidSnapshot = await isHiddenRef.where(myUid, isEqualTo: true).get();

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
    // await isHiddenRef.doc(talkUserId).set(talkUserField);
    return false; // デフォルトは非表示設定が無効
  }

  //削除するときに自分が参加しているルームを取得する
  Future<List<TalkRoom>> getJoinedRooms(String myUid) async {
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

      final talkUser = await AccountFirestore.fetchUserData(talkUserId);

      final talkRoom = TalkRoom(
        roomId: doc.id,
        talkUser: talkUser,
        lastMessage: doc.data()['last_message'],
        lastTime: doc.data()["last_sendTime"],
      );

      talkRooms.add(talkRoom);
    }

    return talkRooms;
  }

  // 自分と相手のチャットルームが存在するかを探す
  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> findTalkRoom(
      String myUid, String talkUserId) async {
    final querySnapshot = await _roomCollection
        .where("joined_user_ids", arrayContains: talkUserId)
        .get();

    for (var doc in querySnapshot.docs) {
      // QueryDocumentSnapshotをMap<String, dynamic>にキャスト
      final data = doc.data();
      if (data["joined_user_ids"].contains(myUid)) {
        // docをQueryDocumentSnapshot<Map<String, dynamic>>にキャスト
        return doc;
      }
    }
    return null;
  }

  // チャットルームを作成する関数
  Future<bool> createTalkRoom(
    Account talkUserAccount,
    String myUid,
  ) async {
    final talkUserName = talkUserAccount.name;
    final talkUserId = talkUserAccount.id;

    // 自分と相手のチャットルームが存在するかを確認するため、探す
    final existingRoom = await findTalkRoom(myUid, talkUserId);

    if (existingRoom != null) {
      print('同じユーザとのトークルームは既に存在します');
      return false; // 既存のトークルームがある場合はここで処理を終了
    }

    //相手のブロックリストに自分が入っていたらトークを作れなくする
    final bool isBlock = await AccountFirestore().isBlocked(talkUserId, myUid);
    if (isBlock == true) {
      print("このユーザーとはトークルームを作成できません");
      return false;
    }

    // 新しいトークルームを作成
    final newRoomData = {
      //参加しているユーザー
      "joined_user_ids": [talkUserId, myUid],
      //未読のメッセージの数
      "unreadMessageCount": [
        {talkUserId: null},
        {myUid: null}
      ],
      "created_time": Timestamp.now(),
    };

    await _roomCollection.add(newRoomData);
    print('トークルームが作成されました: $talkUserName');
    return true;
  }

  // 非表示設定と既読状態の更新
  Future<void> updateHiddenAndReadStatus(
      String roomId, String talkUserId, String myAccountId) async {
    // トークルームの非表示設定コレクションへの参照を取得
    final isHiddenCollection =
        _firestoreInstance.collection("room/$roomId/isHidden");
    // トークルームの既読状態コレクションへの参照を取得
    final isReadCollection =
        _firestoreInstance.collection("room/$roomId/isRead");

    // talkUserIdに関連する非表示設定のドキュメントを取得
    final isHiddenSnapshot = await isHiddenCollection.doc(talkUserId).get();
    // 非表示設定が存在しない場合、デフォルト値（非表示ではない）で設定
    if (!isHiddenSnapshot.exists) {
      await isHiddenCollection.doc(talkUserId).set({talkUserId: false});
    } else if (isHiddenSnapshot.exists &&
        isHiddenSnapshot.data()?[talkUserId] == true) {
      // 非表示設定が存在し、非表示になっている場合、表示に更新
      await isHiddenCollection.doc(talkUserId).update({talkUserId: false});
    }
    // myAccountIdに関連する既読状態のドキュメントを取得
    final isReadSnapshot = await isReadCollection.doc(myAccountId).get();
    // 既読状態が存在し、既読でない場合、既読に更新
    if (isReadSnapshot.exists && isReadSnapshot.data()?[myAccountId] == true) {
      await isReadCollection.doc(myAccountId).update({myAccountId: false});
    }
  }

  //roomを削除
  Future<bool> deleteRoomAndSubCollections(String roomId) async {
    DocumentReference docRef = _roomCollection.doc(roomId);
    await deleteSubCollection(roomId);
    await docRef.delete().then((_) {
      return true;
    }).catchError((e) {
      print("talkRoom削除エラー： $e");
      throw getErrorMessage(e);
    });
    return false;
  }

  //サブコレクションの削除
  Future<void> deleteSubCollection(String roomId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
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
  }

  //自分が参加しているルームを取得する
  Future<List<TalkRoom>?> fetchJoinedRooms(String myUid) async {
    List<TalkRoom> talkRooms = [];
    Account? talkUser;

    // トークルームを作成時間の逆順で取得
    final snapshot =
        await _roomCollection.orderBy("created_time", descending: true).get();

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>?; // nullチェックを追加
      if (data != null && data["joined_user_ids"].contains(myUid)) {
        late String talkUserId;
        data["joined_user_ids"].forEach((id) {
          if (id != myUid) {
            talkUserId = id;
            return;
          }
        });

        talkUser = await AccountFirestore.fetchUserData(talkUserId);
        final isHidden =
            await RoomFirestore.checkAndSetIsHidden(doc.id, myUid, talkUserId);
        int unreadMessageCount =
            await RoomFirestore().getUnreadMessageCount(doc.id, myUid);

        if (!isHidden) {
          final talkRoom = TalkRoom(
            roomId: doc.id,
            talkUser: talkUser,
            lastMessage: data['last_message'],
            lastTime: data["last_sendTime"],
            unreadMessageCount: [
              {myUid: unreadMessageCount}
            ],
          );
          talkRooms.add(talkRoom);
        }
      }
    }
    return talkRooms;
  }
}
