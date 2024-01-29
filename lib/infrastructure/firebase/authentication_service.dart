import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../models/account/account.dart';

class AuthenticationService {
  static Account? myAccount;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  static final _firestoreInstance = FirebaseFirestore.instance;

  static final CollectionReference users =
      _firestoreInstance.collection("users");

  //現在のユーザーを取得
  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  // アカウント情報を更新するメソッド
  static void updateMyAccount(Account account) {
    myAccount = account;
  }

  // ユーザーが存在する場合の追加処理
  Future<void> updateUserToken(User user) async {
    // 新しいFirebase Messagingトークンを取得
    final newToken = await fcm.getToken();

    // Firestoreからユーザー情報を取得
    final userDoc = users.doc(user.uid);
    final userSnapshot = await userDoc.get();

    // トークンが異なる場合は、Firestoreとローカルストレージのトークンを更新
    // final storedToken = userSnapshot.data()!['myToken'];
    // if (newToken != storedToken) {
    //   await userDoc.update({'myToken': newToken});
    // }
    final data = userSnapshot.data();
    if (data != null && data is Map<String, dynamic>) {
      final storedToken = data['myToken'] as String?;
      if (newToken != storedToken) {
        await userDoc.update({'myToken': newToken});
      }
    }
  }
}
