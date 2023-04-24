import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../bottom_navigation.dart';

class Authentication {
  //Firebaseアプリ初期化
  static Future<FirebaseApp> initializeFirebase(
      {required BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    //現在ログインしているユーザーを取得
    User? user = FirebaseAuth.instance.currentUser;

    //ユーザーが存在する場合、Navigatorを使用してUserInfoScreenに遷移することで、
    // 自動的にログインするための処理
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyStatefulWidget(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  //サインイン
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
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
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
