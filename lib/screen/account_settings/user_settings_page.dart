import 'dart:io';

import 'package:basketball_app/utils/users_firebase.dart';
import 'package:flutter/material.dart';

import '../../models/model/account.dart';
import '../../utils/authentication.dart';
import '../../utils/progress_dialog.dart';
import '../../widgets/bottom_navigation.dart';

// アカウントの編集や設定を行う画面

class AccountSettingsPage extends StatefulWidget {
  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  TextEditingController nameController = TextEditingController();
  String nameErrorText = '';
  File? image;
  bool isLoading = false;
  final Account myAccount = Authentication.myAccount!;

  bool shouldShowDefaultImage() {
    return image == null &&
        (myAccount.imagePath == null || myAccount.imagePath!.isEmpty);
  }

  // 画像を取得する関数
  ImageProvider<Object>? getImage() {
    if (image != null) {
      return FileImage(image!); // Fileから画像を取得
    } else if (myAccount.imagePath != null && myAccount.imagePath!.isNotEmpty) {
      return NetworkImage(myAccount.imagePath!); // Firebase Storageから画像を取得
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    nameController.text = myAccount.name;
  }

  //編集が完了したらfirebaseの情報をupdateする
  void _updateUser() async {
    showProgressDialog(context);
    try {
      setState(() {
        isLoading = true;
      });
      String name = nameController.text.trim();
      String imagePath = "";

      setState(() {
        nameErrorText = name.isEmpty ? 'ユーザー名を入力してください' : '';
      });

      if (nameErrorText.isEmpty) {
        // 古い画像のパスを保持
        String oldImagePath = myAccount.imagePath ?? '';
        if (image == null) {
          imagePath = myAccount.imagePath!;
        } else {
          if (oldImagePath.isNotEmpty) {
            await UserFirestore().deleteImage(myAccount.id);
          }
          imagePath = await UserFirestore().uploadImage(myAccount.id, image!);
        }
        Account updateAccount = Account(
          id: myAccount.id,
          name: name,
          imagePath: imagePath,
        );

        // 名前と自己紹介が元々の値と同じであれば、更新ボタンを無効化する
        if (name == myAccount.name && imagePath == myAccount.imagePath) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '編集されていません',
              ),
              backgroundColor: Colors.red,
            ),
          );
          return; // 処理を中断して何も行わない
        }

        var _result = await UserFirestore.updateUser(updateAccount);
        if (_result == true) {
          await UserFirestore.getUser(myAccount.id);
          Authentication.myAccount = updateAccount; // 更新後のアカウント情報を反映
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MyStatefulWidget(
                initialIndex: 3,
                userId: '',
              ), // 登録されたユーザの情報を表示する画面
            ),
            (route) => false, // すべてのページを破棄するため、falseを返す
          );
        }
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        title: Text("アカウント作成"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                  colors: [
                    Colors.indigo,
                    Colors.blue,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(60),
                  topLeft: Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.9),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: Offset(0, 3), // 影の位置調整
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomSpace),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () async {
                        showProgressDialog(context);
                        setState(() {
                          isLoading = true;
                        });
                        var result =
                            await UserFirestore().getImageFromGallery();
                        if (result != null) {
                          setState(() {
                            image = File(result.path);
                          });
                        }
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).pop();
                      },
                      child: shouldShowDefaultImage()
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 65,
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: 40,
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: getImage(),
                              radius: 65,
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: 40,
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 300,
                      child: TextField(
                        maxLength: 10,
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "ユーザー名 (必須)",
                          hintStyle: TextStyle(color: Colors.white),
                          errorText:
                              nameErrorText.isNotEmpty ? nameErrorText : null,
                        ),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          showProgressDialog(context);
                          setState(() {
                            isLoading = true;
                          });
                          _updateUser(); // fromUserAccount が true の場合の処理
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "更新する",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
