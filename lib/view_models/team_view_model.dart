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
import '../dialogs/snackbar_utils.dart';
import '../state/providers/account/account_notifier.dart';
import '../state/providers/account/account_state_notifier.dart';
import '../state/providers/global_loader.dart';
import '../state/providers/post/age_notifier.dart';
import '../state/providers/post/tag_area_notifier.dart';
import '../state/providers/post/target_notifier.dart';
import '../state/providers/team/my_team_post_provider.dart';
import '../state/providers/team/team_post_notifier.dart';
import '../state/providers/team/team_post_provider.dart';

class TeamPostViewModel extends ChangeNotifier {
  final FirebaseStorage storage = FirebaseStorage.instance;

  static final _firestoreInstance = FirebaseFirestore.instance;

  static final CollectionReference teamPosts =
      _firestoreInstance.collection("teamPosts");

  //投稿を保存する
  Future<bool> teamPostSubmit(WidgetRef ref) async {
    var teamState = ref.read(teamStateNotifierProvider);
    var ageState = ref.read(ageStateProvider);
    var targetState = ref.read(targetStateProvider);
    final tagProvider = ref.read(tagAreaStateProvider);
    final accountState = ref.read(accountStateNotifierProvider);

    String teamName = teamState.teamName;
    String activityTime = teamState.activityTime;
    String prefecture = teamState.prefecture;
    String teamAppeal = teamState.teamAppeal.toString();
    String goal = teamState.goal.toString();
    String cost = teamState.cost.toString();
    String note = teamState.note.toString();
    String? imagePath = teamState.imageUrl;
    String? headerImagePath = teamState.headerUrl;

    // 入力検証のロジック
    if (!isValidTeamState(ref)) {
      return false;
    }
    try {
      ref.read(globalLoaderProvider.notifier).setLoaderValue(true);

      final String? headerUrl =
          headerImagePath != null && headerImagePath.isNotEmpty
              ? await PostViewModel().uploadPostImage(headerImagePath, "")
              : null;

      final String? url = imagePath != null && imagePath.isNotEmpty
          ? await PostViewModel().uploadPostImage(imagePath, "")
          : null;

      TeamPost newPost = TeamPost(
        postAccountId: accountState.id,
        locationTagList: tagProvider,
        goal: goal,
        activityTime: activityTime,
        targetList: targetState,
        prefecture: prefecture,
        teamName: teamName,
        createdTime: Timestamp.now(),
        imageUrl: url,
        headerUrl: headerUrl,
        note: note,
        ageList: ageState,
        cost: cost,
        type: 'team',
        memberCount: "",
        teamAppeal: teamAppeal,
        prefectureAndLocation: [],
      );

      //保存処理
      var result = await TeamPostFirestore.teamAddPost(newPost);
      if (result == true) {
        //画面更新
        //timeLine更新
        await ref.read(teamPostNotifierProvider.notifier).reloadTeamPostData();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw getErrorMessage(e);
    } finally {
      //ロード終わり
      ref.read(globalLoaderProvider.notifier).setLoaderValue(false);
    }
  }

  // 投稿を更新する関数
  Future<bool> updateTeamPost(String postId, WidgetRef ref) async {
    var teamState = ref.read(teamStateNotifierProvider);
    var ageState = ref.read(ageStateProvider);
    var targetState = ref.read(targetStateProvider);
    final tagProvider = ref.read(tagAreaStateProvider);
    final accountState = ref.read(accountStateNotifierProvider);

    final myAccount = ref.read(accountNotifierProvider);

    //ローカルからデータを取ってくる
    // var _pref = await SharedPreferences.getInstance();
    String teamName = teamState.teamName;
    String activityTime = teamState.activityTime;
    String prefecture = teamState.prefecture;
    String teamAppeal = teamState.teamAppeal.toString();
    String goal = teamState.goal.toString();
    String cost = teamState.cost.toString();
    String note = teamState.note.toString();
    String? imagePath = teamState.imageUrl;
    String? headerImagePath = teamState.headerUrl;
    String? oldImagePath = teamState.oldImageUrl;
    String? oldHeaderImagePath = teamState.oldHeaderUrl;

    // 入力検証のロジック
    if (!isValidTeamState(ref)) {
      return false;
    }

    ref.read(globalLoaderProvider.notifier).setLoaderValue(true);

    try {
      final String? headerUrl = await PostViewModel()
          .uploadPostImage(headerImagePath, oldHeaderImagePath ?? '');

      // 通常の画像をアップロードしてURLを取得
      final String? url =
          await PostViewModel().uploadPostImage(imagePath, oldImagePath ?? '');

      TeamPost updatePost = TeamPost(
        postAccountId: accountState.id,
        locationTagList: tagProvider,
        goal: goal,
        activityTime: activityTime,
        targetList: targetState,
        prefecture: prefecture,
        teamName: teamName,
        createdTime: Timestamp.now(),
        imageUrl: url,
        headerUrl: headerUrl,
        note: note,
        ageList: ageState,
        cost: cost,
        type: 'team',
        memberCount: "",
        teamAppeal: teamAppeal,
        prefectureAndLocation: [],
      );

      // post更新処理
      var result =
          await TeamPostFirestore.updateTeamInDatabase(postId, updatePost);

      if (result == true) {
        //画面更新
        //timeLine更新
        await ref.read(teamPostNotifierProvider.notifier).reloadTeamPostData();
        //myPage更新
        await ref
            .read(myTeamPostNotifierProvider(myAccount).notifier)
            .reloadPosts(myAccount);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw getErrorMessage(e);
    } finally {
      //ロード終わり

      ref.read(globalLoaderProvider.notifier).setLoaderValue(false);
    }
  }

  //投稿削除する関数
  Future<bool> deleteTeamPost(TeamPost teamPost, WidgetRef ref) async {
    try {
      ref.read(globalLoaderProvider.notifier).setLoaderValue(true);

      final myAccount = ref.read(accountNotifierProvider);

      var result = await PostViewModel().deletePostsByPostId(
        teamPost.id,
        teamPost.postAccountId,
        teamPost.type,
        teamPost.imageUrl ?? "",
        teamPost.headerUrl ?? "",
      );

      if (result) {
        //画面更新

        //timeLine更新
        await ref.read(teamPostNotifierProvider.notifier).reloadTeamPostData();

        //myPage更新
        await ref
            .read(myTeamPostNotifierProvider(myAccount).notifier)
            .reloadPosts(myAccount);

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

  bool isValidTeamState(WidgetRef ref) {
    var teamState = ref.read(teamStateNotifierProvider);

    String teamName = teamState.teamName;
    String activityTime = teamState.activityTime;
    String locationTagString = teamState.locationTagString;
    String ageString = teamState.ageString;
    String targetString = teamState.targetString;
    String prefecture = teamState.prefecture;

    if (teamState.teamName.isEmpty || teamName.isEmpty) {
      showErrorSnackBar(context: ref.context, text: "チーム名が入力されていません");
      return false;
    }

    if (teamState.teamName.length < 2 || teamName.length < 2) {
      showErrorSnackBar(context: ref.context, text: "チーム名が短いです");
      return false;
    }
    if (teamState.locationTagString.isEmpty || locationTagString == []) {
      showErrorSnackBar(context: ref.context, text: "詳しい活動場所が入力されていません");
      return false;
    }

    // バリデーション: Emailまたはパスワードが空白の場合
    if (teamState.activityTime.isEmpty || activityTime.isEmpty) {
      showErrorSnackBar(context: ref.context, text: "活動時間が入力されていません");
      return false;
    }

    // バリデーション: Emailまたはパスワードが空白の場合
    if (teamState.ageString.isEmpty || ageString.isEmpty) {
      showErrorSnackBar(context: ref.context, text: "年齢層が選択されていません");
      return false;
    }

    if (teamState.targetString.isEmpty || targetString.isEmpty) {
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
    final currentPost = await loadPost(postId);
    if (currentPost != null) {
      return currentPost[0];
    }
    return null;
  }

  //画像の読み込み
  Future<Uint8List?> loadImage(TeamPost post) async {
    if (post.imageUrl != null) {
      final imageRef = storage.refFromURL(post.imageUrl.toString());
      return (await imageRef.getData());
    }
    return null;
  } //画像の読み込み

  Future<Uint8List?> loadHeaderRefImage(TeamPost post) async {
    if (post.headerUrl != null) {
      final headerRef = storage.refFromURL(post.headerUrl.toString());
      return (await headerRef.getData());
    }
    return null;
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

  //データ取得を知らせる
  Future<List<TeamPost>?> loadPost(String postId) async {
    final loadedPosts = await TeamPostFirestore().getTeamPostById(postId);
    if (loadedPosts != null && loadedPosts.isNotEmpty) {
      return loadedPosts;
    }

    return null;
  }

  Future<TeamPost?> checkMode(String? postId, bool isEditing) async {
    if (isEditing == false) {
      return null;
    }
    final currentPost = await loadPost(postId!);
    if (currentPost != null) {
      return currentPost[0];
    }
    return null;
  }
}
