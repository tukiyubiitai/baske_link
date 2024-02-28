import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/account/account.dart';
import '../../../../models/talk/message.dart';
import '../../../../models/talk/talkroom.dart';
import '../../../view_models/message_view_model.dart';
import '../account/account_notifier.dart';

part 'message_provider.g.dart';

@riverpod
class MessageNotifier extends _$MessageNotifier {
  List<Message> _messages = [];

  @override
  Future<List<Message>> build(TalkRoom talkRoom) => _loadMessage();

  Future<List<Message>> _loadMessage() async {
    Account myAccount = ref.read(accountNotifierProvider);
    return await MessageViewModel().fetchRoomMessages(talkRoom, myAccount);
  }

  void addMessage(Message message) {
    _messages.insert(0, message); // リストの先頭にメッセージを追加
    state = AsyncValue.data(List.from(_messages)); // 状態を更新
  }

  // メッセージ再読み込み
  Future<void> refreshMessages(TalkRoom talkRoom) async {
    // AsyncValueのloading状態を設定
    state = AsyncValue.loading();

    try {
      // トークルームのリストを再取得
      state = await AsyncValue.guard(() => _loadMessage());

      List<Message>? updatedMessages = await build(talkRoom);
      // 状態をAsyncValueのdata状態に更新
      state = AsyncValue.data(updatedMessages);
    } catch (e, stackTrace) {
      // エラーが発生した場合はAsyncValueのerror状態に更新
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
