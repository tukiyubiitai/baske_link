import 'dart:io';

import 'package:basketball_app/state/providers/providers.dart';
import 'package:basketball_app/view_models/game_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bottom_navigation.dart';
import '../../dialogs/snackbar.dart';
import '../../models/posts/chip_Item.dart';
import '../../models/posts/game_model.dart';
import '../../state/providers/post/age_notifier.dart';
import '../../state/providers/post/tag_area_notifier.dart';
import '../../utils/filter_functions.dart';
import '../../widgets/area_dropdown_menu_widget.dart';
import '../../widgets/common_widgets/back_button_widget.dart';
import '../../widgets/post/image_widget.dart';
import '../../widgets/posts_custom_text_fields.dart';
import '../../widgets/progress_indicator.dart';
import '../../widgets/tag_chips_field.dart';

class GamePostPage extends ConsumerStatefulWidget {
  final bool isEditing; // 編集モードかどうかを示すフラグ
  final String? postId; // 編集する投稿のID（編集モードの場合）

  const GamePostPage({required this.isEditing, this.postId, super.key});

  @override
  ConsumerState<GamePostPage> createState() => _GamePostPage1State();
}

class _GamePostPage1State extends ConsumerState<GamePostPage> {
  final TextEditingController _teamController = TextEditingController();
  final TextEditingController _memberController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  int? integerValue;
  File? image;
  String? imageUrl;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    _teamController.dispose();
    _memberController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  //テキストフィールドの設定
  void _setTextFieldValues(GamePost post) {
    _teamController.text = post.teamName;
    _memberController.text = post.member;
    _noteController.text = post.note;
  }

  void _setStateProviders() {
    ref.read(gamePostManagerProvider.notifier)
      ..addTeamName(_teamController.text)
      ..addMember(_memberController.text)
      ..addNote(_noteController.text);
  }

  // 投稿データをRiverpodの状態管理に反映
  void _updateStateProviders(GamePost post) {
    ref.read(gamePostManagerProvider.notifier)
      ..addTeamName(post.teamName)
      ..addMember(post.member.toString())
      ..addNote(post.note.toString())
      ..addPrefecture(post.prefecture)
      ..addLocationTagString(post.locationTagList)
      ..addAgeList(post.ageList)
      ..addLevel(post.level)
      ..addOldImage(post.imagePath);
    ref
        .read(tagAreaStateProvider.notifier)
        .addTag(post.locationTagList.join(","));
    ref.read(ageStateProvider.notifier).updateSelectedValue(post.ageList);
  }

  // 編集モードであれば、既存の投稿データをUIに反映
  Future<void> _initData() async {
    try {
      if (widget.postId != null) {
        final post = await GamePostManager()
            .initSetData(widget.postId!, widget.isEditing);
        if (post != null) {
          _updateStateProviders(post);
          _setTextFieldValues(post);
          imageUrl = post.imagePath;
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    // 現在のゲーム投稿状態を監視
    final gamePostState = ref.watch(gamePostManagerProvider);
    final ageProvider = ref.watch(ageStateProvider);

    // アカウント作成成功後の画面遷移
    ref.listen<GamePost>(gamePostManagerProvider, (_, state) {
      // isAccountCreatedSuccessfullyがtrueに変わった場合にのみ実行
      if (state.isGamePostSuccessful) {
        //画面遷移
        _handleGamePostCreation(state);
      }
    });

    final focusNode = FocusNode();
    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: gamePostState.isLoading == false
            ? Scaffold(
                backgroundColor: Colors.indigo[900],
                appBar: AppBar(
                  leading: backButton(context),
                  backgroundColor: Colors.indigo[900],
                  title: Text(
                    "練習試合募集",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    TextButton(
                      // 投稿処理または更新処理
                      onPressed: () async => _handlePostSubmission,
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
                            //画像追加
                            HeaderImageWidget(
                              imageUrl: imageUrl,
                              image: image,
                              onTap: ref
                                  .read(gamePostManagerProvider.notifier)
                                  .handleHeaderImageTap,
                            ),
                            //エリア
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                              ),
                              child: AreaDropdownMenuWidget(
                                color: Colors.orange,
                                type: 'game',
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
                              RequiredCustomTextFieldNoFunc(
                                controller: _teamController,
                                labelText: 'チーム名',
                                hintText: 'チーム名を入力してください',
                                prefixIcon: Icons.diversity_3,
                                maxLength: 15,
                              ),
                              // 詳しい場所のタグ
                              TagChipsField(
                                color: Colors.indigo,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomTextFieldNoFunc(
                                labelText: 'チームの構成メンバー',
                                hintText: '構成メンバーを入力してください',
                                prefixIcon: Icons.tour,
                                maxLength: 25,
                                controller: _memberController,
                              ),
                              CustomTextRich(
                                mainText: 'チームの年齢層',
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
                                //年齢層
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    spacing: 4.0,
                                    runSpacing: 0.0,
                                    children: FilterFunctions
                                        .getRecruitmentFilterChips(
                                      ageProvider,
                                      ageChipItems,
                                      Colors.indigo,
                                      Colors.white,
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
                                mainText: 'チームのレベルを選択',
                                optionalText: '',
                              ),
                              RatingBar.builder(
                                initialRating: widget.isEditing
                                    ? ref
                                        .read(gamePostManagerProvider)
                                        .level
                                        .toDouble()
                                    : 0.0,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.indigo,
                                ),
                                onRatingUpdate: (rating) {
                                  integerValue =
                                      rating.toInt(); // ratingをintに変換
                                  ref
                                      .read(gamePostManagerProvider.notifier)
                                      .addLevel(integerValue!);
                                },
                                itemCount: 3,
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFieldNoFunc(
                                labelText: "自由欄",
                                prefixIcon: Icons.sports_basketball_outlined,
                                hintText: '自由欄です',
                                controller: _noteController,
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
                )),
      ),
    );
  } // 投稿の保存または更新を行うメソッド

  Future<void> _handlePostSubmission() async {
    final ageProvider = ref.read(ageStateProvider);
    final areaTagProvider = ref.read(tagAreaStateProvider);
    _setStateProviders(); // 状態管理プロバイダーに現在のフォーム値を設定
    ref
        .read(gamePostManagerProvider.notifier)
        .addLocationTagString(areaTagProvider);
    ref.read(gamePostManagerProvider.notifier).addAgeList(ageProvider);

    if (!widget.isEditing) {
      // 新規投稿の保存処理
      await ref.read(gamePostManagerProvider.notifier).gamePostSubmit(ref);
    } else {
      // 既存投稿の更新処理
      await ref
          .read(gamePostManagerProvider.notifier)
          .updateGamePost(widget.postId!, ref);
    }
  }

  // 投稿完了後の処理
  void _handleGamePostCreation(GamePost state) {
    if (state.isGamePostSuccessful) {
      state = state.copyWith(isGamePostSuccessful: false);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => BottomTabNavigator(initialIndex: 3),
        ),
        (route) => false,
      );
      showSnackBar(
        context: context,
        text: "投稿が完了しました！",
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    } else {
      return;
    }
  }
}
