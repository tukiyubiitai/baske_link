import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/talk/talkroom.dart';
import '../../models/account/account.dart';
import '../../state/providers/account/account_notifier.dart';
import '../../state/providers/chat/chat_notifier.dart';
import '../../view_models/message_view_model.dart';
import '../../widgets/chat/message_list_widget.dart';
import '../../widgets/common_widgets/back_button_widget.dart';
import '../../widgets/error/reload_widget.dart';
import '../../widgets/progress_indicator.dart';
import '../../widgets/report/user_block_and_report_menu.dart';

class TalkPage extends ConsumerStatefulWidget {
  final TalkRoom talkRoom;

  const TalkPage({required this.talkRoom, super.key});

  @override
  ConsumerState<TalkPage> createState() => _TalkPageState();
}

class _TalkPageState extends ConsumerState<TalkPage> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    //既読処理
    updateMessageReadStatus(ref.read(accountNotifierProvider).id);
  }

  //既読処理
  Future<void> updateMessageReadStatus(String myUid) async {
    //メッセージを未読から既読にする
    await MessageViewModel().checkAndUpdateMessageReadStatus(
      widget.talkRoom.roomId as String,
      myUid,
      widget.talkRoom.talkUser!.id,
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageAsyncValue =
        ref.watch(messageNotifierProvider(widget.talkRoom));

    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(
          widget.talkRoom.talkUser!.name,
          style: TextStyle(color: Colors.white),
        ),
        leading: backButton(context),
        actions: [
          //ユーザー報告とブロック
          UserBlockAndReport(
            talkUser: widget.talkRoom.talkUser as Account,
            roomId: widget.talkRoom.roomId as String,
          ),
        ],
      ),
      body: Stack(
        children: [
          messageAsyncValue.when(
            error: (e, stack) => ReloadWidget(
                onPressed: () => ref
                    .read(messageNotifierProvider(widget.talkRoom).notifier)
                    .refreshMessages(),
                text: "トークルームの読み込みに失敗しました"),
            loading: () => ShowProgressIndicator(
              textColor: Colors.white,
              indicatorColor: Colors.white,
            ),
            data: (messages) {
              if (messages.isEmpty) {
                return Center(
                    child: Text(
                  "メッセージがありません",
                  style: TextStyle(color: Colors.white),
                ));
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                //メッセージUI
                child: MessageListWidget(
                  messages: messages,
                  talkRoom: widget.talkRoom,
                ),
              );
            },
          ),
          //入力欄
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 60,
                      bottom: 10,
                    ),
                    //Widget
                    child: MessageInputWidget(
                      controller: controller,
                      onSubmitted: (String) async =>
                          //送信処理
                          await sendMessage(
                        controller.text,
                        controller,
                        ref,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //送信ボタン
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, bottom: 14),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: IconButton(
                  onPressed: () async {
                    final text = controller.text;
                    //送信処理
                    await sendMessage(text, controller, ref);
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //メッセージ送信処理
  Future<void> sendMessage(
      String text, TextEditingController controller, WidgetRef ref) async {
    if (text.isEmpty) return;
    try {
      //firestoreにmessageを保存処理
      await MessageViewModel().sendMessage(
        message: text,
        talkRoom: widget.talkRoom,
        ref: ref,
      );
      controller.clear();
    } catch (e) {
      // エラーハンドリングをここに追加
      print('メッセージの送信に失敗しました: $e');
    }
  }
}

//入力欄
class MessageInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const MessageInputWidget({
    Key? key,
    required this.controller,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: "Type a message!",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        contentPadding: const EdgeInsets.all(10),
      ),
      onSubmitted: (text) => onSubmitted(text), // 外部からのコールバックを使用
    );
  }
}
