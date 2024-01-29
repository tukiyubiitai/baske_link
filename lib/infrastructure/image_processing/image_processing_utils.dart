//アイコン用の画像を円状に切り取り
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<dynamic> cropImage() async {
  ImagePicker picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile == null) {
    // ユーザーが画像の選択をキャンセルした場合の処理
    return null;
  }

  final croppedFile = await ImageCropper().cropImage(
    sourcePath: pickedFile.path,
    compressFormat: ImageCompressFormat.jpg,
    compressQuality: 100,
    cropStyle: CropStyle.circle, // 円形に切り抜く
  );
  return croppedFile;
}

Future<dynamic> cropHeaderImage() async {
  ImagePicker picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile == null) {
    // ユーザーが画像の選択をキャンセルした場合の処理
    return null;
  }

  final croppedFile = await ImageCropper().cropImage(
    sourcePath: pickedFile.path,
    compressFormat: ImageCompressFormat.jpg,
    compressQuality: 100,
    cropStyle: CropStyle.rectangle,
  );
  return croppedFile;
}
