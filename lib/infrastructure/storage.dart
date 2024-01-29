import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late final SharedPreferences _pref;

  //ローカルストレージにアクセスする前に必要な初期化処理を行います。
  Future<StorageService> init() async {
    //_prefフィールドにそのオブジェクトを設定します。
    // その後、初期化が完了したらStorageServiceのインスタンス自体を返します。
    _pref = await SharedPreferences.getInstance();
    return this;
  }

  //指定されたキーと値を使用して文字列をローカルストレージに保存します。
  Future<bool> setString(String key, String value) async {
    return await _pref.setString(key, value);
  }

  //指定されたキー（key）とブール値（value）を使用して、ローカルストレージにブール値を保存します。
  Future<bool> setBool(String key, bool value) async {
    return await _pref.setBool(key, value);
  }
}
