import 'package:flutter/material.dart';

import '../../models/account/account.dart';
import '../../models/report_reason.dart';
import '../utils/email_sender.dart';
import '../widgets/report/report_dialog_widgets.dart';

class UserReportDialog extends StatefulWidget {
  final Account reportedUser; //報告されたユーザー（投稿者）

  final Account myAccount; //報告するユーザー（報告者）

  const UserReportDialog(
      {required this.reportedUser, required this.myAccount, super.key});

  @override
  State<UserReportDialog> createState() => _UserReportDialogState();
}

class _UserReportDialogState extends State<UserReportDialog> {
  UserReportReason currentReport = UserReportReason.irrelevantPost;

  TextEditingController _otherReasonController = TextEditingController();

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
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
              buildReportListTile<UserReportReason>(
                reason: UserReportReason.irrelevantPost,
                currentReason: currentReport,
                onChanged: (value) => setState(() => currentReport = value!),
                reasonToString: userReportReasonToString,
              ),
              buildReportListTile<UserReportReason>(
                reason: UserReportReason.abuseThreat,
                currentReason: currentReport,
                onChanged: (value) => setState(() => currentReport = value!),
                reasonToString: userReportReasonToString,
              ),
              buildReportListTile<UserReportReason>(
                reason: UserReportReason.harassment,
                currentReason: currentReport,
                onChanged: (value) => setState(() => currentReport = value!),
                reasonToString: userReportReasonToString,
              ),
              buildReportListTile<UserReportReason>(
                reason: UserReportReason.spam,
                currentReason: currentReport,
                onChanged: (value) => setState(() => currentReport = value!),
                reasonToString: userReportReasonToString,
              ),
              buildReportListTile<UserReportReason>(
                reason: UserReportReason.sexualContent,
                currentReason: currentReport,
                onChanged: (value) => setState(() => currentReport = value!),
                reasonToString: userReportReasonToString,
              ),
              buildOtherReasonField(_otherReasonController),
              SizedBox(height: 20),
              buildReportButton(
                  context: context,
                  buttonText: "報告する",
                  buttonColor: Colors.red,
                  // onPressed: () async => await _sendEmail(currentReport),
                  //メール送信処理
                  onPressed: () async {
                    EmailSender.sendEmail(
                      context: context,
                      subject: '報告: ${userReportReasonToString(currentReport)}',
                      body: '報告者のID: ${widget.myAccount.id}\n' +
                          '報告者の名前: ${widget.myAccount.name}\n' +
                          '報告するユーザーのID: ${widget.reportedUser.id}\n' +
                          '報告するユーザーの名前: ${widget.reportedUser.name}\n' +
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
