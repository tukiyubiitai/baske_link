import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../infrastructure/firebase/account_firebase.dart';
import '../../utils/error_handler.dart';
import '../utils/loading_manager.dart';
import '../utils/logger.dart';

class AuthViewModel extends ChangeNotifier {
  final auth = FirebaseAuth.instance;

  /// ユーザー認証を行い、その存在をFirebaseで確認します。
  /// [user] - ユーザー認証の結果。
  /// 戻り値はユーザーが存在する場合はtrue、そうでない場合はfalseです。
  Future<bool> authenticateUser(UserCredential? user) async {
    if (user != null) {
      // firebaseにユーザーが存在するか確認
      bool userExists = await AccountFirestore.checkUserExists(user.user!.uid);
      return userExists;
    }
    return false;
  }

  /// Appleでサインインを試み、成功すればユーザー認証を行います。
  /// [ref] - WidgetRefを使用して、Providerから状態を読み取るために使用されます。
  /// 戻り値はサインイン成功時にtrue、失敗時にfalseです。
  Future<bool> signInWithApple(WidgetRef ref) async {
    try {
      LoadingManager.instance.startLoading(ref);
      UserCredential? user = await authenticateWithApple();
      return await authenticateUser(user);
    } catch (e) {
      AppLogger.instance.error("サインインに失敗 $e");
      ErrorHandler.instance.setErrorState(ref, getErrorMessage(e));
      return false;
    } finally {
      LoadingManager.instance.stopLoading(ref);
    }
  }

  /// Googleでサインインを試み、成功すればユーザー認証を行います。
  /// [ref] - WidgetRefを使用して、Providerから状態を読み取るために使用されます。
  /// 戻り値はサインイン成功時にtrue、失敗時にfalseです。
  Future<bool> signInWithGoogle(WidgetRef ref) async {
    try {
      //ロード開始
      LoadingManager.instance.startLoading(ref);
      UserCredential? user = await authenticateWithGoogle();
      return await authenticateUser(user);
    } catch (e) {
      //エラーハンドリング
      AppLogger.instance.error("サインインに失敗 $e");
      ErrorHandler.instance.setErrorState(ref, getErrorMessage(e));
      return false;
    } finally {
      //ロード開始
      LoadingManager.instance.stopLoading(ref);
    }
  }

  Future<bool> signInWithGoogles(WidgetRef ref) async {
    try {
      //ロード開始
      LoadingManager.instance.startLoading(ref);
      UserCredential? user = await authenticateWithGoogle();
      if (user != null) {
        return true;
      }
      return false;
    } catch (e) {
      //エラーハンドリング
      AppLogger.instance.error("サインインに失敗 $e");
      ErrorHandler.instance.setErrorState(ref, getErrorMessage(e));
      return false;
    } finally {
      //ロード開始
      LoadingManager.instance.stopLoading(ref);
    }
  }

  /// Appleでのサインインプロセスを実行するメソッドです。
  /// Apple IDを使用してユーザー認証を行い、その結果をFirebase Authで使用するためのOAuthCredentialに変換します。
  /// 戻り値はFirebase Authを通じて認証されたUserCredentialです。
  /// このメソッドはユーザーがApple IDを用いてアプリにログインする際に使用されます。
  Future<UserCredential?> authenticateWithApple() async {
    final rawNonce = generateNonce();

    // Apple IDを使用して認証情報をリクエストします。
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // Appleから返された認証情報をOAuthCredentialに変換します。
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
      accessToken: appleCredential.authorizationCode,
    );

    // 生成されたOAuthCredentialを使用してFirebaseでのサインインを行います。
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    return userCredential;
  }

  /// Googleでのサインインプロセスを実行するメソッドです。
  /// Googleアカウントを使用してユーザー認証を行い、その結果をFirebase Authで使用するためのAuthCredentialに変換します。
  /// 戻り値はFirebase Authを通じて認証されたUserCredentialです。
  /// このメソッドはユーザーがGoogleアカウントを用いてアプリにログインする際に使用されます。
  ///googleサインイン
  Future<UserCredential?> authenticateWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    // Googleアカウントでのログインを試みます。
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // GoogleSignInAccountオブジェクトを取得します。
    // ユーザーがGoogleアカウントでログインした場合にこのオブジェクトが返されます。
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    // ユーザーがGoogleアカウントでのログインに成功した場合
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // Googleアカウントの認証情報からAuthCredentialを生成します。
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // 生成されたAuthCredentialを使用してFirebaseでのサインインを行います。
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      return userCredential;
    }
    return null;
  }

  /// ユーザーのサインアウトを行います。
  /// Webプラットフォームではない場合、Googleアカウントからもサインアウトします。
  /// 戻り値はサインアウトが成功したかどうかです。
  Future<bool> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    if (!kIsWeb) {
      await googleSignIn.signOut();
    }
    await auth.signOut();
    return true;
  }
}
