import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dialogs/custom_dialogs.dart';
import '../../models/account/account.dart';
import '../../state/providers/account/account_notifier.dart';
import '../../state/providers/chat/talk_room_provider.dart';
import '../../view_models/talk_room_view_model.dart';
import '../../widgets/chat/talk_room_list_tile.dart';
import '../../widgets/chat/talk_room_slidable.dart';
import '../../widgets/progress_indicator.dart';

//トークルームリストを表示させます
class TalkRoomList extends ConsumerWidget {
  const TalkRoomList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talkRoomsAsyncValue = ref.watch(talkRoomNotifierProvider);
    final Account myAccount = ref.read(accountNotifierProvider); // 現在のユーザーを取得

    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        actions: [
          //非表示のトークルームを表示させる
          IconButton(
              color: Colors.white,
              onPressed: () async => await loadHiddenRooms(ref, myAccount.id),
              icon: const Icon(Icons.autorenew))
        ],
        title: Text(
          'talk',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo[900],
      ),
      body: talkRoomsAsyncValue.when(
        loading: () => ShowProgressIndicator(
          textColor: Colors.black,
          indicatorColor: Colors.indigo,
        ),
        error: (e, stack) => Center(
          child: Text(
            '予期せぬエラーが発生しました\nアプリを再起動させて下さい',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        data: (rooms) {
          if (rooms == null || rooms.isEmpty) {
            //トークルームがない時の画像
            return noTalkImage();
          }
          // チャットルームのリストを表示
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              //Slidableで削除や非表示
              return TalkRoomSlidable(
                roomId: room.roomId.toString(),
                myAccountId: myAccount.id,
                //トークルームリスト
                child: TalkRoomListTile(
                  talkRoom: room,
                  myUid: myAccount.id,
                ),
              );
            },
          );
        },
      ),
    );
  }

  // 非表示のトークルームを読み込む処理
  Future<void> loadHiddenRooms(WidgetRef ref, String userId) async {
    showDialog(
      context: ref.context,
      builder: (context) {
        return CustomAlertDialog(
          title: "ルームの読み込み",
          message: "非表示のルームを読み込みます",
          confirmButtonText: "読み込む",
          onCancel: () {
            Navigator.of(context).pop(); // ダイアログを閉じる
          },
          onConfirm: () async {
            await TalkRoomViewModel().hiddenForUser(userId, ref);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  //トークルームが存在しない時の画像
  Widget noTalkImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            'assets/images/talk.png',
            height: 250,
          ),
        ),
        const Text(
          "トークをはじめよう！",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "投稿からトークを開始できます",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
