import 'package:basketball_app/state/providers/providers.dart';
import 'package:basketball_app/widgets/error/reload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers/team/team_post_notifier.dart';
import '../../widgets/modal_sheet.dart';
import '../../widgets/progress_indicator.dart';
import '../../widgets/teams/team_post_items.dart';

class TeamRecruitmentPage extends ConsumerWidget {
  const TeamRecruitmentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamPostDataAsyncValue = ref.watch(teamPostNotifierProvider);
    ref.watch(accountManagerProvider);

    return Scaffold(
      backgroundColor: Colors.indigo[900],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        onPressed: () {
          showModalBottomSheet<String>(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return StatefulBuilder(
                  builder: (BuildContext context, Function setSheetState) {
                return ModalBottomSheetContent(
                  type: 'team',
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
            child: teamPostDataAsyncValue.when(
              loading: () => const ShowProgressIndicator(
                textColor: Colors.white,
                indicatorColor: Colors.white,
              ),
              error: (e, stack) => ReloadWidget(
                  onPressed: () => ref
                      .read(teamPostNotifierProvider.notifier)
                      .reloadTeamPostData(),
                  text: "投稿の読み込みに失敗しました"), // 再読み込み
              data: (teamPostData) {
                if (teamPostData.posts.isEmpty) {
                  return const Center(
                    child: Text(
                      '投稿がありません',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: teamPostData.posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final post = teamPostData.posts[index];
                    final user = teamPostData.users[index];

                    return TeamPostItem(
                      postId: post.id,
                      postData: post,
                      userData: user,
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
