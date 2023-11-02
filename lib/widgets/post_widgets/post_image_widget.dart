import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// ヘッダー画像
class HeaderImageInput extends StatefulWidget {
  final Uint8List? headerImageBytes; // storageに画像があったときに入ってくる
  final void Function(String?) setImagePath; // 画像パスを設定するコールバック関数
  final void Function(Uint8List?) setImageBytes; // 画像データを設定するコールバック関数

  const HeaderImageInput({
    super.key,
    this.headerImageBytes,
    required this.setImagePath,
    required this.setImageBytes,
  });

  @override
  State<HeaderImageInput> createState() => _HeaderImageInputState();
}

class _HeaderImageInputState extends State<HeaderImageInput> {
  XFile? _pickedFile; // ヘッダー画像
  CroppedFile? _croppedFile; // トリミング画像

  bool _isLoading = false;

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  // フォルダから写真を取ってくる
  Future<void> _uploadHeaderImage() async {
    _startLoading(); // ローディング開始
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        _croppedFile = null;
        widget.setImagePath(_pickedFile!.path); // 親に画像パスを通知
      });
    }
    _stopLoading(); // ローディング終了
  }

  // 画像の切り抜き
  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
      );
      if (croppedFile != null) {
        setState(() {
          _pickedFile = null;
          _croppedFile = croppedFile;
          widget.setImagePath(_croppedFile!.path); // 親に画像パスを通知
        });
      }
    }
  }

  // 画像をクリアする
  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
      widget.setImagePath(null); // 親に画像パスをクリアすることを通知
      widget.setImageBytes(null); // 親に画像データをクリアすることを通知
    });
  }

  @override
  Widget build(BuildContext context) {
    final path = _croppedFile?.path ?? _pickedFile?.path;
    final isImageAvailable = path != null && File(path).existsSync();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ヘッダー画像を追加する",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        const SizedBox(height: 16.0),
        _isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              ) // ローディング中にインジケータを表示
            : Row(
                children: [
                  Container(
                    width: 180,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    alignment: Alignment.center,
                    child: isImageAvailable
                        ? Image.file(
                            File(path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : widget.headerImageBytes != null
                            ? Image.memory(
                                widget.headerImageBytes!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : const Text(
                                "No Image",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _uploadHeaderImage,
                          icon: const Icon(
                            Icons.folder_copy,
                            color: Colors.white,
                          ),
                          label: const Text("フォルダ"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                        ),
                        if (isImageAvailable)
                          ElevatedButton.icon(
                            onPressed: _cropImage,
                            icon: const Icon(
                              Icons.crop,
                              color: Colors.white,
                            ),
                            label: const Text("編集"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          ),
                        if (isImageAvailable)
                          ElevatedButton.icon(
                            onPressed: _clear,
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            label: const Text("削除"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}

//画像を追加
class ImageInput extends StatefulWidget {
  final Uint8List? imageBytes; //storageに画像があったときに入ってくる
  final void Function(String?) setImagePath; // 画像パスを設定するコールバック関数
  final void Function(Uint8List?) setImageBytes; // 画像データを設定するコールバック関数

  const ImageInput({
    super.key,
    this.imageBytes,
    required this.setImagePath,
    required this.setImageBytes,
  });

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  // File? _storeImage; //画像

  final bool _isLoading = false;

  XFile? _pickedFile; // ヘッダー画像
  CroppedFile? _croppedFile; // トリミング画像

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    //写真のファイルパスを取得
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 600);
    // _clearImage();
    setState(() {
      _croppedFile = null;
      _pickedFile = pickedFile;
      widget.setImagePath(_pickedFile!.path); // 親に画像パスを通知
    });
  }

  Future cropImage() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      cropStyle: CropStyle.circle, // 円形に切り抜く
    );
    if (croppedFile != null) {
      setState(() {
        _pickedFile = null;
        _croppedFile = croppedFile;
        widget.setImagePath(_croppedFile!.path); // 親に画像パスを通知
      });
    }
  }

  void _clearImage() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
      widget.setImagePath(null); // 親に画像パスをクリアすることを通知
      widget.setImageBytes(null); // 親に画像データをクリアすることを通知
    });
  }

  @override
  Widget build(BuildContext context) {
    final path = _croppedFile?.path ?? _pickedFile?.path;
    final isImageAvailable = path != null && File(path).existsSync();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "画像を追加する",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        const SizedBox(height: 16.0),
        _isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              ) // ローディング中にインジケータを表示
            : Row(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: Colors.grey)),
                    alignment: Alignment.center,
                    child: isImageAvailable
                        ? ClipOval(
                            child: Image.file(
                              File(path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : widget.imageBytes != null
                            ? ClipOval(
                                child: Image.memory(
                                  widget.imageBytes!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : const Text(
                                "No Image",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _takePicture,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          label: const Text("カメラ"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                        ),
                        ElevatedButton.icon(
                          // onPressed: _getImageFromGallery,
                          onPressed: cropImage,
                          icon: const Icon(
                            Icons.folder_copy,
                            color: Colors.white,
                          ),
                          label: const Text("フォルダ"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                        ),
                        if (isImageAvailable)
                          ElevatedButton.icon(
                            onPressed: _clearImage,
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            label: const Text("削除"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
