import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

String firebaseErrorMessage(dynamic error) {
  if (error is FirebaseException) {
    switch (error.code) {
      case 'network-request-failed':
        return 'ネットワークに問題があります。接続を確認してください。';
      case 'object-not-found':
        return '指定されたオブジェクトが見つかりません。';
      case 'bucket-not-found':
        return '指定されたバケットが見つかりません。';
      case 'project-not-found':
        return '指定されたプロジェクトが見つかりません。';
      case 'quota-exceeded':
        return 'ストレージのクォータを超えました。';
      // 他のFirebaseエラーコードに基づくケースを追加
      default:
        return 'Firebaseでエラーが発生しました。後ほど再試行してください。';
    }
  } else {
    // Firebase以外の未知のエラーの場合
    return '予期せぬエラーが発生しました。アプリを再起動してください。';
  }
}

String firebaseAuthErrorMessage(dynamic error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-email':
        return 'メールアドレスの形式が正しくありません。';
      case 'user-disabled':
        return 'このユーザーは無効です。';
      case 'user-not-found':
        return 'ユーザーが見つかりません。';
      case 'wrong-password':
        return 'パスワードが間違っています。';
      default:
        return '未知のエラーが発生しました。';
    }
  } else {
    // Firebase以外の未知のエラーの場合
    return '予期せぬエラーが発生しました。アプリを再起動してください。';
  }
}

String getErrorMessage(dynamic error) {
  if (error is FirebaseException) {
    Logger().e("FirebaseException: $error");
    return firebaseErrorMessage(error);
  } else if (error is FirebaseAuthException) {
    Logger().e("FirebaseAuthException: $error");
    return firebaseAuthErrorMessage(error);
  } else {
    Logger().e("未知のエラーが発生しました: $error");
    return "不明なエラーが発生しました。 アプリを再起動して下さい ";
  }
}

class HttpStatusErrorMessage {
  static String getHttpMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return '不正なリクエストです。入力内容を確認してください。';
      case 401:
        return '認証に失敗しました。ログイン情報を確認してください。';
      case 403:
        return 'アクセス権限がありません。';
      case 404:
        return 'リソースが見つかりませんでした。';
      case 408:
        return 'リクエストがタイムアウトしました。ネットワーク状況を確認してください。';
      case 500:
        return 'サーバー内部エラーが発生しました。管理者に連絡してください。';
      case 503:
        return 'サービス利用不可。サーバーがダウンしている可能性があります。';
      default:
        return '予期せぬエラーが発生しました。エラーコード: $statusCode';
    }
  }
}
