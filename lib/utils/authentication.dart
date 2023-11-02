import 'package:basketball_app/repository/users_firebase.dart';
import 'package:basketball_app/screen/timeline/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/account.dart';
import '../screen/authentication/create_account_page.dart';
import '../widgets/common_widgets/snackbar_utils.dart';

class Authentication {
  static Account? myAccount;

  // //Firebaseアプリ初期化
  static Future<FirebaseApp> initializeFirebase(
      {required BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    //現在ログインしているユーザーを取得
    User? user = FirebaseAuth.instance.currentUser;

    //ユーザーが存在する場合、Navigatorを使用してUserInfoScreenに遷移することで、
    // 自動的にログインするための処理
    if (user != null) {
      //ユーザが存在するか確認
      bool userExists = await UserFirestore.checkUserExists(user.uid);
      if (userExists) {
        //新しいトークンを発行
        final newToken = await FirebaseMessaging.instance.getToken();
        // Firestoreから既存のトークンを取得する
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final userSnapshot = await userDoc.get();
        final storedToken = userSnapshot.data()!['myToken'];
        if (newToken != storedToken) {
          // 新しいtokenに変更
          await userDoc.update({'myToken': newToken});
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const BottomTabNavigator(
                    initialIndex: 1,
                    userId: '',
                  )),
        );
      } else {
        // ユーザーデータが存在しない場合、CreateAccountPageに遷移
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CreateAccountPage(),
          ),
        );
      }
    }
    return firebaseApp;
  }

  //appleでサインイン
  static Future<UserCredential?> AppleSignIn(
      {required BuildContext context}) async {
    final rawNonce = generateNonce();

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
      accessToken: appleCredential.authorizationCode,
    );

    try {
      // Firebaseでサインイン
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      // ユーザーが存在するか確認
      bool userExists =
          await UserFirestore.checkUserExists(userCredential.user!.uid);
      // onLoginSuccess(context);

      if (userExists) {
        // ユーザーが存在する場合、MyStatefulWidgetに遷移
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BottomTabNavigator(
                    initialIndex: 1,
                    userId: '',
                  )),
        );
      } else {
        // ユーザーが存在しない場合、CreateAccountPageに遷移
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CreateAccountPage()),
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // サインインエラーのハンドリング
      showErrorSnackBar(context: context, text: 'エラーが発生しました。もう一度お試しください。');
    } on FirebaseException catch (e) {
      // その他のFirebase関連エラーのハンドリング
      showErrorSnackBar(context: context, text: 'エラーが発生しました。もう一度お試しください。');
    } catch (e) {
      // その他の予期しないエラーのハンドリング
      showErrorSnackBar(context: context, text: 'エラーが発生しました。もう一度お試しください。');
    }

    return null;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    //Googleアカウントにログインし、
    final GoogleSignIn googleSignIn = GoogleSignIn();

    //そのアカウントの情報をGoogleSignInAccountオブジェクトとして取得する。
    // アカウント情報が取得できた場合は、googleSignInAccount変数に格納する.
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    //アカウント情報が取得できた場合
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      //Googleアカウントの認証情報からAuthCredentialオブジェクトを作成する。
      // アクセストークンとIDトークンを引数に与え、credential変数に格納する。
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        //FirebaseAuthオブジェクトを使用して、AuthCredentialオブジェクトを使用して、Firebaseにログインする。
        // 成功した場合、UserCredentialオブジェクトを取得し、userCredential変数に格納する。
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        if (user != null) {
          // onLoginSuccess(context);
          // ログイン成功時の処理
          bool userExists = await UserFirestore.checkUserExists(user.uid);

          if (userExists) {
            // ユーザーが存在する場合、MyStatefulWidgetに遷移
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const BottomTabNavigator(
                        initialIndex: 1,
                        userId: '',
                      )),
            );
          } else {
            // ユーザーが存在しない場合、CreateAccountPageに遷移
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateAccountPage()),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'そのアカウントは既に存在しています',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          // handle the error here
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: '認証情報のアクセス中にエラーが発生しました。もう一度やり直してください。',
            ),
          );
        }
      } catch (e) {
        // handle the error here
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Google Sign-Inの使用中にエラーが発生しました。もう一度やり直してください。',
          ),
        );
      }
    }
    return user;
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      //現在のプラットフォームがWebではない場合に、コードブロックを実行することを意味します
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}
