import 'package:basketball_app/utils/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../models/account/account.dart';

class AuthenticationService {
  static Account? myAccount;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  static final _firestoreInstance = FirebaseFirestore.instance;

  static final CollectionReference users =
      _firestoreInstance.collection("users");

  //authのユーザーを取得
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

  //どの認証をしたのかを再認証する
  String? checkAuthProvider(User user) {
    try {
      for (UserInfo userInfo in user.providerData) {
        if (userInfo.providerId == 'google.com') {
          return "google";
        } else if (userInfo.providerId == 'apple.com') {
          return "apple";
        }
      }
      return null;
    } catch (e) {
      throw getErrorMessage(e);
    }
  }

  //再認証プロセス google
  Future<void> reAuthenticateWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? user = FirebaseAuth.instance.currentUser;
      await user?.reauthenticateWithCredential(credential);
    }
  }

  //再認証プロセス apple
  Future<void> reAuthenticateWithApple() async {
    final appleIdCredential =
        await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ]);

    OAuthProvider oAuthProvider = OAuthProvider("apple.com");
    AuthCredential credential = oAuthProvider.credential(
      idToken: appleIdCredential.identityToken,
      accessToken: appleIdCredential.authorizationCode,
    );

    User? user = FirebaseAuth.instance.currentUser;
    await user?.reauthenticateWithCredential(credential);
  }
}
