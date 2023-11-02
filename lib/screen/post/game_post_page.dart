import 'dart:io';

import 'package:basketball_app/models/model/practice_post.dart';
import 'package:basketball_app/utils/posts.dart';
import 'package:basketball_app/utils/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/authentication.dart';
import '../../widgets/dropdown_widget.dart';

class PracticeGamePage extends StatefulWidget {
  @override
  State<PracticeGamePage> createState() => _PracticeGamePageState();
}

class _PracticeGamePageState extends State<PracticeGamePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage storage = FirebaseStorage.instance;

  File? _storeImage; //画像
  String? imageUrl; //画像URL
  String? _selectedDropdownValue; // 選択されたアイテム
  final picker = ImagePicker();

  late DatabaseReference dbRef;

  // 必須項目のフォームのコントローラー
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _averageAgeController = TextEditingController();

  //非必須項目のフォームのコントローラー
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Recruitment');
  }

  //画像のアップロード
  Future<String?> _uploadImage(File _storeImage) async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages =
        referenceRoot.child('images/${uniqueFileName}');
    try {
      // Store the file
      await referenceDirImages.putFile(File(_storeImage.path));
      // Success: get the download URL
      String downloadUrl = await referenceDirImages.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }
  }

  //Firestoreに投稿を保存します
  Future<void> _submitRecruitment() async {
    // 画像をアップロードしてURLを取得
    final String? url =
        _storeImage != null ? await _uploadImage(_storeImage!) : null;

    String uid = FirebaseAuth.instance.currentUser!.uid; // ログインしているユーザーのUIDを取得
    bool userLoaded = await UserFirestore.getUser(uid); // ユーザー情報を取得

    if (userLoaded) {
      {
        String postAccountId = Authentication.myAccount!.id; // ユーザーのuserIdを取得

        GamePost newGamePost = GamePost(
          postAccountId: postAccountId,
          location: _selectedDropdownValue.toString(),
          activityTime: _dateTimeController.text,
          averageAge: _averageAgeController.text,
          prefecture: _addressController.text,
          teamName: _titleController.text,
          recruitNumber: _averageAgeController.text,
          level: _levelController.text,
          note: _noteController.text,
          imageUrl: url,
        );
        var result = await PostFirestore.GameAddPost(newGamePost);
        if (result == true) {
          Navigator.pop(context);
        }
      }
    }
  }

  String? _validateRequiredField(String? value) {
    if (value == null || value.isEmpty) {
      return '必須項目です';
    }
    return null;
  }

  void _handleItemSelected(String? value) {
    setState(() {
      _selectedDropdownValue = value;
    });
    // ここで選択されたアイテムを利用する処理を追加
    print('選択されたアイテム: $_selectedDropdownValue');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo[900],
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _submitRecruitment();
              }
            },
            child: Text(
              '投稿する',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'チーム名',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red, fontSize: 30),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  // テキストの文字色を白に設定
                  controller: _titleController,
                  maxLength: 25,
                  decoration: InputDecoration(
                    labelText: "チーム名",
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.diversity_3,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // 枠線の色を透明に設定
                    ),
                  ),
                  validator: _validateRequiredField,
                ),
                SizedBox(height: 10.0),
                Text.rich(
                  TextSpan(
                    text: '開催日',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red, fontSize: 30),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  controller: _dateTimeController,
                  decoration: InputDecoration(
                    labelText: "開催日",
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.event,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // 枠線の色を透明に設定
                    ),
                  ),
                  validator: _validateRequiredField,
                ),
                SizedBox(height: 20.0),
                Text.rich(
                  TextSpan(
                    text: '会場',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red, fontSize: 30),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomDropdownWidget(
                  onItemSelected: _handleItemSelected,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: "会場",
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.location_on, color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // 枠線の色を透明に設定
                    ),
                  ),
                  validator: _validateRequiredField,
                ),
                SizedBox(height: 20.0),
                Text.rich(
                  TextSpan(
                    text: 'レベル',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red, fontSize: 30),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  // テキストの文字色を白に設定
                  controller: _levelController,
                  maxLength: 25,
                  decoration: InputDecoration(
                    labelText: "レベル",
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.diversity_3,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // 枠線の色を透明に設定
                    ),
                  ),
                  validator: _validateRequiredField,
                ),
                SizedBox(height: 16.0),

                Text.rich(
                  TextSpan(
                    text: 'チーム平均年齢',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red, fontSize: 30),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  // テキストの文字色を白に設定
                  controller: _averageAgeController,
                  maxLength: 25,
                  decoration: InputDecoration(
                    labelText: "平均年齢",
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.diversity_3,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // 枠線の色を透明に設定
                    ),
                  ),
                  validator: _validateRequiredField,
                ),
                //画像
                _imageInput(),
                SizedBox(height: 16.0),
                Text(
                  '本文・連絡事項',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _noteController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // 枠線の色を透明に設定
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {}
                    },
                    child: Text(
                      '投稿する',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //カメラから画像を取得
  Future<void> _takePicture() async {
    final picker = ImagePicker();
    //写真のファイルパスを取得
    final imageFile =
        await picker.getImage(source: ImageSource.camera, maxWidth: 600);
    _clearImage();
    setState(() {
      _storeImage = File(imageFile!.path);
    });
  }

  //ファイルから画像を取得
  Future _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    _clearImage();
    setState(() {
      _storeImage = File(pickedFile!.path);
    });
  }

  // 画像のクリア
  void _clearImage() {
    setState(() {
      _storeImage = null;
    });
  }

  //画像追加
  Widget _imageInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "画像を追加する",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            Container(
              width: 150,
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey)),
              child: _storeImage != null
                  ? Image.file(
                      _storeImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Text(
                      "No Image",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
              alignment: Alignment.center,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _takePicture,
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                    label: Text("カメラ"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _getImageFromGallery,
                    icon: Icon(
                      Icons.folder_copy,
                      color: Colors.white,
                    ),
                    label: Text("フォルダ"),
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

class FilterChipItemWidget {
  const FilterChipItemWidget(this.name);

  final String name;
}
