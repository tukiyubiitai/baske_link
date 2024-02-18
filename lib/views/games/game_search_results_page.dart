import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers/games/game_search_notifier.dart';
import '../../widgets/common_widgets/back_button_widget.dart';
import '../../widgets/games/game_post_item.dart';
import '../../widgets/progress_indicator.dart';

class GameSearchResultsPage extends ConsumerWidget {
  final String? selectedLocation;
  final String? keywordLocation;

  const GameSearchResultsPage({
    super.key,
    this.selectedLocation,
    this.keywordLocation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameResultsAsyncValue = ref
        .watch(GameSearchNotifierProvider(selectedLocation, keywordLocation));

    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: const Text(
          "絞り込み結果",
          style: TextStyle(color: Colors.white),
        ),
        leading: backButton(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: gameResultsAsyncValue.when(
              loading: () => const ShowProgressIndicator(
                textColor: Colors.white,
                indicatorColor: Colors.white,
              ),
              error: (e, stack) => Center(
                child: Text(
                  '予期せぬエラーが発生しました\nアプリを再起動させて下さい',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              data: (gamePostData) {
                if (gamePostData.posts.isEmpty) {
                  return const Center(
                    child: Text(
                      '投稿が見つかりませんでした',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: gamePostData.posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final post = gamePostData.posts[index];
                    final user = gamePostData.users[post.postAccountId];
                    return user != null
                        ? GamePostItem(
                            postId: post.id,
                            postData: post,
                            userData: user,
                          )
                        : const Center(
                            child: Text(
                              'ユーザー情報が見つかりません',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
