import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

import '../dialogs/snackbar.dart';

class EmailSender {
  // 非同期のメール送信メソッド
  static Future<void> sendEmail({
    required BuildContext context,
    required String subject,
    required String body,
    required String to,
  }) async {
    try {
      // Cloud Functionsの呼び出し
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('sendEmail');
      await callable.call(<String, dynamic>{
        'to': to,
        'subject': subject,
        'text': body,
      });

      Navigator.of(context).pop();
      showSnackBar(
        context: context,
        text: '報告が完了しました',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
      showErrorSnackBar(context: context, text: "エラーが発生しました。もう一度やり直してください");
    }
  }
}
