// import 'dart:typed_data';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../widgets/common_widgets/progress_dialog.dart';
// import '../../widgets/common_widgets/snackbar_utils.dart';
// import '../account/model/account.dart';
// import '../authentication/utils/authentication.dart';
// import 'data/chip_Item.dart';
// import 'model/area_provider.dart';
// import 'model/tag_provider.dart';
// import 'model/team_model.dart';
// import 'repository/posts_firebase.dart';
// import 'widgets/custom_text_field.dart';
// import 'widgets/filter_functions.dart';
// import 'widgets/post_image_widget.dart';
// import 'widgets/tag_chips_widget.dart';
//
// class TeamPostPage extends StatefulWidget {
//   final bool isEditing; //編集モード
//
//   final String? postId;
//
//   const TeamPostPage({super.key, required this.isEditing, this.postId});
//
//   @override
//   State<TeamPostPage> createState() => _TeamPostPageState();
// }
//
// class _TeamPostPageState extends State<TeamPostPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final FirebaseStorage storage = FirebaseStorage.instance;
//   bool _isLoading = false;
//
//   Uint8List? headerImageBytes;
//   String? headerImagePath; // ヘッダー画像のパスを保持
//
//   Uint8List? imageBytes;
//   String? imagePath;
//
//   late DatabaseReference dbRef;
//
//   final Account myAccount = Authentication.myAccount!;
//
//   // 必須項目コントローラー
//   final TextEditingController _activityTimeController = TextEditingController();
//   final TextEditingController _teamNameController = TextEditingController();
//
//   //非必須項目コントローラー
//   final TextEditingController _noteController = TextEditingController();
//   final TextEditingController _searchCriteriaController =
//       TextEditingController();
//   final TextEditingController _costController = TextEditingController();
//   final TextEditingController _goalController = TextEditingController();
//   final TextEditingController _numberController = TextEditingController();
//
//   //リスト
//   List<String> _ageFilters = [];
//   List<String> _targetFilters = [];
//
//   late TeamPost post; //投稿を編集する時に保存された情報が入ってくる
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
//   //投稿を編集する際に投稿を読み込む
//   Future<void> _loadPosts() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final loadedPosts =
//           await PostFirestore.getTeamPostById(widget.postId as String);
//       final tagModel = Provider.of<TagProvider>(context, listen: false);
//       final areaModel = Provider.of<AreaProvider>(context, listen: false);
//
//       if (loadedPosts != null && loadedPosts.isNotEmpty) {
//         post = loadedPosts[0]; // 最初の投稿を使用
//
//         _activityTimeController.text = post.activityTime;
//         _teamNameController.text = post.teamName;
//         _ageFilters = post.ageList;
//         _targetFilters = post.targetList;
//         _numberController.text = post.memberCount ?? "";
//         _goalController.text = post.goal ?? "";
//         _searchCriteriaController.text = post.searchCriteria ?? "";
//         _costController.text = post.cost ?? "";
//         _noteController.text = post.note ?? "";
//
//         for (String location in post.locationTagList) {
//           tagModel.addTag(location);
//         }
//
//         areaModel.setSelectedValue(post.prefecture);
//
//         if (post.imageUrl != null) {
//           final imageRef = storage.refFromURL(post.imageUrl as String);
//           imageBytes = (await imageRef.getData())!;
//         }
//
//         if (post.headerUrl != null) {
//           final headerRef = storage.refFromURL(post.headerUrl as String);
//           headerImageBytes = (await headerRef.getData())!;
//         }
//       }
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
//   void dispose() {
//     _activityTimeController.dispose();
//     _numberController.dispose();
//     _teamNameController.dispose();
//     _goalController.dispose();
//     _searchCriteriaController.dispose();
//     _costController.dispose();
//     _noteController.dispose();
//     super.dispose();
//   }
//
//   //投稿を更新する
//   Future<void> _updateRecruitment() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       final tagModel = Provider.of<TagProvider>(context, listen: false);
//       final areaModel = Provider.of<AreaProvider>(context, listen: false);
//       final String selectedValue = areaModel.selectedValue;
//       final List<String> tagStrings = tagModel.tagStrings;
//       if (!_isFormValid()) {
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
//       List<String> prefectureAndLocation = [...tagStrings, selectedValue];
//       String? headerUrl =
//           await PostFirestore.uploadImage(headerImagePath, post.headerUrl);
//       String? url = await PostFirestore.uploadImage(imagePath, post.imageUrl);
//       String id = post.id;
//       TeamPost updatePost = TeamPost(
//         postAccountId: myAccount.id,
//         locationTagList: tagStrings,
//         goal: _goalController.text,
//         activityTime: _activityTimeController.text,
//         memberCount: _numberController.text,
//         targetList: _targetFilters,
//         prefecture: selectedValue,
//         teamName: _teamNameController.text,
//         createdTime: Timestamp.now(),
//         imageUrl: url,
//         headerUrl: headerUrl,
//         note: _noteController.text,
//         searchCriteria: _searchCriteriaController.text,
//         ageList: _ageFilters,
//         cost: _costController.text,
//         prefectureAndLocation: prefectureAndLocation,
//         type: 'team',
//       );
//
//       bool result = await PostFirestore.updateTeamPost(id, updatePost);
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
//       showErrorSnackBar(context: context, text: 'エラーが発生しました。もう一度お試しください。');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   //firebaseに投稿を保存
//   Future<void> _submitRecruitment() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       final tagModel = Provider.of<TagProvider>(context, listen: false);
//       final areaModel = Provider.of<AreaProvider>(context, listen: false);
//       final String selectedValue = areaModel.selectedValue;
//       final List<String> tagStrings = tagModel.tagStrings;
//       if (!_isFormValid()) {
//         showErrorSnackBar(context: context, text: '必須項目が入力されていません');
//         _validateRequiredField('必須項目が入力されていません');
//         return;
//       }
//
//       if (tagStrings.isEmpty || selectedValue.isEmpty) {
//         if (tagStrings.isEmpty) {
//           tagModel.checkAndSetErrorBorder();
//           showErrorSnackBar(context: context, text: 'タグが追加が追加されていません');
//           return;
//         }
//         showErrorSnackBar(context: context, text: 'エリアが選択されていません');
//         return;
//       }
//       List<String> prefectureAndLocation = [...tagStrings, selectedValue];
//       // ヘッダー画像をアップロードしてURLを取得
//       final String? headerUrl =
//           await PostFirestore.uploadImage(headerImagePath, null);
//
//       // 通常の画像をアップロードしてURLを取得
//       final String? url = await PostFirestore.uploadImage(imagePath, null);
//
//       TeamPost newPost = TeamPost(
//         postAccountId: myAccount.id,
//         locationTagList: tagStrings,
//         goal: _goalController.text,
//         activityTime: _activityTimeController.text,
//         memberCount: _numberController.text,
//         targetList: _targetFilters,
//         prefecture: selectedValue,
//         teamName: _teamNameController.text,
//         createdTime: Timestamp.now(),
//         imageUrl: url,
//         headerUrl: headerUrl,
//         note: _noteController.text,
//         searchCriteria: _searchCriteriaController.text,
//         ageList: _ageFilters,
//         cost: _costController.text,
//         prefectureAndLocation: prefectureAndLocation,
//         type: 'team',
//       );
//
//       var result = await PostFirestore.teamAddPost(newPost);
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
//   bool _isFormValid() {
//     return _activityTimeController.text.isNotEmpty &&
//         _teamNameController.text.isNotEmpty &&
//         _ageFilters.isNotEmpty &&
//         _targetFilters.isNotEmpty;
//   }
//
//   //エラーメッセージ
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
//                     children: [
//                       RequiredCustomTextField(
//                         label: 'チーム名',
//                         hintText: 'チーム名を入力してください',
//                         controller: _teamNameController,
//                         validator: _validateRequiredField,
//                         icon: Icons.diversity_3,
//                       ),
//                       const SizedBox(height: 10.0),
//                       RequiredCustomTextField(
//                         label: '活動時間',
//                         hintText: '活動時間を入力してください',
//                         controller: _activityTimeController,
//                         validator: _validateRequiredField,
//                         icon: Icons.event,
//                       ),
//                       const SizedBox(height: 20.0),
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
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       //活動時間
//                       const Row(
//                         children: [
//                           Expanded(
//                             //場所と場所のタグを追加するwidget
//                             child: TgaChips(),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20.0),
//                       CustomTextField(
//                         controller: _goalController,
//                         labelText: "チーム目標",
//                         prefixIcon: Icons.tour,
//                         hintText: '',
//                       ),
//                       CustomTextField(
//                         controller: _searchCriteriaController,
//                         labelText: "こんな人を探しています",
//                         prefixIcon: Icons.account_circle,
//                         hintText: '',
//                       ),
//                       CustomTextField(
//                         controller: _numberController,
//                         labelText: "構成メンバー",
//                         prefixIcon: Icons.accessibility,
//                         maxLength: 20,
//                         hintText: '',
//                       ),
//                       CustomTextField(
//                         controller: _costController,
//                         labelText: "会費・参加費",
//                         prefixIcon: Icons.currency_yen,
//                         maxLength: 20,
//                         hintText: '',
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       CustomTextRich(
//                         mainText: '年齢層',
//                         optionalText: '(複数可)',
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
//                           padding: const EdgeInsets.all(8.0),
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
//                         height: 10,
//                       ),
//                       CustomTextRich(
//                         mainText: '募集内容',
//                         optionalText: '(複数可)',
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
//                           padding: const EdgeInsets.all(8.0),
//                           child: Wrap(
//                             spacing: 4.0,
//                             runSpacing: 0.0,
//                             children: FilterFunctions.getRecruitmentFilterChips(
//                               _targetFilters,
//                               targetChipItems,
//                               (updatedFilters) {
//                                 setState(() {
//                                   _targetFilters = updatedFilters;
//                                 });
//                               },
//                             ).toList(),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16.0),
//                       //ヘッダー画像
//                       HeaderImageInput(
//                         headerImageBytes: headerImageBytes,
//                         setImagePath: (path) {
//                           setState(() {
//                             headerImagePath = path;
//                           });
//                         },
//                         setImageBytes: (bytes) {
//                           setState(() {
//                             headerImageBytes = bytes;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 16.0),
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
//                       const SizedBox(height: 16.0),
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
