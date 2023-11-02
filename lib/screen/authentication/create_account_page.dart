import 'dart:io';

import 'package:basketball_app/utils/users_firebase.dart';
import 'package:basketball_app/widgets/bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../../utils/progress_dialog.dart';
import '../../utils/snackbar_utils.dart';
import '../../widgets/popup_menu.dart';

// 新規ユーザアカウントを作成するための画面

class CreateAccountPage extends StatefulWidget {
  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController nameController = TextEditingController();
  String nameErrorText = '';
  File? image;
  bool _isLoading = false;

  void _saveAccount() async {
    setState(() {
      _isLoading = true;
    });
    final User? user = FirebaseAuth.instance.currentUser; // 現在のユーザーを取得
    final uid = user?.uid; // ユーザーのUIDを取得
    String? imagePath;
    try {
      String name = nameController.text.trim();

      setState(() {
        nameErrorText = name.isEmpty ? 'ユーザー名を入力してください' : '';
      });

      print(name);
      print(image);

      if (nameErrorText.isEmpty) {
        // ユーザー名と自己紹介が正常に入力された場合の処理
        // Firestore への保存などを行う

        if (image != null) {
          imagePath = await UserFirestore().uploadImage(uid!, image!);
        }

        Account newAccount = Account(
          id: uid!,
          name: name,
          imagePath: imagePath,
        );

        var _result = await UserFirestore.setUser(newAccount);
        if (_result == true) {
          showSnackBar(
            context: context,
            text: "ユーザーが作成されました！",
            backgroundColor: Colors.white,
            textColor: Colors.black,
          );
          await UserFirestore.checkUserExists(uid);
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
    } catch (e) {
      print("エラーが発生しました $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
    return _isLoading
        ? ShowProgressIndicator()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.indigo[900],
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.indigo[900],
              title: Text(
                "新規アカウント作成",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                //TODO
                UserActionsMenu(),
              ],
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(60),
                        topLeft: Radius.circular(60),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: Offset(0, 1), // 影の位置調整
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  reverse: true,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomSpace),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          GestureDetector(
                            onTap: () async {
                              try {
                                setState(() {
                                  _isLoading = true;
                                });
                                var result = await UserFirestore().cropImage();
                                if (result != null) {
                                  setState(() {
                                    image = File(result.path);
                                  });
                                }
                              } catch (e) {
                                print(e);
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.indigo[900],
                              foregroundImage:
                                  image == null ? null : FileImage(image!),
                              radius: 60,
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.blue,
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
                                hintStyle: TextStyle(color: Colors.black),
                                errorText: nameErrorText.isNotEmpty
                                    ? nameErrorText
                                    : null,
                              ),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                _saveAccount();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "保存する",
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
