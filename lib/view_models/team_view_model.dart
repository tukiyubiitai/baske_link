import 'dart:io';

import 'package:basketball_app/infrastructure/firebase/team_posts_firebase.dart';
import 'package:basketball_app/view_models/post_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/firebase/account_firebase.dart';
import '../../models/account/account.dart';
import '../../models/posts/team_model.dart';
import '../../utils/error_handler.dart';
import '../dialogs/snackbar.dart';
import '../infrastructure/image_processing/image_processing_utils.dart';
import '../state/providers/account/account_notifier.dart';
import '../state/providers/post/post_notifier.dart';
import '../state/providers/team/team_post_notifier.dart';

class TeamPostManager extends StateNotifier<TeamPost> {
  final FirebaseStorage storage = FirebaseStorage.instance;

  static final _firestoreInstance = FirebaseFirestore.instance;

  static final CollectionReference teamPosts =
      _firestoreInstance.collection("teamPosts");

  TeamPostManager()
      : super(TeamPost(
          postAccountId: "",
          prefecture: "",
          activityTime: "",
          teamName: "",
          createdTime: Timestamp.now(),
          locationTagList: [],
          targetList: [],
          ageList: [],
          type: "team",
        ));

  void onUserIdChange(String id) {
    state = state.copyWith(id: id);
  }

  void onPostAccountIdChange(String postAccountId) {
    state = state.copyWith(postAccountId: postAccountId);
  }

  void onTeamNameChange(String teamName) {
    state = state.copyWith(teamName: teamName);
  }

  void onActivityTimeChange(String activityTime) {
    state = state.copyWith(activityTime: activityTime);
  }

  void onPrefectureChange(String prefecture) {
    state = state.copyWith(prefecture: prefecture);
  }

  void onLocationTagStringChange(List<String> locationTagList) {
    state = state.copyWith(locationTagList: locationTagList);
  }

  void onTargetStringChange(List<String> targetList) {
    state = state.copyWith(targetList: targetList);
  }

  void onAgeStringChange(List<String> ageList) {
    state = state.copyWith(ageList: ageList);
  }

  void onTeamAppealChange(String teamAppeal) {
    state = state.copyWith(teamAppeal: teamAppeal);
  }

  void onCostChange(String cost) {
    state = state.copyWith(cost: cost);
  }

  void onGoalChange(String goal) {
    state = state.copyWith(goal: goal);
  }

  void onMemberCountChange(String memberCount) {
    state = state.copyWith(memberCount: memberCount);
  }

  void onImageChange(String imagePath) {
    state = state.copyWith(imagePath: imagePath);
  }

  void onHeaderUrlChange(String headerUrl) {
    state = state.copyWith(headerUrl: headerUrl);
  }

  void onNoteChange(String note) {
    state = state.copyWith(note: note);
  }

  void onTypeChange(String type) {
    state = state.copyWith(type: type);
  }

  void addOldImage(String oldImageUrl) {
    state = state.copyWith(oldImagePath: oldImageUrl);
  }

  void addOldHeaderImage(String oldHeaderUrl) {
    state = state.copyWith(oldHeaderImagePath: oldHeaderUrl);
  }

  //投稿を保存する
  Future<void> teamPostSubmit(WidgetRef ref) async {
    var teamState = state;
    var ageState = ref.read(ageStateProvider);
    var targetState = ref.read(targetStateProvider);
    final tagProvider = ref.read(tagAreaStateProvider);
    final myAccount = ref.read(accountNotifierProvider);

    String teamName = teamState.teamName;
    String activityTime = teamState.activityTime;
    String prefecture = teamState.prefecture;
    String teamAppeal = teamState.teamAppeal.toString();
    String goal = teamState.goal.toString();
    String cost = teamState.cost.toString();
    String note = teamState.note.toString();
    String? imagePath = teamState.imagePath;
    String? headerImagePath = teamState.headerUrl;

    // 入力検証のロジック
    if (!isValidTeamState(ref)) {
      return;
    }
    try {
      state = state.copyWith(isLoading: true); // 読み込み開始

      final String? headerUrl = headerImagePath.isNotEmpty
          ? await PostViewModel().uploadPostImage(headerImagePath, "")
          : "";

      final String? url = imagePath.isNotEmpty
          ? await PostViewModel().uploadPostImage(imagePath, "")
          : "";

      TeamPost newPost = TeamPost(
        postAccountId: myAccount.id,
        locationTagList: tagProvider,
        goal: goal,
        activityTime: activityTime,
        targetList: targetState,
        prefecture: prefecture,
        teamName: teamName,
        createdTime: Timestamp.now(),
        imagePath: url.toString(),
        headerUrl: headerUrl.toString(),
        note: note,
        ageList: ageState,
        cost: cost,
        type: 'team',
        memberCount: "",
        teamAppeal: teamAppeal,
      );

      //保存処理
      var result = await TeamPostFirestore.teamAddPost(newPost);
      if (result) {
        //timeLine更新
        await ref.read(teamPostNotifierProvider.notifier).reloadTeamPostData();
        state = state.copyWith(isTeamPostSuccessful: true);
        return;
      }
    } catch (e) {
      throw getErrorMessage(e);
    } finally {
      //ロード終わり
      state = state.copyWith(isLoading: false); // 読み込み開始
    }
  }

  // 投稿を更新する関数
  Future<void> updateTeamPost(String postId, WidgetRef ref) async {
    var teamState = state;
    var ageState = ref.read(ageStateProvider);
    var targetState = ref.read(targetStateProvider);
    final tagProvider = ref.read(tagAreaStateProvider);

    final myAccount = ref.read(accountNotifierProvider);

    String teamName = teamState.teamName;
    String activityTime = teamState.activityTime;
    String prefecture = teamState.prefecture;
    String teamAppeal = teamState.teamAppeal.toString();
    String goal = teamState.goal.toString();
    String cost = teamState.cost.toString();
    String note = teamState.note.toString();
    String? imagePath = teamState.imagePath;
    String? headerImagePath = teamState.headerUrl;
    String? oldImagePath = teamState.oldImagePath;
    String? oldHeaderImagePath = teamState.oldHeaderImagePath;

    // 入力検証のロジック
    if (!isValidTeamState(ref)) {
      return;
    }

    try {
      state = state.copyWith(isLoading: true); // 読み込み開始

      final String? headerUrl = await PostViewModel()
          .uploadPostImage(headerImagePath, oldHeaderImagePath);

      // 通常の画像をアップロードしてURLを取得
      final String? url =
          await PostViewModel().uploadPostImage(imagePath, oldImagePath);

      TeamPost updatePost = TeamPost(
        postAccountId: myAccount.id,
        locationTagList: tagProvider,
        goal: goal,
        activityTime: activityTime,
        targetList: targetState,
        prefecture: prefecture,
        teamName: teamName,
        createdTime: Timestamp.now(),
        imagePath: url.toString(),
        headerUrl: headerUrl.toString(),
        note: note,
        ageList: ageState,
        cost: cost,
        type: 'team',
        memberCount: "",
        teamAppeal: teamAppeal,
      );

      // post更新処理
      var result =
          await TeamPostFirestore.updateTeamInDatabase(postId, updatePost);

      if (result) {
        //画面更新
        //timeLine更新
        await ref.read(teamPostNotifierProvider.notifier).reloadTeamPostData();
        //myPage更新
        await ref
            .read(myTeamPostNotifierProvider(myAccount).notifier)
            .reloadPosts(myAccount);
        return;
      }
    } catch (e) {
      throw getErrorMessage(e);
    } finally {
      //ロード終わり
      state = state.copyWith(isLoading: false); // 読み込み終了
    }
  }

  //投稿削除する関数
  Future<void> deleteTeamPost(TeamPost teamPost, WidgetRef ref) async {
    try {
      state = state.copyWith(isLoading: true); // 読み込み開始

      final myAccount = ref.read(accountNotifierProvider);

      var result = await PostViewModel().deletePostsByPostId(
        teamPost.id,
        teamPost.postAccountId,
        teamPost.type,
        teamPost.imagePath,
        teamPost.headerUrl,
      );

      if (result) {
        //画面更新

        //timeLine更新
        await ref.read(teamPostNotifierProvider.notifier).reloadTeamPostData();

        //myPage更新
        await ref
            .read(myTeamPostNotifierProvider(myAccount).notifier)
            .reloadPosts(myAccount);

        return;
      }
    } catch (e) {
      throw getErrorMessage(e);
    } finally {
      state = state.copyWith(isLoading: false); // 読み込み終了
    }
  }

  bool isValidTeamState(WidgetRef ref) {
    var teamState = state;

    String teamName = teamState.teamName;
    String activityTime = teamState.activityTime;
    List<String> locationTagList = teamState.locationTagList;
    List<String> ageList = teamState.ageList;
    List<String> targetList = teamState.targetList;
    String prefecture = teamState.prefecture;

    if (teamState.teamName.isEmpty || teamName.isEmpty) {
      showErrorSnackBar(context: ref.context, text: "チーム名が入力されていません");
      return false;
    }

    if (teamState.teamName.length < 2 || teamName.length < 2) {
      showErrorSnackBar(context: ref.context, text: "チーム名が短いです");
      return false;
    }
    if (locationTagList == []) {
      showErrorSnackBar(context: ref.context, text: "詳しい活動場所が入力されていません");
      return false;
    }

    // バリデーション: Emailまたはパスワードが空白の場合
    if (teamState.activityTime.isEmpty || activityTime.isEmpty) {
      showErrorSnackBar(context: ref.context, text: "活動時間が入力されていません");
      return false;
    }

    // バリデーション: Emailまたはパスワードが空白の場合
    if (ageList.isEmpty) {
      showErrorSnackBar(context: ref.context, text: "年齢層が選択されていません");
      return false;
    }

    if (targetList.isEmpty) {
      showErrorSnackBar(context: ref.context, text: "募集内容が選択されていません");
      return false;
    }

    if (teamState.prefecture.isEmpty || prefecture.isEmpty) {
      showErrorSnackBar(context: ref.context, text: "エリアが入力されていません");
      return false;
    }
    return true;
  }

  //編集モードかどうか判断
  Future<TeamPost?> initSetData(String postId, bool isEditing) async {
    if (isEditing == false) {
      return null;
    }
    final currentPost = await TeamPostFirestore().getTeamPostById(postId);
    if (currentPost != null) {
      return currentPost[0];
    }
    return null;
  }

  //画像の読み込み
  Future<Uint8List?> loadImage(TeamPost post) async {
    final imageRef = storage.refFromURL(post.imagePath.toString());
    return (await imageRef.getData());
  } //画像の読み込み

  Future<Uint8List?> loadHeaderRefImage(TeamPost post) async {
    final headerRef = storage.refFromURL(post.headerUrl.toString());
    return (await headerRef.getData());
  }

  Future<List<TeamPost>?> getMyTeamPosts(Account myAccount) async {
    List<TeamPost>? MyTeamPostList = [];
    //あとで修正するかも
    final userPostSnapshot = await AccountFirestore.users
        .doc(myAccount.id)
        .collection("my_posts")
        .orderBy("created_time", descending: true)
        .get();

    List<String> myPostIds =
        List.generate(userPostSnapshot.docs.length, (index) {
      return userPostSnapshot.docs[index].id;
    });
    MyTeamPostList = await TeamPostFirestore().getMyTeamPostFromIds(myPostIds);
    return MyTeamPostList;
  }

  //teamPostを取得
  Future<TeamPostData> getTeamPosts() async {
    final query = teamPosts.orderBy("created_time", descending: true);
    TeamPostData teamPostData = await TeamPostFirestore().fetchTeamPosts(query);
    return teamPostData;
  }

  //teamPostのフィルタリング結果の情報を取得
  Future<TeamPostData> retrieveFilteredTeamPosts(
      String? selectedLocation, String? keywordLocation) async {
    // クエリを作成し、投稿を作成時間の降順に並べる
    Query query = teamPosts.orderBy('created_at', descending: true);

    // 両方の場所の条件が指定されている場合、その両方に基づいて絞り込む
    if (selectedLocation != null &&
        selectedLocation.isNotEmpty &&
        keywordLocation != null &&
        keywordLocation.isNotEmpty) {
      List<String> resultList = [keywordLocation, selectedLocation];
      query = teamPosts
          .where("prefecture", isEqualTo: selectedLocation)
          .where("locationTagList", arrayContainsAny: resultList);
    }
    // 都道府県のみが指定されている場合、その都道府県に基づいて絞り込む
    else if (selectedLocation != null && selectedLocation.isNotEmpty) {
      query = teamPosts.where("prefecture", isEqualTo: selectedLocation);
    }
    // キーワードのみが指定されている場合、そのキーワードに基づいて絞り込む
    else if (keywordLocation != null && keywordLocation.isNotEmpty) {
      query =
          teamPosts.where("locationTagList", arrayContains: keywordLocation);
    }
    return await TeamPostFirestore().fetchTeamPosts(query);
  }

  Future<TeamPost?> checkMode(String? postId, bool isEditing) async {
    if (isEditing == false) {
      return null;
    }
    final currentPost =
        await TeamPostFirestore().getTeamPostById(postId as String);
    if (currentPost != null) {
      return currentPost[0];
    }
    return null;
  }

  Future<File?> handleHeaderImageTap() async {
    try {
      state = state.copyWith(isLoading: true);
      var result = await cropHeaderImage();
      if (result != null) {
        // 選択した画像をFileオブジェクトに変換
        state = state.copyWith(headerUrl: result.path);
        state = state.copyWith(oldHeaderImagePath: "");
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

  Future<File?> handleImageTap() async {
    try {
      state = state.copyWith(isLoading: true);
      var result = await cropImage();
      if (result != null) {
        // 選択した画像をFileオブジェクトに変換
        state = state.copyWith(imagePath: result.path);
        state = state.copyWith(oldImagePath: "");
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
