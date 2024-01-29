import 'package:basketball_app/widgets/report/report_dialog_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/report_reason.dart';
import '../../../utils/email_sender.dart';
import '../../models/account/account.dart';
import '../../state/providers/account/account_state_notifier.dart';

class PostReportDialog extends ConsumerStatefulWidget {
  final Account reportedUser; //報告されたユーザー（投稿者）

  final String reportedPostId; //報告されたユーザー（投稿者）

  const PostReportDialog(
      {required this.reportedUser, required this.reportedPostId, super.key});

  @override
  ConsumerState<PostReportDialog> createState() => _PostReportDialogState();
}

class _PostReportDialogState extends ConsumerState<PostReportDialog> {
  PostReportReason currentReport = PostReportReason.irrelevantPost;

  TextEditingController _otherReasonController = TextEditingController();

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
    final accountState = ref.read(accountStateNotifierProvider);

    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpace),
      child: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 48),
                  Text(
                    'ユーザーを報告する',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 19,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              buildReportListTile<PostReportReason>(
                reason: PostReportReason.irrelevantPost,
                currentReason: currentReport,
                onChanged: (value) => setState(() => currentReport = value!),
                reasonToString: postReportReasonToString,
              ),
              buildReportListTile<PostReportReason>(
                reason: PostReportReason.abuseThreat,
                currentReason: currentReport,
                onChanged: (value) => setState(() => currentReport = value!),
                reasonToString: postReportReasonToString,
              ),
              buildReportListTile<PostReportReason>(
                reason: PostReportReason.harassment,
                currentReason: currentReport,
                onChanged: (value) => setState(() => currentReport = value!),
                reasonToString: postReportReasonToString,
              ),
              buildReportListTile<PostReportReason>(
                reason: PostReportReason.spam,
                currentReason: currentReport,
                onChanged: (value) => setState(() => currentReport = value!),
                reasonToString: postReportReasonToString,
              ),
              buildReportListTile<PostReportReason>(
                reason: PostReportReason.sexualContent,
                currentReason: currentReport,
                onChanged: (value) => setState(() => currentReport = value!),
                reasonToString: postReportReasonToString,
              ),
              buildOtherReasonField(_otherReasonController),
              SizedBox(height: 20),
              buildReportButton(
                  context: context,
                  buttonText: "報告する",
                  buttonColor: Colors.red,
                  // onPressed: () async => await _sendEmail(currentReport),
                  onPressed: () async {
                    //メール送信処理
                    EmailSender.sendEmail(
                      context: context,
                      subject: '報告: ${postReportReasonToString(currentReport)}',
                      body: '報告者のID: ${accountState.id}\n' +
                          '報告者の名前: ${accountState.name}\n' +
                          '報告するユーザーのID: ${widget.reportedUser.id}\n' +
                          '報告するユーザーの名前: ${widget.reportedUser.name}\n' +
                          '報告された投稿のId: ${widget.reportedPostId}\n' +
                          '詳細情報： ${_otherReasonController.text}',
                      to: 'syunsukebasket32@gmail.com',
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
