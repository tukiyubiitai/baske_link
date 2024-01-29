// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../models/account/account.dart';
// import '../../services/users_firebase.dart';
// import '../../utils/authentication.dart';
// import '../../utils/snackbar_utils.dart';
// import '../../widgets/bottom_navigation.dart';
// import '../../widgets/progress_indicator.dart';
//
// // アカウントの編集や設定を行う画面
//
// class AccountSettingsPage extends StatefulWidget {
//   const AccountSettingsPage({super.key});
//
//   @override
//   State<AccountSettingsPage> createState() => _AccountSettingsPageState();
// }
//
// class _AccountSettingsPageState extends State<AccountSettingsPage> {
//   TextEditingController nameController = TextEditingController();
//   String nameErrorText = '';
//   File? image;
//   bool _isLoading = false;
//
//   bool _isEditing = false;
//   final Account myAccount = Authentication.myAccount!;
//
//   String name = ''; // name を追加
//   String imagePath = ''; // imagePath を追加
//
//   bool shouldShowDefaultImage() {
//     return image == null &&
//         (myAccount.imagePath == null || myAccount.imagePath!.isEmpty);
//   }
//
//   // 画像を取得する関数
//   ImageProvider<Object>? getImage() {
//     if (image != null) {
//       return FileImage(image!); // Fileから画像を取得
//     } else if (myAccount.imagePath != null && myAccount.imagePath!.isNotEmpty) {
//       // print(myAccount.imagePath);
//       return NetworkImage(myAccount.imagePath!); // Firebase Storageから画像を取得
//     }
//     return null;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     nameController.text = myAccount.name;
//     name = myAccount.name; // name を初期化
//     imagePath = myAccount.imagePath ?? ''; // imagePath を初期化
//     nameController.addListener(() {
//       updateCanUpdate();
//     });
//   }
//
//   //編集が完了したらfirebaseの情報をupdateする
//   void _updateUser() async {
//     final _pref = await SharedPreferences.getInstance();
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       String name = nameController.text.trim();
//       String? imagePath;
//
//       setState(() {
//         nameErrorText = name.isEmpty ? 'ユーザー名を入力してください' : '';
//       });
//
//       if (nameErrorText.isEmpty) {
//         String oldImagePath = myAccount.imagePath ?? '';
//         if (image != null) {
//           // 新しい画像が選択されている場合
//           if (oldImagePath.isNotEmpty) {
//             // 以前の画像(storage)が存在する場合、古い画像を削除
//             await UserFirestore().deleteImage(myAccount.id);
//           }
//           // 新しい画像をアップロード
//           imagePath = await UserFirestore()
//               .uploadUserImageFromPathToFirebaseStorage(myAccount.id, image!);
//           myAccount.imagePath = imagePath; // 画像パスを設定
//         } else if (oldImagePath.isNotEmpty) {
//           // 新しい画像が選択されておらず、以前の画像が存在する場合
//           imagePath = oldImagePath;
//         }
//         //古い画像もなく、新しい画像もない時はnull
//
//         Account updateAccount = Account(
//           id: myAccount.id,
//           name: name,
//           imagePath: imagePath,
//         );
//
//         if (imagePath != null) {
//           _pref.setString(
//             AppConstants.STORAGE_USER_PROFILE_IMAGE,
//             updateAccount.imagePath as String,
//           );
//         }
//         _pref.setString(
//           AppConstants.STORAGE_USER_NAME,
//           updateAccount.name,
//         );
//         _pref.setString(
//           AppConstants.STORAGE_USER_PROFILE_KEY,
//           updateAccount.id,
//         );
//
//         var result = await UserFirestore.updateUser(updateAccount);
//         if (result == true) {
//           showSnackBar(
//             context: context,
//             text: "プロフィール更新が完了しました！",
//             backgroundColor: Colors.white,
//             textColor: Colors.black,
//           );
//           Authentication.myAccount = updateAccount; // 更新後のアカウント情報を反映
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(
//               builder: (context) => BottomTabNavigator(
//                 initialIndex: 3,
//                 userId: '',
//               ), // 登録されたユーザの情報を表示する画面
//             ),
//             (route) => false, // すべてのページを破棄するため、falseを返す
//           );
//         }
//       }
//       setState(() {
//         _isLoading = false;
//       });
//     } catch (e) {
//       showErrorSnackBar(context: context, text: 'エラーが発生しました $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
//     return _isLoading
//         ? ShowProgressIndicator()
//         : Scaffold(
//             resizeToAvoidBottomInset: false,
//             backgroundColor: Colors.indigo[900],
//             appBar: AppBar(
//               leading: IconButton(
//                 icon: const Icon(
//                   Icons.arrow_back,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context); // 画面遷移を戻る処理
//                 },
//               ),
//               elevation: 0,
//               backgroundColor: Colors.indigo[900],
//               title: const Text(
//                 "アカウント編集",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             body: Stack(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: const BorderRadius.only(
//                         topRight: Radius.circular(60),
//                         topLeft: Radius.circular(60),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.3),
//                           spreadRadius: 3,
//                           blurRadius: 10,
//                           offset: const Offset(0, 1), // 影の位置調整
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SingleChildScrollView(
//                   reverse: true,
//                   child: Padding(
//                     padding: EdgeInsets.only(bottom: bottomSpace),
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(
//                             height: 50,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               //画像変更と画像削除
//                               _showBottomSheetMenu(context);
//                             },
//                             child: shouldShowDefaultImage()
//                                 ? CircleAvatar(
//                                     backgroundColor: Colors.indigo[900],
//                                     radius: 65,
//                                     child: const Icon(
//                                       Icons.add_a_photo_outlined,
//                                       size: 40,
//                                       color: Colors.blue,
//                                     ),
//                                   )
//                                 : CircleAvatar(
//                                     backgroundColor: Colors.white,
//                                     backgroundImage: getImage(),
//                                     radius: 65,
//                                     child: const Icon(
//                                       Icons.add_a_photo_outlined,
//                                       size: 40,
//                                       color: Colors.blue,
//                                     ),
//                                   ),
//                           ),
//                           const SizedBox(
//                             height: 30,
//                           ),
//                           SizedBox(
//                             width: 300,
//                             child: TextField(
//                               maxLength: 10,
//                               controller: nameController,
//                               decoration: InputDecoration(
//                                 hintText: "ユーザー名 (必須)",
//                                 hintStyle: const TextStyle(color: Colors.white),
//                                 errorText: nameErrorText.isNotEmpty
//                                     ? nameErrorText
//                                     : null,
//                               ),
//                               style: const TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: _isEditing
//                                 ? ElevatedButton(
//                                     onPressed: () => _updateUser(),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.indigo[900],
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                     child: const Text(
//                                       "更新する",
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   )
//                                 : ElevatedButton(
//                                     onPressed: null,
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.indigo[900],
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                     child: const Text(
//                                       "更新する",
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }
//
//   //画像を削除(storageも)
//   void cleaImage() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       String oldName = myAccount.name;
//       String oldImagePath = myAccount.imagePath ?? '';
//       if (oldImagePath.isNotEmpty) {
//         // 古い画像が存在する場合、Firebase Storage から削除
//         await UserFirestore().deleteImage(myAccount.id);
//         // await UserFirestore().deleteUserImage(oldImagePath, myAccount.id);
//       }
//       Account updateAccount = Account(
//         id: myAccount.id,
//         name: oldName,
//         imagePath: "",
//       );
//       await UserFirestore.updateUser(updateAccount);
//       Authentication.myAccount = updateAccount; // 更新後のアカウント情報を反映
//       // 画像を削除したので、image 変数を null に設定
//       setState(() {
//         image = null;
//         myAccount.imagePath = ""; // ここで imagePath を空の文字列に設定
//         _isLoading = false;
//       });
//     } catch (e) {
//       showErrorSnackBar(context: context, text: 'エラーが発生しました $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   void updateCanUpdate() {
//     final newName = nameController.text.trim();
//     final oldName = myAccount.name;
//
//     setState(() {
//       nameErrorText = newName.isEmpty ? 'ユーザー名を入力してください' : '';
//       _isEditing = newName != oldName || image != null;
//     });
//   }
//
//   void _showBottomSheetMenu(BuildContext context) {
//     showModalBottomSheet(
//         context: context,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//         ),
//         builder: (builder) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               shouldShowDefaultImage()
//                   ? const SizedBox()
//                   : ListTile(
//                       title: const Text(
//                         '画像を削除',
//                         style: TextStyle(color: Colors.red),
//                       ),
//                       leading: const Icon(
//                         Icons.delete,
//                         color: Colors.red,
//                       ),
//                       onTap: () {
//                         _isEditing = true;
//                         cleaImage();
//                         Navigator.of(context).pop();
//                         // ここに設定とプライバシーに関連するアクションを追加
//                       },
//                     ),
//               ListTile(
//                 title: const Text('画像を変更または追加'),
//                 leading: const Icon(Icons.image),
//                 onTap: () async {
//                   try {
//                     setState(() {
//                       _isLoading = true;
//                     });
//                     var result = await UserFirestore().cropImage();
//                     if (result != null) {
//                       setState(() {
//                         image = File(result.path);
//                         _isEditing = true;
//                       });
//                     }
//                     Navigator.of(context).pop();
//                   } catch (e) {
//                     showErrorSnackBar(context: context, text: 'エラーが発生しました $e');
//                   } finally {
//                     setState(() {
//                       _isLoading = false;
//                     });
//                   }
//
//                   // ここにアクティビティに関連するアクションを追加
//                 },
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//             ],
//           );
//         });
//   }
// }
