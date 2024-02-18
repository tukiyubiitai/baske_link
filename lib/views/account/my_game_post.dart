import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/posts/game_model.dart';
import '../../state/providers/account/account_notifier.dart';
import '../../state/providers/games/my_game_post_provider.dart';
import '../../widgets/post_action.dart';
import '../../widgets/progress_indicator.dart';
import '../games/details/game_post_detail.dart';

class MyGamePosts extends ConsumerWidget {
  const MyGamePosts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAccount = ref.watch(accountNotifierProvider);

    final MyGamePostAsyncValue =
        ref.watch(myGamePostNotifierProvider(myAccount));

    return MyGamePostAsyncValue.when(
      loading: () => ShowProgressIndicator(
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
      data: (myGamePosts) {
        if (myGamePosts == null || myGamePosts.isEmpty) {
          return Center(
              child: Text(
            '投稿がありません',
            style: TextStyle(color: Colors.white),
          ));
        }
        return ListView.builder(
          itemCount: myGamePosts.length,
          itemBuilder: (context, index) {
            GamePost post = myGamePosts[index];
            DateTime createAtDateTime = post.createdTime.toDate();
            String formattedCreatedAt =
                DateFormat('yyyy/MM/dd').format(createAtDateTime);

            Widget listItem = ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 8.0,
              ),
              trailing: PostAction(
                gamePostData: post,
                isFromDetailPage: false,
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: post.imageUrl != null && post.imageUrl != ""
                    ? NetworkImage(post.imageUrl.toString())
                    : const AssetImage('assets/images/headerImage.jpg')
                        as ImageProvider,
                radius: 30,
              ),
              title: Text(
                post.teamName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              subtitle: Text(
                formattedCreatedAt,
                style: const TextStyle(
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GamePostDetailPage(
                      postData: post,
                      userData: myAccount,
                    ),
                  ),
                );
              },
            );

            // 上部にボーダーを追加
            if (index != 0) {
              listItem = Column(
                children: [
                  const Divider(
                    color: Colors.grey,
                    height: 1.0,
                    thickness: 1.0,
                  ),
                  listItem,
                ],
              );
            }

            // 最後のアイテムで下部のボーダーも追加
            if (index == myGamePosts.length - 1) {
              listItem = Column(
                children: [
                  listItem,
                  const Divider(
                    color: Colors.grey,
                    height: 1.0,
                    thickness: 1.0,
                  ),
                ],
              );
            }

            return listItem;
          },
        );
      },
    );
  }
}
