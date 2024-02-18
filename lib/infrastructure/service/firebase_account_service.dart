import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

import '../firebase/account_firebase.dart';
import '../firebase/storage_firebase.dart';

class FirebaseAccountService {
  Future<User?> getCurrentUser() async {
    try {
      return AccountFirestore.getCurrentUser();
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> getToken() async {
    // Firebase Messagingトークンの取得処理
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      Logger().e("Firebase Messagingトークンの取得に失敗しました。$e");
      return null;
    }
  }

  Future<String?> uploadUserImage(String imagePath) async {
    // 画像アップロードの処理
    return ImageManager().uploadUserImage(imagePath);
  }
}
