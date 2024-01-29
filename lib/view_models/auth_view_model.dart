import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../infrastructure/firebase/account_firebase.dart';
import '../../infrastructure/firebase/authentication_service.dart';
import '../../utils/error_handler.dart';
import '../models/auth/auth_status.dart';
import '../state/providers/global_loader.dart';

class AuthViewModel extends ChangeNotifier {
  final auth = FirebaseAuth.instance;

  Future<bool> signInWithApple(WidgetRef ref) async {
    try {
      ref.read(globalLoaderProvider.notifier).setLoaderValue(true);
      UserCredential? user = await authenticateWithApple();
      if (user != null) {
        // firebaseにユーザーが存在するか確認
        bool userExists =
            await AccountFirestore.checkUserExists(user.user!.uid);
        if (userExists) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print("サインインに失敗しました　$e");
      throw getErrorMessage(e);
    } finally {
      ref.read(globalLoaderProvider.notifier).setLoaderValue(false);
    }
  }

  Future<bool> signInWithGoogle(WidgetRef ref) async {
    try {
      ref.read(globalLoaderProvider.notifier).setLoaderValue(true);
      UserCredential? user = await authenticateWithGoogle();
      if (user != null) {
        // firebaseにユーザーが存在するか確認
        bool userExists =
            await AccountFirestore.checkUserExists(user.user!.uid);
        if (userExists) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print("サインインに失敗しました　$e");
      throw getErrorMessage(e);
    } finally {
      ref.read(globalLoaderProvider.notifier).setLoaderValue(false);
    }
  }

  Future<AuthStatus> signIn(WidgetRef ref) async {
    final user = await AuthenticationService().getCurrentUser();
    if (user == null) return AuthStatus.unauthenticated; // 認証されていない

    //Firestoreにユーザーデータがあるかチェック
    final userAccount = await AccountFirestore.fetchUserData(user.uid);
    if (userAccount != null) {
      //トークン更新
      AuthenticationService().updateUserToken(user);

      return AuthStatus.authenticated; // 認証され、Firestoreにデータがある
    } else {
      return AuthStatus.accountNotCreated; // アカウントはあるが、Firestoreにデータがない
    }
  }

  Future<bool> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    if (!kIsWeb) {
      await googleSignIn.signOut();
    }
    await auth.signOut();
    return true;
  }

  //appleでサインイン
  Future<UserCredential?> authenticateWithApple() async {
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

    // Firebaseでサインイン
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    return userCredential;
  }

  //googleサインイン
  Future<UserCredential?> authenticateWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;

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

      // Firebaseでサインイン
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      return userCredential;
    }
    return null;
  }
}
