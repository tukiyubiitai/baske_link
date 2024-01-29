import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/account/account.dart';
import '../../../models/posts/team_model.dart';
import '../../../state/providers/account/account_notifier.dart';
import '../../../widgets/common_widgets/back_button_widget.dart';
import '../../../widgets/post_action.dart';
import '../../../widgets/report/post_report_menu_widget.dart';
import 'team_post_detail_items.dart';

class TeamPostDetailPage extends ConsumerWidget {
  final TeamPost postData;
  final Account userData;

  final String postId;

  const TeamPostDetailPage({
    Key? key,
    required this.postData,
    required this.userData,
    required this.postId,
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
                  teamPostData: postData,
                  isFromDetailPage: true,
                )
              : PostReportMenu(
                  reportedUser: userData,
                  reportedPostId: postData.id,
                )
        ],
      ),
      body: TeamPostDetailItem(
        postData: postData,
        userData: userData,
        postId: postId,
      ),
    );
  }
}
