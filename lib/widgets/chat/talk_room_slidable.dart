import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../dialogs/custom_dialogs.dart';
import '../../dialogs/snackbar.dart';
import '../../state/providers/chat/chat_notifier.dart';
import '../../view_models/talk_room_view_model.dart';

class TalkRoomSlidable extends ConsumerWidget {
  final String roomId;
  final String myAccountId;
  final Widget child;

  const TalkRoomSlidable({
    Key? key,
    required this.roomId,
    required this.myAccountId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          // 非表示
          SlidableAction(
            onPressed: (_) => showHideRoomDialog(context, ref),
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            label: '非表示',
          ),
        ],
      ),
      child: child,
    );
  }

  void showHideRoomDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: "ルーム非表示",
          message: "トークの内容は消えません",
          confirmButtonText: "非表示",
          onCancel: () {
            Navigator.of(context).pop(); // ダイアログを閉じる
          },
          onConfirm: () async {
            await performRoomAction(
              context,
              ref,
              "非表示にしました",
              () => TalkRoomViewModel().hideTalkRoom(roomId, myAccountId),
            );
            Navigator.of(context).pop(); // ダイアログを閉じる
          },
        );
      },
    );
  }

  // 非表示処理、スナックバーを表示
  Future<void> performRoomAction(
    BuildContext context,
    WidgetRef ref,
    String successMessage,
    Future<void> Function() action,
  ) async {
    try {
      await action();
      showSnackBar(
        context: context,
        text: successMessage,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
      ref.read(talkRoomNotifierProvider.notifier).refreshTalkRooms();
    } catch (e) {
      showSnackBar(
        context: context,
        text: 'エラーが発生しました: $e',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
