import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_choice.dart';
import '../../bottom_navigation.dart';
import '../../dialogs/custom_dialogs.dart';
import '../../dialogs/snackbar.dart';
import '../../dialogs/user_report_dialog.dart';
import '../../infrastructure/firebase/account_firebase.dart';
import '../../models/account/account.dart';
import '../../state/providers/account/account_notifier.dart';
import '../../view_models/talk_room_view_model.dart';

class UserBlockAndReport extends ConsumerWidget {
  final Account talkUser;
  final String roomId;

  const UserBlockAndReport({
    Key? key,
    required this.talkUser,
    required this.roomId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAccount = ref.read(accountNotifierProvider);

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
        if (choice.title == 'このユーザーをブロックする') {
          // ブロック処理
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomAlertDialog(
                title: "${talkUser.name} をブロックしますか？",
                message: "このユーザーからメッセージが来ることはありません",
                confirmButtonText: "ブロックする",
                onCancel: () {
                  Navigator.of(context).pop();
                },
                onConfirm: () async {
                  await _blockUser(ref);
                },
              );
            },
          );
        } else if (choice.title == 'このユーザーを報告する') {
          // 報告処理
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (BuildContext context) {
              return UserReportDialog(
                reportedUser: talkUser,
                myAccount: myAccount,
              );
            },
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return userBlock.map((Choice choice) {
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

  Future<void> _blockUser(WidgetRef ref) async {
    final myAccount = ref.read(accountNotifierProvider);

    try {
      // ユーザーをブロックする処理
      await AccountFirestore().blockUser(myAccount.id, talkUser.id);
      //ブロックしたユーザーとのトークルームを削除
      final result = await TalkRoomViewModel().deleteRoom(roomId, ref);
      if (result) {
        Navigator.pushAndRemoveUntil(
          ref.context,
          MaterialPageRoute(
            builder: (context) => BottomTabNavigator(
              initialIndex: 1,
              userId: myAccount.id,
            ),
          ),
          (Route<dynamic> route) => false, // スタック内のすべてのルートを取り除く
        );
        showSnackBar(
          context: ref.context,
          text: 'ユーザーをブロックしました',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {}
  }
}
