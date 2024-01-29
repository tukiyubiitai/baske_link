import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

import '../../utils/error_handler.dart';

class ImageManager {
  // Firebase Storageから指定された画像を削除する
  static Future<void> deleteImage(String fileUrl) async {
    Reference ref = FirebaseStorage.instance.refFromURL(fileUrl);
    await ref.delete();

    print("画像を削除しました: $fileUrl");
  }

  // 画像をFirebase Storageにアップロードし、ダウンロードURLを返す
  static Future<String?> uploadImage(String filePath,
      {String? directory}) async {
    File file = File(filePath);
    if (!file.existsSync()) {
      print("ファイルが存在しません: $filePath");
      return null;
    }

    try {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Firebase Storageのルートリファレンスを取得
      Reference referenceRoot = FirebaseStorage.instance.ref();
      // アップロードする画像ファイルのパスを指定
      Reference referenceDirImages =
          referenceRoot.child('$directory/$uniqueFileName');

      await referenceDirImages.putFile(file);
      String downloadURL = await referenceDirImages.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("画像アップロードエラー: ${getErrorMessage(e)}");
      return null;
    }
  }

  Future<String?> uploadUserImage(String imagePath) async {
    String? directory = 'userImages';
    try {
      return await uploadImage(imagePath, directory: directory);
    } catch (e) {
      // 適切なエラーハンドリング
      Logger().e("プロフィール画像のアップロードに失敗しました, $e");
      return null;
    }
  }
// //画像をstorageにアップロード
// static Future<String?> uploadImageFromPathToFirebaseStorage(
//     String imagePath) async {
//   File imageFile = File(imagePath);
//
//   try {
//     String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
//
//     // Firebase Storageのルートリファレンスを取得
//     Reference referenceRoot = FirebaseStorage.instance.ref();
//
//     // アップロードする画像ファイルのパスを指定
//     Reference referenceDirImages =
//         referenceRoot.child('PostImages/$uniqueFileName');
//
//     // 画像ファイルをアップロード
//     await referenceDirImages.putFile(imageFile);
//
//     // アップロード後のダウンロードURLを取得
//     String downloadURL = await referenceDirImages.getDownloadURL();
//     print('Image uploaded to Firebase Storage. Download URL: $downloadURL');
//     return downloadURL;
//   } catch (e) {
//     print(
//         'Error uploading image to Firebase Storage:  ${getErrorMessage(e)}');
//     return null;
//   }
// }
}
