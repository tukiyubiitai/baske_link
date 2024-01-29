import 'dart:typed_data';

import 'package:basketball_app/infrastructure/firebase/game_posts_firebase.dart';
import 'package:basketball_app/view_models/post_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/firebase/account_firebase.dart';
import '../../models/account/account.dart';
import '../../models/posts/game_model.dart';
import '../../utils/error_handler.dart';
import '../dialogs/snackbar_utils.dart';
import '../state/providers/account/account_notifier.dart';
import '../state/providers/games/game_post_notifier.dart';
import '../state/providers/games/game_post_provider.dart';
import '../state/providers/games/my_game_post_provider.dart';
import '../state/providers/global_loader.dart';
import '../state/providers/post/age_notifier.dart';
import '../state/providers/post/tag_area_notifier.dart';

class GamePostViewModel extends ChangeNotifier {
  static final _firestoreInstance = FirebaseFirestore.instance;

  static final CollectionReference gamePosts =
      _firestoreInstance.collection('gamePosts');

  final FirebaseStorage storage = FirebaseStorage.instance;

  //gamePost保存
  Future<bool> gamePostSubmit(WidgetRef ref) async {
    var gameState = ref.read(gameStateNotifierProvider);
    var ageState = ref.read(ageStateProvider);
    final tagProvider = ref.read(tagAreaStateProvider);

    final Account myAccount = ref.read(accountNotifierProvider);
    //ローカルからデータを取ってくる

    String teamName = gameState.teamName;

    String prefecture = gameState.prefecture;
    String member = gameState.member;
    String note = gameState.note.toString();
    int level = gameState.level;

    String? imageUrl = gameState.imageUrl;

    // 入力検証のロジック
    if (!isValidGameState(ref)) {
      return false;
    }

    try {
      //ロード開始
      ref.read(globalLoaderProvider.notifier).setLoaderValue(true);

      // 画像をアップロードしてURLを取得
      final String? url = imageUrl != null && imageUrl.isNotEmpty
          ? await PostViewModel().uploadPostImage(imageUrl, "")
          : null;

      GamePost newPost = GamePost(
        postAccountId: myAccount.id,
        locationTagList: tagProvider,
        teamName: teamName,
        level: level,
        prefecture: prefecture,
        createdTime: Timestamp.now(),
        member: member,
        ageList: ageState,
        type: 'game',
        imageUrl: url,
        note: note,
      );

      //保存処理
      var result = await GamePostFirestore.gameAddPost(newPost);

      if (result) {
        //画面更新処理
        await ref.read(gamePostNotifierProvider.notifier).reloadGamePostData();
        return true;
      }
      return false;
    } catch (e) {
      throw getErrorMessage(e);
    } finally {
      //終了
      ref.read(globalLoaderProvider.notifier).setLoaderValue(false);
    }
  }

  //gamePost更新
  Future<bool> updateGamePost(String postId, WidgetRef ref) async {
    var gameState = ref.read(gameStateNotifierProvider);
    var ageState = ref.read(ageStateProvider);
    final tagProvider = ref.read(tagAreaStateProvider);

    final myAccount = ref.read(accountNotifierProvider);

    String teamName = gameState.teamName;
    String prefecture = gameState.prefecture;
    String member = gameState.member;
    String note = gameState.note.toString();
    int level = gameState.level;

    String? imageUrl = gameState.imageUrl;
    String oldImagePath = gameState.oldImageUrl ?? '';
    // 入力検証のロジック
    if (!isValidGameState(ref)) {
      return false;
    }

    try {
      //ロード開始
      ref.read(globalLoaderProvider.notifier).setLoaderValue(true);

      // 画像をアップロードしてURLを取得
      final String? url =
          await PostViewModel().uploadPostImage(imageUrl, oldImagePath);

      GamePost updatePost = GamePost(
        postAccountId: myAccount.id,
        locationTagList: tagProvider,
        teamName: teamName,
        level: level,
        prefecture: prefecture,
        createdTime: Timestamp.now(),
        member: member,
        ageList: ageState,
        type: 'game',
        imageUrl: url,
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
        return true;
      }
      return false;
    } catch (e) {
      throw getErrorMessage(e);
    } finally {
      //終了
      ref.read(globalLoaderProvider.notifier).setLoaderValue(false);
    }
  }

  //投稿削除する関数
  Future<bool> deleteGamePost(GamePost gamePost, WidgetRef ref) async {
    ref.read(globalLoaderProvider.notifier).setLoaderValue(true);

    final myAccount = ref.read(accountNotifierProvider);

    try {
      // 削除処理
      var result = await PostViewModel().deletePostsByPostId(
        gamePost.id,
        gamePost.postAccountId,
        gamePost.type,
        gamePost.imageUrl ?? "",
        "",
      );

      ref.read(globalLoaderProvider.notifier).setLoaderValue(false);

      if (result) {
        //更新処理
        ref
            .read(myGamePostNotifierProvider(myAccount).notifier)
            .reloadPosts(myAccount);
        ref.read(gamePostNotifierProvider.notifier).reloadGamePostData();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw getErrorMessage(e);
    } finally {
      ref.read(globalLoaderProvider.notifier).setLoaderValue(false);
    }
  }

  //入力チェック
  bool isValidGameState(WidgetRef ref) {
    var gameState = ref.read(gameStateNotifierProvider);

    String teamName = gameState.teamName;
    String ageString = gameState.ageString;
    String prefecture = gameState.prefecture;

    String locationTagString = gameState.locationTagString;
    int level = gameState.level;

    if (gameState.teamName.isEmpty || teamName.isEmpty) {
      showErrorSnackBar(context: ref.context, text: "チーム名が入力されていません");
      return false;
    }

    if (gameState.teamName.length < 2 || teamName.length < 2) {
      showErrorSnackBar(context: ref.context, text: "チーム名が短いです");
      return false;
    }
    if (gameState.locationTagString.isEmpty || locationTagString == []) {
      showErrorSnackBar(context: ref.context, text: "詳しい活動場所が入力されていません");
      return false;
    }

    if (gameState.ageString.isEmpty || ageString.isEmpty) {
      showErrorSnackBar(context: ref.context, text: "年齢層が選択されていません");
      return false;
    }

    if (gameState.level == 0.0 || level == 0.0) {
      showErrorSnackBar(context: ref.context, text: "レベルが選択されていません");
      return false;
    }

    if (gameState.prefecture.isEmpty || prefecture.isEmpty) {
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
    final currentPost = await loadGamePost(postId);
    if (currentPost != null) {
      return currentPost[0];
    }
    return null;
  }

  //画像の読み込み
  Future<Uint8List?> loadImage(GamePost post) async {
    try {
      if (post.imageUrl != null) {
        final imageRef = storage.refFromURL(post.imageUrl.toString());
        return (await imageRef.getData());
      }
      return null;
    } catch (e) {
      throw getErrorMessage(e);
    }
  }

  //gamePostの読み込み完了を知らせる
  Future<List<GamePost>?> loadGamePost(String postId) async {
    try {
      final loadedPosts = await GamePostFirestore().getGamePostFromIds(postId);
      if (loadedPosts != null && loadedPosts.isNotEmpty) {
        return loadedPosts;
      }
    } catch (e) {
      print(getErrorMessage(e));
      throw getErrorMessage(e);
    }
    return null;
  }

  //gamePost絞り込み
  Future<GamePostData> retrieveFilteredGamePosts(
      String? selectedLocation, String? keywordLocation) async {
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
      print("gamePost絞り込み結果取得エラー");
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
      print("投稿取得エラー: $e");
      throw e;
    }
  }
}
