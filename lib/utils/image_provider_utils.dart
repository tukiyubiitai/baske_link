import 'dart:io';

import 'package:flutter/material.dart';

class ImageProviderUtils {
  //ローカル画像ファイルまたはネットワーク上の画像パスから ImageProvider オブジェクトを生成
  static ImageProvider<Object>? getUserImage(
      File? localImage, String? networkImagePath) {
    if (localImage != null) {
      return FileImage(localImage);
    } else if (networkImagePath != null && networkImagePath.isNotEmpty) {
      return NetworkImage(networkImagePath);
    }
    return null;
  }
}
