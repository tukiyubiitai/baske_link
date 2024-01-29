// import 'dart:typed_data';
//
// import 'package:basketball_app/post/repository/posts_firebase.dart';
// import 'package:basketball_app/post/widgets/custom_text_field.dart';
// import 'package:basketball_app/post/widgets/post_image_widget.dart';
// import 'package:basketball_app/post/widgets/tag_chips_widget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:provider/provider.dart';
//
// import '../account/model/account.dart';
// import '../authentication/utils/authentication.dart';
// import '../widgets/common_widgets/progress_dialog.dart';
// import '../widgets/common_widgets/snackbar_utils.dart';
// import 'data/chip_Item.dart';
// import 'model/area_provider.dart';
// import 'model/game_model.dart';
// import 'model/tag_provider.dart';
// import 'widgets/filter_functions.dart';
//
// class GamePostPage extends StatefulWidget {
//   final bool isEditing; //編集モード
//   final String? postId;
//
//   const GamePostPage({super.key, required this.isEditing, this.postId});
//
//   @override
//   State<GamePostPage> createState() => _GamePostPageState();
// }
//
// class _GamePostPageState extends State<GamePostPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final FirebaseStorage storage = FirebaseStorage.instance;
//
//   int? integerValue;
//
//   late DatabaseReference dbRef;
//
//   Uint8List? imageBytes;
//   String? imagePath;
//
//   final Account myAccount = Authentication.myAccount!;
//
//   // 必須項目のフォームのコントローラー
//   final TextEditingController _memberController = TextEditingController();
//   final TextEditingController _teamNameController = TextEditingController();
//
//   //非必須項目のフォームのコントローラー
//   final TextEditingController _noteController = TextEditingController();
//
//   List<String> _ageFilters = [];
//   bool _isLoading = false;
//   late GamePost post; //投稿を編集する時に保存された情報が入ってくる
//
//   bool _validateRequiredFields() {
//     return _teamNameController.text.isNotEmpty &&
//         _teamNameController.text.isNotEmpty &&
//         _ageFilters.isNotEmpty &&
//         integerValue != null;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     dbRef = FirebaseDatabase.instance.ref().child('Recruitment');
//     if (widget.isEditing == true) {
//       _loadPosts(); //投稿を呼び出す
//     }
//   }
//
//   //投稿を編集する際にfirestoreにある情報を読み込む
//   Future<void> _loadPosts() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final loadedPosts =
//           await PostFirestore.getGamePostFromIds(widget.postId as String);
//       final tagModel = Provider.of<TagProvider>(context, listen: false);
//       final areaModel = Provider.of<AreaProvider>(context, listen: false);
//
//       if (loadedPosts != null && loadedPosts.isNotEmpty) {
//         post = loadedPosts[0];
//
//         _memberController.text = post.member;
//         _teamNameController.text = post.teamName;
//         _ageFilters = post.ageList;
//         _noteController.text = post.note ?? "";
//         integerValue = post.level;
//
//         for (String location in post.locationTagList) {
//           tagModel.addTag(location);
//         }
//
//         areaModel.setSelectedValue(post.prefecture);
//
//         if (post.imageUrl != null) {
//           Reference imageRef =
//               FirebaseStorage.instance.refFromURL(post.imageUrl as String);
//           imageBytes = (await imageRef.getData())!;
//         }
//       }
//     } catch (e) {
//       // エラーハンドリング
//       showErrorSnackBar(context: context, text: 'エラーが発生しました $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _memberController.dispose();
//     _teamNameController.dispose();
//     _noteController.dispose();
//     super.dispose();
//   }
//
//   //投稿をfirestoreに保存
//   Future<void> _submitRecruitment() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final tagModel = Provider.of<TagProvider>(context, listen: false);
//       final List<String> tagStrings = tagModel.tagStrings;
//       final areaModel = Provider.of<AreaProvider>(context, listen: false);
//       final String selectedValue = areaModel.selectedValue.toString();
//       if (!_validateRequiredFields()) {
//         showErrorSnackBar(context: context, text: '必須項目が入力されていません');
//         _validateRequiredField('必須項目が入力されていません');
//         return;
//       }
//       if (tagStrings.isEmpty || selectedValue.isEmpty) {
//         if (tagStrings.isEmpty) {
//           tagModel.checkAndSetErrorBorder();
//           showErrorSnackBar(context: context, text: 'タグが追加が追加されていません');
//           return;
//         }
//         showErrorSnackBar(context: context, text: 'エリアが選択されていません');
//         return;
//       }
//       String? url = await PostFirestore.uploadImage(imagePath, null);
//       String postAccountId = Authentication.myAccount!.id; // ユーザーのuserIdを取得
//       GamePost newGamePost = GamePost(
//         postAccountId: postAccountId,
//         locationTagList: tagStrings,
//         prefecture: selectedValue,
//         teamName: _teamNameController.text,
//         createdTime: Timestamp.now(),
//         imageUrl: url,
//         note: _noteController.text,
//         level: integerValue!,
//         member: _memberController.text,
//         ageList: _ageFilters,
//         type: 'game',
//       );
//       var result = await PostFirestore.gameAddPost(newGamePost);
//       if (result == true) {
//         showSnackBar(
//           context: context,
//           text: "投稿が完了しました！",
//           backgroundColor: Colors.white,
//           textColor: Colors.black,
//         );
//         Navigator.popUntil(context, (route) => route.isFirst);
//       }
//     } catch (e) {
//       showErrorSnackBar(context: context, text: 'エラーが発生しました。もう一度お試しください。');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   //投稿を更新させます
//   Future<void> _updateRecruitment() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final tagModel = Provider.of<TagProvider>(context, listen: false);
//       final List<String> tagStrings = tagModel.tagStrings;
//       final areaModel = Provider.of<AreaProvider>(context, listen: false);
//       final String selectedValue = areaModel.selectedValue.toString();
//       if (!_validateRequiredFields()) {
//         showErrorSnackBar(context: context, text: '必須項目が入力されていません');
//         _validateRequiredField('必須項目が入力されていません');
//         return;
//       }
//       if (tagStrings.isEmpty || selectedValue.isEmpty) {
//         if (tagStrings.isEmpty) {
//           tagModel.checkAndSetErrorBorder();
//           showErrorSnackBar(context: context, text: 'タグが追加が追加されていません');
//           return;
//         }
//         showErrorSnackBar(context: context, text: 'エリアが選択されていません');
//         return;
//       }
//
//       // 画像をアップロードしてURLを取得
//       String? url = await PostFirestore.uploadImage(imagePath, post.imageUrl);
//
//       String postAccountId = Authentication.myAccount!.id; // ユーザーのuserIdを取得
//       GamePost updatePost = GamePost(
//         postAccountId: postAccountId,
//         locationTagList: tagStrings,
//         prefecture: selectedValue,
//         teamName: _teamNameController.text,
//         createdTime: Timestamp.now(),
//         imageUrl: url,
//         note: _noteController.text,
//         level: integerValue!.toInt(),
//         member: _memberController.text,
//         ageList: _ageFilters,
//         type: 'game',
//       );
//       var result = await PostFirestore.updateGamePost(
//           widget.postId as String, updatePost);
//       if (result == true) {
//         showSnackBar(
//           context: context,
//           text: "更新が完了しました！",
//           backgroundColor: Colors.white,
//           textColor: Colors.black,
//         );
//         Navigator.popUntil(context, (route) => route.isFirst);
//       }
//     } catch (e) {
//       showSnackBar(
//         context: context,
//         text: "エラーが発生しました！",
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   String? _validateRequiredField(String? value) {
//     if (value == null || value.isEmpty) {
//       return '必須項目です';
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? ShowProgressIndicator()
//         : Scaffold(
//             backgroundColor: Colors.indigo[900],
//             appBar: AppBar(
//               elevation: 0,
//               backgroundColor: Colors.indigo[900],
//               actions: [
//                 TextButton(
//                   onPressed: widget.isEditing
//                       ? () async {
//                           if (_formKey.currentState!.validate()) {
//                             _updateRecruitment();
//                           }
//                         }
//                       : () async {
//                           if (_formKey.currentState!.validate()) {
//                             _submitRecruitment();
//                           }
//                         },
//                   child: Text(
//                     widget.isEditing ? '投稿を更新する' : '投稿する',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             body: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       RequiredCustomTextField(
//                         label: 'チーム名',
//                         hintText: 'チーム名を入力してください',
//                         controller: _teamNameController,
//                         validator: _validateRequiredField,
//                         icon: Icons.diversity_3,
//                       ),
//                       const Row(
//                         children: [
//                           Text.rich(
//                             TextSpan(
//                               text: '活動場所',
//                               style: TextStyle(
//                                   fontSize: 20.0, color: Colors.white),
//                               children: [
//                                 TextSpan(
//                                   text: '*',
//                                   style: TextStyle(
//                                       color: Colors.red, fontSize: 30),
//                                 ),
//                                 TextSpan(
//                                   text: '* 6個まで追加可能',
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 15),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10.0),
//                       const Row(
//                         children: [
//                           Expanded(
//                             child: TgaChips(),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10.0),
//
//                       RequiredCustomTextField(
//                         label: 'メンバー構成',
//                         hintText: '男女混合など',
//                         controller: _memberController,
//                         validator: _validateRequiredField,
//                         icon: Icons.accessibility,
//                       ),
//                       CustomTextRich(
//                         mainText: 'チームレベル',
//                         optionalText: '',
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       RatingBar.builder(
//                         initialRating:
//                             widget.isEditing ? post.level.toDouble() : 0.0,
//                         itemBuilder: (context, index) => const Icon(
//                           Icons.star,
//                           color: Colors.yellow,
//                         ),
//                         onRatingUpdate: (rating) {
//                           integerValue = rating.toInt();
//                         },
//                         itemCount: 3,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       CustomTextRich(
//                         mainText: '年齢層',
//                         optionalText: '(複数可)*',
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.white, width: 1.5),
//                           borderRadius: BorderRadius.circular(8.0), // 枠線の角の丸み
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Wrap(
//                             spacing: 4.0,
//                             runSpacing: 0.0,
//                             // children: ageFilterChips.toList(),
//                             children: FilterFunctions.getRecruitmentFilterChips(
//                               _ageFilters,
//                               ageChipItems,
//                               (updatedFilters) {
//                                 setState(() {
//                                   _ageFilters = updatedFilters;
//                                 });
//                               },
//                             ).toList(),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 19,
//                       ),
//                       //画像
//                       ImageInput(
//                         imageBytes: imageBytes,
//                         setImagePath: (path) {
//                           setState(() {
//                             imagePath = path;
//                           });
//                         },
//                         setImageBytes: (bytes) {
//                           setState(() {
//                             imageBytes = bytes;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 20.0),
//                       NoteCustomTextField(
//                         labelText: 'アピールポイント・連絡事項',
//                         controller: _noteController,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//   }
// }
