import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers/games/game_post_provider.dart';
import '../../widgets/error/reload_widget.dart';
import '../../widgets/games/game_post_item.dart';
import '../../widgets/modal_sheet.dart';
import '../../widgets/progress_indicator.dart';

class GameRecruitmentPage extends ConsumerWidget {
  const GameRecruitmentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(gameRepositoryProvider);
    final gamePostDataAsyncValue = ref.watch(gamePostNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.indigo[900],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          showModalBottomSheet<String>(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return StatefulBuilder(
                  builder: (BuildContext context, Function setSheetState) {
                return ModalBottomSheetContent(
                  type: 'game',
                );
              });
            },
          );
        },
        child: const Icon(
          Icons.manage_search,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: gamePostDataAsyncValue.when(
              loading: () => const ShowProgressIndicator(
                textColor: Colors.white,
                indicatorColor: Colors.white,
              ),
              error: (e, stack) => ReloadWidget(
                  onPressed: () => ref
                      .read(gamePostNotifierProvider.notifier)
                      .reloadGamePostData(),
                  text: "投稿の読み込みに失敗しました"),
              data: (gamePostData) {
                if (gamePostData.posts.isEmpty) {
                  return const Center(
                    child: Text(
                      '投稿がありません',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: gamePostData.posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final post = gamePostData.posts[index];
                    final user = gamePostData.users[post.postAccountId];
                    print(gamePostData.posts[0].imagePath);

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
