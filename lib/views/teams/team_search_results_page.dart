import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers/team/team_search_notifier.dart';
import '../../widgets/common_widgets/back_button_widget.dart';
import '../../widgets/progress_indicator.dart';
import '../../widgets/teams/team_post_items.dart';

class TeamSearchResultsPage extends ConsumerWidget {
  final String? selectedLocation;
  final String? keywordLocation;

  const TeamSearchResultsPage({
    super.key,
    this.selectedLocation,
    this.keywordLocation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamResultsAsyncValue = ref
        .watch(TeamSearchNotifierProvider(selectedLocation, keywordLocation));

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
            child: teamResultsAsyncValue.when(
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
              data: (teamPostData) {
                if (teamPostData.posts.isEmpty) {
                  return const Center(
                    child: Text(
                      '投稿が見つかりませんでした',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: teamPostData.posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final post = teamPostData.posts[index];
                    final user = teamPostData.users[index];
                    return user != null
                        ? TeamPostItem(
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
