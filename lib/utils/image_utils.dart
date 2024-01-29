import 'dart:io';

class ImageUtils {
  /// shouldShowDefaultImageメソッドは、デフォルトの画像を表示するかどうかを判断します。
  static bool shouldShowDefaultImage(
      File? localImage, String? networkImagePath) {
    return localImage == null &&
        (networkImagePath == null || networkImagePath.isEmpty);
  }
}
