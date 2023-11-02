import 'package:basketball_app/models/game_model.dart';
import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../../models/team_model.dart';
import '../../repository/posts_firebase.dart';
import '../../widgets/common_widgets/progress_dialog.dart';
import '../../widgets/post_widgets/detail_item_widget.dart';

class TeamPostDetailPage extends StatefulWidget {
  final String postId;

  final Account? postAccountData;

  const TeamPostDetailPage(
      {super.key, required this.postId, this.postAccountData});

  @override
  State<TeamPostDetailPage> createState() => _TeamPostDetailPageState();
}

class _TeamPostDetailPageState extends State<TeamPostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<TeamPost>?>(
        future: PostFirestore.getTeamPostById(widget.postId),
        // 投稿IDから詳細情報を取得する関数を呼び出す
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // データが読み込まれていない状態
            return Center(
              child: ShowProgressIndicator(), // ローディング中の表示
            );
          } else if (snapshot.hasError) {
            // エラーが発生した場合
            return Center(
              child: Text(
                "データの読み込み中にエラーが発生しました ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            // データが存在しない場合
            return const Center(
              child: Text(
                "該当する投稿が見つかりませんでした",
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            // 投稿の詳細情報が取得できた場合
            List<TeamPost> teamPosts = snapshot.data!;
            return TeamPostDetailItem(
              posts: teamPosts,
              postId: widget.postId,
              postAccountData: widget.postAccountData as Account,
            );
          }
        },
      ),
    );
  }
}

class GamePostDetailPage extends StatefulWidget {
  final String postId;
  final Account? postAccountData;

  const GamePostDetailPage(
      {super.key, required this.postId, required this.postAccountData});

  @override
  State<GamePostDetailPage> createState() => _GamePostDetailPageState();
}

class _GamePostDetailPageState extends State<GamePostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<GamePost>?>(
        future: PostFirestore.getGamePostFromIds(widget.postId),
        // 投稿IDから詳細情報を取得する関数を呼び出す
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // データが読み込まれていない状態
            return Center(
              child: ShowProgressIndicator(), // ローディング中の表示
            );
          } else if (snapshot.hasError) {
            // エラーが発生した場合
            return Center(
              child: Text(
                "データの読み込み中にエラーが発生しました ${snapshot.error}",
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            // データが存在しない場合
            return const Center(
              child: Text(
                "該当する投稿が見つかりませんでした",
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            // 投稿の詳細情報が取得できた場合
            List<GamePost> gamePosts = snapshot.data!;
            return GamePostDetailItem(
              posts: gamePosts,
              postId: widget.postId,
              postAccountData: widget.postAccountData as Account,
            );
          }
        },
      ),
    );
  }
}
