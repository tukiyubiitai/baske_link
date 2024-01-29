import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/account/account.dart';
import '../../../models/posts/game_model.dart';
import '../../../state/providers/account/account_notifier.dart';
import '../../../widgets/common_widgets/back_button_widget.dart';
import '../../../widgets/post_action.dart';
import '../../../widgets/report/post_report_menu_widget.dart';
import 'game_postdetail_items.dart';

class GamePostDetailPage extends ConsumerWidget {
  final GamePost postData;
  final Account userData;

  const GamePostDetailPage({
    Key? key,
    required this.postData,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "詳細ページ",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          backgroundColor: Colors.indigo[900],
          leading: backButton(context),
          actions: [
            postData.postAccountId == ref.read(accountNotifierProvider).id
                ? PostAction(
                    gamePostData: postData,
                    isFromDetailPage: true,
                  )
                : PostReportMenu(
                    reportedUser: userData,
                    reportedPostId: postData.id,
                  )
          ],
        ),
        body: GamePostDetailItems(
          posts: postData,
          postId: postData.id,
          postAccountData: userData,
        ));
  }
}
