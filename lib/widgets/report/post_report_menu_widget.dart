import 'package:basketball_app/widgets/report/post_report_dialog.dart';
import 'package:flutter/material.dart';

import '../../../models/user_choice.dart';
import '../../models/account/account.dart';

class PostReportMenu extends StatelessWidget {
  final Account reportedUser; //報告されたユーザー（投稿者）

  final String reportedPostId; //報告されたユーザー（投稿者）

  const PostReportMenu(
      {required this.reportedUser, required this.reportedPostId, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Choice>(
      color: Colors.white,
      icon: const Icon(
        Icons.more_horiz,
        size: 25,
        color: Colors.white,
      ),
      elevation: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      onSelected: (Choice choice) async {
        if (choice.title == 'この投稿を報告する') {
          // 投稿報告処理
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (BuildContext context) {
              return PostReportDialog(
                reportedUser: reportedUser,
                reportedPostId: reportedPostId,
              );
            },
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return postBlock.map((Choice choice) {
          return PopupMenuItem<Choice>(
            value: choice,
            child: Row(
              children: [
                Icon(
                  choice.icon,
                  color: Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  choice.title,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
