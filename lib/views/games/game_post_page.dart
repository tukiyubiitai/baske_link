import 'dart:io';

import 'package:basketball_app/utils/error_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/image_processing/image_processing_utils.dart';
import '../../../models/chip_Item.dart';
import '../../../utils/filter_functions.dart';
import '../../dialogs/snackbar_utils.dart';
import '../../models/posts/game_model.dart';
import '../../state/providers/games/game_post_notifier.dart';
import '../../state/providers/global_loader.dart';
import '../../state/providers/post/age_notifier.dart';
import '../../state/providers/post/tag_area_notifier.dart';
import '../../view_models/game_view_model.dart';
import '../../view_models/post_view_model.dart';
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
  ConsumerState<GamePostPage> createState() => _NewGamePostPageState();
}

class _NewGamePostPageState extends ConsumerState<GamePostPage> {
  final postViewModel = PostViewModel();
  final TextEditingController _teamController = TextEditingController();
  final TextEditingController _memberController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final FirebaseStorage storage = FirebaseStorage.instance;
  late GamePostViewModel _controller;
  int? integerValue;
  File? image;
  String? imageUrl;

  @override
  void initState() {
    // コントローラーの初期化とデータの読み込み
    _controller = GamePostViewModel();
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

  //編集モードか判断
  Future<void> _initData() async {
    try {
      if (widget.postId != null) {
        final post =
            await _controller.initSetData(widget.postId!, widget.isEditing);
        if (post != null) {
          _updateStateProviders(post);
          _setTextFieldValues(post);
          imageUrl = post.imageUrl;
        }
      }
    } catch (e) {
      handleError(e, context);
    }
  }

  //テキストフィールドの設定
  void _setTextFieldValues(GamePost post) {
    _teamController.text = post.teamName;
    _memberController.text = post.member;
    _noteController.text = post.note ?? "";
  }

  //状態の設定
  void _updateStateProviders(GamePost post) {
    ref.read(gameStateNotifierProvider.notifier)
      ..onTeamNameChange(post.teamName)
      ..onMemberChange(post.member.toString())
      ..onNoteChange(post.note.toString())
      ..onPrefectureChange(post.prefecture)
      ..onLocationTagStringChange(post.locationTagList.join(","))
      ..onAgeListChange(post.ageList.join(","))
      ..onLevelChange(post.level)
      ..addOldImage(post.imageUrl);
    ref
        .read(tagAreaStateProvider.notifier)
        .addTag(post.locationTagList.join(","));
    ref.read(ageStateProvider.notifier).updateSelectedValue(post.ageList);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(gameStateNotifierProvider);
    final ageProvider = ref.watch(ageStateProvider);
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
                  title: Text(
                    "練習試合募集",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        if (widget.isEditing == false) {
                          //新規登録処理
                          ref
                              .read(gameStateNotifierProvider.notifier)
                              .onLocationTagStringChange(
                                  areaTagProvider.join(","));
                          ref
                              .read(gameStateNotifierProvider.notifier)
                              .onAgeListChange(ageProvider.join(","));

                          //保存処理
                          await gamePostSubmit();
                        } else {
                          //編集処理
                          ref
                              .read(gameStateNotifierProvider.notifier)
                              .onLocationTagStringChange(
                                  areaTagProvider.join(","));
                          ref
                              .read(gameStateNotifierProvider.notifier)
                              .onAgeListChange(ageProvider.join(","));

                          //更新処理
                          await gamePostUpdate(widget.postId as String);
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
                              onTap: handleHeaderImageTap,
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
                              RequiredCustomTextField(
                                controller: _teamController,
                                labelText: 'チーム名',
                                hintText: 'チーム名を入力してください',
                                prefixIcon: Icons.diversity_3,
                                maxLength: 15,
                                func: (value) => ref
                                    .read(gameStateNotifierProvider.notifier)
                                    .onTeamNameChange(value),
                              ),
                              // 詳しい場所のタグ
                              TagChipsField(
                                color: Colors.indigo,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                labelText: 'チームの構成メンバー',
                                hintText: '構成メンバーを入力してください',
                                prefixIcon: Icons.tour,
                                maxLength: 25,
                                controller: _memberController,
                                func: (value) => ref
                                    .read(gameStateNotifierProvider.notifier)
                                    .onMemberChange(value),
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
                                        .read(gameStateNotifierProvider)
                                        .level
                                        .toDouble()
                                    : 0.0,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.indigo,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                  integerValue = rating.toInt();
                                  ref
                                      .read(gameStateNotifierProvider.notifier)
                                      .onLevelChange(integerValue!);
                                },
                                itemCount: 3,
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                labelText: "自由欄",
                                prefixIcon: Icons.sports_basketball_outlined,
                                hintText: '自由欄です',
                                controller: _noteController,
                                func: (value) => ref
                                    .read(gameStateNotifierProvider.notifier)
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
                )),
      ),
    );
  }

  //画像追加処理
  Future<void> handleHeaderImageTap() async {
    try {
      // ローダーを表示
      ref.read(globalLoaderProvider.notifier).setLoaderValue(true);

      // 画像を選択するためのロジック（たとえば、画像ピッカーを表示）
      var result = await cropHeaderImage();
      if (result != null) {
        // 選択した画像をFileオブジェクトに変換
        image = File(result.path);
        // 画像のパスをコントローラに設定
        ref.read(gameStateNotifierProvider.notifier).onImageChange(image!.path);
        //新しい画像が追加されたら、元々の画像をnullにして、表示させる
        imageUrl = null;
      }
    } catch (e) {
      // エラー処理
      handleError(e, context);
    } finally {
      // ローダーを非表示
      ref.read(globalLoaderProvider.notifier).setLoaderValue(false);
    }
  }

  //保存
  Future<void> gamePostSubmit() async {
    try {
      final result = await _controller.gamePostSubmit(ref);
      if (result) {
        showSnackBar(
          context: ref.context,
          text: "投稿が完了しました！",
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
        Navigator.popUntil(ref.context, (route) => route.isFirst);
      }
    } catch (e) {
      handleError(e, context);
    }
  }

  //更新
  Future<void> gamePostUpdate(String postId) async {
    try {
      final result = await _controller.updateGamePost(postId, ref);
      if (result) {
        showSnackBar(
          context: ref.context,
          text: "更新が完了しました！",
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
        Navigator.popUntil(ref.context, (route) => route.isFirst);
      }
    } catch (e) {
      handleError(e, context);
    }
  }
}
