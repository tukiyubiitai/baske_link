import 'dart:io';

import 'package:basketball_app/models/chip_Item.dart';
import 'package:basketball_app/utils/error_handler.dart';
import 'package:basketball_app/utils/filter_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/image_processing/image_processing_utils.dart';import '../../dialogs/snackbar_utils.dart';
import '../../models/posts/team_model.dart';
import '../../state/providers/global_loader.dart';
import '../../state/providers/post/age_notifier.dart';
import '../../state/providers/post/tag_area_notifier.dart';
import '../../state/providers/post/target_notifier.dart';
import '../../state/providers/team/team_post_notifier.dart';
import '../../view_models/post_view_model.dart';
import '../../view_models/team_view_model.dart';
import '../../widgets/area_dropdown_menu_widget.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/common_widgets/back_button_widget.dart';
import '../../widgets/post/image_widget.dart';
import '../../widgets/posts_custom_text_fields.dart';
import '../../widgets/progress_indicator.dart';
import '../../widgets/tag_chips_field.dart';

class TeamPostPage extends ConsumerStatefulWidget {
  final bool isEditing; //編集モード
  final String? postId; //編集する投稿のID

  const TeamPostPage({required this.isEditing, this.postId, super.key});

  @override
  ConsumerState<TeamPostPage> createState() => _TestPageState();
}

class _TestPageState extends ConsumerState<TeamPostPage> {
  final postViewModel = PostViewModel();

  late TeamPostViewModel _controller;

  final TextEditingController _teamController = TextEditingController();
  final TextEditingController _activityTimeController = TextEditingController();

  final TextEditingController _teamAppealController = TextEditingController();

  final TextEditingController _goalController = TextEditingController();

  final TextEditingController _costController = TextEditingController();

  final TextEditingController _noteController = TextEditingController();

  File? headerImage;
  File? image;

  String? headerUrl;
  String? imageUrl;

  late DatabaseReference dbRef;

  @override
  void initState() {
    dbRef = FirebaseDatabase.instance.ref().child('Recruitment');
    _controller = TeamPostViewModel();
    _initData();
    super.initState();
  }

  // 編集モード時に投稿データを読み込む
  Future<void> _initData() async {
    try {
      if (widget.postId != null) {
        //投稿データを読み込む
        final post =
            await _controller.initSetData(widget.postId!, widget.isEditing);
        if (post != null) {
          _updateStateProviders(post);
          _setTextFieldValues(post);
          headerUrl = post.headerUrl;
          imageUrl = post.imageUrl;
        }
      }
    } catch (e) {
      handleError(e, context);
    }
  }

  @override
  void dispose() {
    _teamController.dispose();
    _activityTimeController.dispose();
    _goalController.dispose();
    _costController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  //テキストフィールドの設定
  void _setTextFieldValues(TeamPost post) {
    _teamController.text = post.teamName;
    _activityTimeController.text = post.activityTime;
    _teamAppealController.text = post.teamAppeal ?? "";
    _goalController.text = post.goal ?? "";
    _costController.text = post.cost ?? "";
    _noteController.text = post.note ?? "";
  }

  //状態の更新
  void _updateStateProviders(TeamPost post) {
    ref.read(teamStateNotifierProvider.notifier)
      ..onTeamNameChange(post.teamName)
      ..onActivityTimeChange(post.activityTime)
      ..onTeamAppealChange(post.teamAppeal.toString())
      ..onGoalChange(post.goal.toString())
      ..onCostChange(post.cost.toString())
      ..onNoteChange(post.note.toString())
      ..onPrefectureChange(post.prefecture)
      ..onLocationTagStringChange(post.locationTagList.join(","))
      ..onAgeStringChange(post.ageList.join(","))
      ..onTargetStringChange(post.targetList.join(","))
      ..addOldImage(post.imageUrl)
      ..addOldHeaderImage(post.headerUrl);

    ref
        .read(tagAreaStateProvider.notifier)
        .addTag(post.locationTagList.join(","));
    ref.read(ageStateProvider.notifier).updateSelectedValue(post.ageList);
    ref.read(targetStateProvider.notifier).updateSelectedValue(post.targetList);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(teamStateNotifierProvider);
    final ageProvider = ref.watch(ageStateProvider);
    final targetProvider = ref.watch(targetStateProvider);
    final areaTagProvider = ref.watch(tagAreaStateProvider);

    final loader = ref.watch(globalLoaderProvider);
    final focusNode = FocusNode();

    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: loader == false
            ? Scaffold(
                backgroundColor: Colors.indigo[900],
                appBar: AppBar(
                  leading: backButton(context),
                  backgroundColor: Colors.indigo[900],
                  elevation: 0,
                  title: Text(
                    "チームメイト募集",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        if (widget.isEditing == false) {
                          ref
                              .read(teamStateNotifierProvider.notifier)
                              .onLocationTagStringChange(
                                  areaTagProvider.join(","));
                          ref
                              .read(teamStateNotifierProvider.notifier)
                              .onAgeStringChange(ageProvider.join(","));

                          ref
                              .read(teamStateNotifierProvider.notifier)
                              .onTargetStringChange(targetProvider.join(","));

                          await teamPostSubmit();
                        } else {
                          ref
                              .read(teamStateNotifierProvider.notifier)
                              .onLocationTagStringChange(
                                  areaTagProvider.join(","));
                          ref
                              .read(teamStateNotifierProvider.notifier)
                              .onAgeStringChange(ageProvider.join(","));

                          ref
                              .read(teamStateNotifierProvider.notifier)
                              .onTargetStringChange(targetProvider.join(","));

                          //投稿を更新処理
                          await teamPostUpdate(widget.postId as String);
                        }
                      },
                      child: Text(
                        widget.isEditing ? '更新' : '投稿',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ),
                body: SingleChildScrollView(
                  child: Container(
                    // margin: const EdgeInsets.all(10),
                    // padding: EdgeInsets.only(left: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            HeaderImageWidget(
                              imageUrl: headerUrl,
                              image: headerImage,
                              onTap: _handleHeaderImageTap,
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                              ),
                              child: AreaDropdownMenuWidget(
                                color: Colors.orange,
                                type: 'team',
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 190),
                              child: Row(
                                children: [
                                  CircleImageWidget(
                                      imageUrl: imageUrl,
                                      image: image,
                                      onTap: _handleImageTap),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              RequiredCustomTextField(
                                controller: _teamController,
                                labelText: 'チーム名',
                                hintText: 'チーム名を入力してください',
                                prefixIcon: Icons.diversity_3,
                                maxLength: 15,
                                func: (value) => ref
                                    .read(teamStateNotifierProvider.notifier)
                                    .onTeamNameChange(value),
                              ),
                              TagChipsField(
                                color: Colors.orange,
                              ),
                              RequiredCustomTextField(
                                controller: _activityTimeController,
                                labelText: '活動時間',
                                hintText: '活動時間を入力してください',
                                prefixIcon: Icons.event,
                                func: (value) => ref
                                    .read(teamStateNotifierProvider.notifier)
                                    .onActivityTimeChange(value),
                                maxLength: 15,
                              ),
                              CustomTextRich(
                                mainText: '年齢層',
                                optionalText: '(複数可)',
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white12, // 背景色をwhite12に設定
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  borderRadius:
                                      BorderRadius.circular(8.0), // 枠線の角の丸み
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    spacing: 4.0,
                                    runSpacing: 0.0,
                                    // children: ageFilterChips.toList(),
                                    children: FilterFunctions
                                        .getRecruitmentFilterChips(
                                      ageProvider,
                                      ageChipItems,
                                      Colors.orange,
                                      Colors.black,
                                      (updatedFilters) {
                                        ref
                                            .read(ageStateProvider.notifier)
                                            .updateSelectedValue(
                                                updatedFilters);
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomTextRich(
                                mainText: '対象者',
                                optionalText: '(複数可)',
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white12, // 背景色をwhite12に設定
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  borderRadius:
                                      BorderRadius.circular(8.0), // 枠線の角の丸み
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    spacing: 4.0,
                                    runSpacing: 0.0,
                                    children: FilterFunctions
                                        .getRecruitmentFilterChips(
                                      targetProvider,
                                      targetChipItems,
                                      Colors.orange,
                                      Colors.black,
                                      (updatedFilters) {
                                        ref
                                            .read(targetStateProvider.notifier)
                                            .updateSelectedValue(
                                                updatedFilters);
                                        setState(() {});
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextField(
                                labelText: "20文字チームアピール",
                                prefixIcon: Icons.accessibility,
                                maxLength: 20,
                                hintText: 'TimeLineに表示されます',
                                controller: _teamAppealController,
                                func: (value) => ref
                                    .read(teamStateNotifierProvider.notifier)
                                    .onTeamAppealChange(value),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                labelText: 'チーム目標',
                                hintText: 'チーム目標を入力してください',
                                prefixIcon: Icons.tour,
                                maxLength: 25,
                                controller: _goalController,
                                func: (value) => ref
                                    .read(teamStateNotifierProvider.notifier)
                                    .onGoalChange(value),
                              ),
                              CustomTextField(
                                labelText: "会費・参加費",
                                prefixIcon: Icons.currency_yen,
                                maxLength: 15,
                                hintText: '会費・参加費を入力してください',
                                controller: _costController,
                                func: (value) => ref
                                    .read(teamStateNotifierProvider.notifier)
                                    .onCostChange(value),
                              ),
                              CustomTextField(
                                labelText: "自由欄",
                                prefixIcon: Icons.sports_basketball_outlined,
                                hintText: 'アピールポイント・連絡事項',
                                controller: _noteController,
                                func: (value) => ref
                                    .read(teamStateNotifierProvider.notifier)
                                    .onNoteChange(value),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ))
            : Scaffold(
                backgroundColor: Colors.indigo[900],
                body: ShowProgressIndicator(
                  textColor: Colors.white,
                  indicatorColor: Colors.white,
                ),
              ),
      ),
    );
  }

  //ヘッダー追加処理
  Future<void> _handleHeaderImageTap() async {
    try {
      // ローダーを表示
      ref.read(globalLoaderProvider.notifier).setLoaderValue(true);

      // 画像を選択するためのロジック（たとえば、画像ピッカーを表示）
      var result = await cropHeaderImage();
      if (result != null) {
        // 選択した画像をFileオブジェクトに変換
        headerImage = File(result.path);
        // 画像のパスをコントローラに設定
        ref
            .read(teamStateNotifierProvider.notifier)
            .onHeaderUrlChange(headerImage!.path);
        //新しい画像が追加されたら、元々の画像をnullにして、表示させる
        headerUrl = null;
      }
    } catch (e) {
      // エラー処理
      showErrorSnackBar(context: context, text: 'エラーが発生しました: $e');
    } finally {
      // ローダーを非表示
      ref.read(globalLoaderProvider.notifier).setLoaderValue(false);
    }
  }

  //Circle画像追加
  Future<void> _handleImageTap() async {
    try {
      ref.read(globalLoaderProvider.notifier).setLoaderValue(true);
      var result = await cropImage();
      if (result != null) {
        image = File(result.path);
        print(image!.path);
        ref.read(teamStateNotifierProvider.notifier).onImageChange(image!.path);
        imageUrl = null;
      }
    } catch (e) {
      showErrorSnackBar(context: context, text: 'エラーが発生しました $e');
    } finally {
      ref.read(globalLoaderProvider.notifier).setLoaderValue(false);
    }
  }

  //保存
  Future<void> teamPostSubmit() async {
    try {
      final result = await _controller.teamPostSubmit(ref);
      if (result) {
        showSnackBar(
          context: ref.context,
          text: "投稿が完了しました！",
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
        Navigator.pushAndRemoveUntil(
          ref.context,
          MaterialPageRoute(
            builder: (context) => BottomTabNavigator(
              initialIndex: 0,
            ), // 登録されたユーザの情報を表示する画面
          ),
          (route) => false, // すべてのページを破棄するため、falseを返す
        );
      }
    } catch (e) {
      handleError(e, context);
    }
  }

  //更新
  Future<void> teamPostUpdate(String postId) async {
    try {
      final result = await _controller.updateTeamPost(postId, ref);

      if (result) {
        showSnackBar(
          context: ref.context,
          text: "更新が完了しました！",
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
        Navigator.pushAndRemoveUntil(
          ref.context,
          MaterialPageRoute(
            builder: (context) => BottomTabNavigator(
              initialIndex: 0,
            ), // 登録されたユーザの情報を表示する画面
          ),
          (route) => false, // すべてのページを破棄するため、falseを返す
        );
      }
    } catch (e) {
      handleError(e, context);
    }
  }
}
