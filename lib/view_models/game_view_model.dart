import 'dart:io';

import 'package:basketball_app/infrastructure/firebase/game_posts_firebase.dart';
import 'package:basketball_app/view_models/post_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/firebase/account_firebase.dart';
import '../../models/account/account.dart';
import '../../models/posts/game_model.dart';
import '../dialogs/snackbar.dart';
import '../infrastructure/image_processing/image_processing_utils.dart';
import '../state/providers/account/account_notifier.dart';
import '../state/providers/games/game_post_provider.dart';
import '../state/providers/post/post_notifier.dart';
import '../utils/loading_manager.dart';
import '../utils/logger.dart';

class GamePostManager extends StateNotifier<GamePost> {
  static final _firestoreInstance = FirebaseFirestore.instance;

  GamePostManager()
      : super(GamePost(
            postAccountId: "",
            locationTagList: [],
            prefecture: "",
            level: 0,
            teamName: "",
            createdTime: Timestamp.now(),
            member: "",
            ageList: [],
            type: "game"));

  static final CollectionReference gamePosts =
      _firestoreInstance.collection('gamePosts');

  final FirebaseStorage storage = FirebaseStorage.instance;

  void addTeamName(String teamName) {
    state = state.copyWith(teamName: teamName);
  }

  void addPrefecture(String prefecture) {
    state = state.copyWith(prefecture: prefecture);
  }

  void addLocationTagString(List<String> locationTagString) {
    state = state.copyWith(locationTagList: locationTagString);
  }

  void addLevel(int level) {
    state = state.copyWith(level: level);
  }

  void addMember(String member) {
    state = state.copyWith(member: member);
  }

  void addAgeList(List<String> ageList) {
    state = state.copyWith(ageList: ageList);
  }

  void addNote(String note) {
    state = state.copyWith(note: note);
  }

  void addImage(String imageUrl) {
    state = state.copyWith(imagePath: imageUrl);
  }

  void addOldImage(String oldImageUrl) {
    state = state.copyWith(oldImagePath: oldImageUrl);
  }

  //gamePost保存
  Future<void> gamePostSubmit(WidgetRef ref) async {
    var gamePostState = state;
    var ageTag = ref.read(ageStateProvider);
    final locationTag = ref.read(tagAreaStateProvider);
    final Account myAccount = ref.read(accountNotifierProvider);

    String teamName = gamePostState.teamName;
    String prefecture = gamePostState.prefecture;
    String member = gamePostState.member;
    String note = gamePostState.note.toString();
    int level = gamePostState.level;

    String? imageUrl = gamePostState.imagePath;

    // 入力検証のロジック
    if (!isValidGameState(ref)) {
      return;
    }

    try {
      //ロード開始
      state = state.copyWith(isLoading: true); // 読み込み開始

      // 画像をアップロードしてURLを取得
      final String? url = imageUrl.isNotEmpty
          ? await PostViewModel().uploadPostImage(imageUrl, "")
          : "";

      GamePost newPost = GamePost(
        postAccountId: myAccount.id,
        locationTagList: locationTag,
        teamName: teamName,
        level: level,
        prefecture: prefecture,
        createdTime: Timestamp.now(),
        member: member,
        ageList: ageTag,
        type: 'game',
        imagePath: url.toString(),
        note: note,
      );

      //保存処理
      var result = await GamePostFirestore.gameAddPost(newPost);

      if (result) {
        //画面更新処理
        await ref.read(gamePostNotifierProvider.notifier).reloadGamePostData();
        state = state.copyWith(isGamePostSuccessful: true); // 投稿完了を知らせる
        return;
      }
    } catch (e) {
      AppLogger.instance.error("投稿失敗 $e");
    } finally {
      //終了
      state = state.copyWith(isLoading: false); //  ロード終了
    }
  }

  //gamePost更新
  Future<void> updateGamePost(String postId, WidgetRef ref) async {
    state = state.copyWith(isLoading: true); // 読み込み開始

    var gamePostState = state;
    var ageTag = ref.read(ageStateProvider);
    final locationTag = ref.read(tagAreaStateProvider);

    final myAccount = ref.read(accountNotifierProvider);

    String teamName = gamePostState.teamName;
    String prefecture = gamePostState.prefecture;
    String member = gamePostState.member;
    String note = gamePostState.note.toString();
    int level = gamePostState.level;

    String? imageUrl = gamePostState.imagePath;
    String oldImagePath = gamePostState.oldImagePath;
    // 入力検証のロジック
    if (!isValidGameState(ref)) {
      return;
    }

    try {
      //ロード開始

      // 画像をアップロードしてURLを取得
      final String? url =
          await PostViewModel().uploadPostImage(imageUrl, oldImagePath);

      GamePost updatePost = GamePost(
        postAccountId: myAccount.id,
        locationTagList: locationTag,
        teamName: teamName,
        level: level,
        prefecture: prefecture,
        createdTime: Timestamp.now(),
        member: member,
        ageList: ageTag,
        type: 'game',
        imagePath: url.toString(),
        note: note,
      );

      //更新処理
      var result =
          await GamePostFirestore.updateGameInDatabase(postId, updatePost);

      if (result) {
        //画面更新処理
        ref
            .read(myGamePostNotifierProvider(myAccount).notifier)
            .reloadPosts(myAccount);
        ref.read(gamePostNotifierProvider.notifier).reloadGamePostData();
        state = state.copyWith(isGamePostSuccessful: true); // 投稿完了を知らせる
        return;
      }
    } catch (e) {
      AppLogger.instance.error("投稿更新失敗 $e");
    } finally {
      //終了
      state = state.copyWith(isLoading: false); // 読み込み開始
    }
  }

  //投稿削除する関数
  Future<void> deleteGamePost(GamePost gamePost, WidgetRef ref) async {
    state = state.copyWith(isLoading: true); // 読み込み開始

    final myAccount = ref.read(accountNotifierProvider);

    try {
      // 削除処理
      var result = await PostViewModel().deletePostsByPostId(
        gamePost.id,
        gamePost.postAccountId,
        gamePost.type,
        gamePost.imagePath,
        "",
      );

      LoadingManager.instance.startLoading(ref);

      if (result) {
        //更新処理
        ref
            .read(myGamePostNotifierProvider(myAccount).notifier)
            .reloadPosts(myAccount);
        ref.read(gamePostNotifierProvider.notifier).reloadGamePostData();
        state = state.copyWith(isGamePostSuccessful: true); // 投稿完了を知らせる

        return;
      }
    } catch (e) {
      AppLogger.instance.error("投稿削除 $e");
    } finally {
      state = state.copyWith(isLoading: false); // 読み込み開始
    }
  }

  //入力チェック
  bool isValidGameState(WidgetRef ref) {
    var gamePostState = state;

    String teamName = gamePostState.teamName;
    List<String> ageString = gamePostState.ageList;
    String prefecture = gamePostState.prefecture;

    List<String> locationTagString = gamePostState.locationTagList;
    int level = gamePostState.level;

    if (gamePostState.teamName.isEmpty || teamName.isEmpty) {
      showErrorSnackBar(context: ref.context, text: "チーム名が入力されていません");
      return false;
    }

    if (gamePostState.teamName.length < 2 || teamName.length < 2) {
      showErrorSnackBar(context: ref.context, text: "チーム名が短いです");
      return false;
    }
    if (locationTagString == []) {
      showErrorSnackBar(context: ref.context, text: "詳しい活動場所が入力されていません");
      return false;
    }

    if (ageString.isEmpty) {
      showErrorSnackBar(context: ref.context, text: "年齢層が選択されていません");
      return false;
    }

    if (gamePostState.level == 0.0 || level == 0.0) {
      showErrorSnackBar(context: ref.context, text: "レベルが選択されていません");
      return false;
    }

    if (gamePostState.prefecture.isEmpty || prefecture.isEmpty) {
      showErrorSnackBar(context: ref.context, text: "エリアが入力されていません");
      return false;
    }
    return true;
  }

  //編集モードかどうか判断
  Future<GamePost?> initSetData(String postId, bool isEditing) async {
    if (isEditing == false) {
      return null;
    }
    final currentPost = await GamePostFirestore().getGamePostFromIds(postId);
    if (currentPost != null) {
      return currentPost[0];
    }
    return null;
  }

  //gamePost絞り込み
  Future<GamePostData> retrieveFilteredGamePosts(
    String? selectedLocation,
    String? keywordLocation,
  ) async {
    try {
      // クエリを作成し、投稿を作成時間の降順に並べる
      Query query = gamePosts.orderBy('created_at', descending: true);

      // 両方の場所の条件が指定されている場合、その両方に基づいて絞り込む
      if (selectedLocation != null &&
          selectedLocation.isNotEmpty &&
          keywordLocation != null &&
          keywordLocation.isNotEmpty) {
        List<String> resultList = [keywordLocation, selectedLocation];
        query = gamePosts
            .orderBy('created_at', descending: true)
            .where("prefecture", isEqualTo: selectedLocation)
            .where("locationTagList", arrayContainsAny: resultList);
      }
      // 都道府県のみが指定されている場合、その都道府県に基づいて絞り込む
      else if (selectedLocation != null && selectedLocation.isNotEmpty) {
        query = gamePosts
            .orderBy('created_at', descending: true)
            .where("prefecture", isEqualTo: selectedLocation);
      }
      // キーワードのみが指定されている場合、そのキーワードに基づいて絞り込む
      else if (keywordLocation != null && keywordLocation.isNotEmpty) {
        query = gamePosts
            .orderBy('created_at', descending: true)
            .where("locationTagList", arrayContains: keywordLocation);
      }
      return await GamePostFirestore().fetchGamePosts(query);
    } catch (e) {
      AppLogger.instance.error("gamePost絞り込みエラー $e");
      throw e;
    }
  }

  //自分のgamePostを読み込む
  Future<List<GamePost>?> getMyGamePosts(Account myAccount) async {
    List<GamePost>? gamePostList = [];
    final userPostSnapshot = await AccountFirestore.users
        .doc(myAccount.id)
        .collection("my_game_posts")
        .orderBy("created_time", descending: true)
        .get();

    try {
      List<String> myPostIds =
          List.generate(userPostSnapshot.docs.length, (index) {
        return userPostSnapshot.docs[index].id;
      });
      gamePostList = await GamePostFirestore().getMyGamePostFromIds(myPostIds);
      return gamePostList;
    } on FirebaseException catch (e) {
      AppLogger.instance.error("投稿取得エラー $e");
      throw e;
    }
  }

  Future<File?> handleHeaderImageTap() async {
    try {
      state = state.copyWith(isLoading: true);
      var result = await cropHeaderImage();
      if (result != null) {
        // 選択した画像をFileオブジェクトに変換
        state = state.copyWith(imagePath: result.path);
        return File(result.path);
        //新しい画像が追加されたら、元々の画像をnullにして、表示させる
        // imageUrl = null;
      }
    } catch (e) {
      // エラー処理
    } finally {
      // ローダーを非表示
      state = state.copyWith(isLoading: false);
    }
    return null;
  }
}
