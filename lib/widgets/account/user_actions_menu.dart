import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/choice_model.dart';
import '../../../utils/error_handler.dart';
import '../../dialogs/dialogs.dart';
import '../../dialogs/snackbar_utils.dart';
import '../../view_models/account_view_model.dart';
import '../../views/auth/login_and_signup_page.dart';

// ユーザーのアクション（ログアウトやアカウント削除）を提供するメニューを表示するウィジェット
class UserActionsMenu extends ConsumerWidget {
  const UserActionsMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ポップアップメニューを表示
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
        // ユーザーが選択したアクションに応じた処理を実行
        if (choice.title == 'ログアウト') {
          // ログアウト確認ダイアログの表示
          await _showConfirmDialog(
            context: context,
            title: 'ログアウト',
            message: '本当にログアウトしますか？',
            onConfirm: () async {
              await signOut(ref);
            },
          );
        } else if (choice.title == 'アカウント削除') {
          // アカウント削除確認ダイアログの表示
          await _showConfirmDialog(
            context: context,
            title: 'アカウント削除',
            message: 'データは復元できませんがよろしいですか？\nアカウント削除のため再認証が行われます',
            onConfirm: () async =>
                //アカウント削除
                await deleteUser(ref),
          );
        }
      },
      itemBuilder: (BuildContext context) {
        // メニュー項目の作成
        return userChoices.map((Choice choice) {
          return PopupMenuItem<Choice>(
            value: choice,
            child: Row(
              children: [
                Icon(
                  choice.icon,
                  color: choice.title == 'ログアウト' ? Colors.black : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  choice.title,
                  style: TextStyle(
                    color: choice.title == 'ログアウト' ? Colors.black : Colors.red,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  // 確認ダイアログを表示するためのメソッド
  Future<void> _showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          message: message,
          confirmButtonText: title == 'ログアウト' ? "はい" : "削除",
          onCancel: () {
            Navigator.of(context).pop();
          },
          onConfirm: () {
            onConfirm();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  // 最初のページへのナビゲーションを行うためのメソッド
  void _navigateToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const FirstPage()),
      (route) => false,
    );
  }

  Future<void> deleteUser(WidgetRef ref) async {
    try {
      final result = await AccountViewModel().deleteUserAccount(ref);
      if (result) {
        showSnackBar(
            context: ref.context,
            text: "削除が完了しました",
            backgroundColor: Colors.white,
            textColor: Colors.black);
        _navigateToLogin(ref.context);
      }
    } catch (e) {
      Navigator.pop(ref.context);
      handleError(e, ref.context);
    }
  }

  //サインインページの前にもう一個新しい画面を追加する予定
  Future<void> signOut(WidgetRef ref) async {
    await FirebaseAuth.instance.signOut();
    _navigateToLogin(ref.context);
  }
}
