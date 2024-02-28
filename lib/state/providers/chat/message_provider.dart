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

  Future<void> addMessage(Message message) async {
    _messages.insert(0, message); // リストの先頭にメッセージを追加
    state = await AsyncValue.guard(() => _loadMessage());
  }

  // メッセージ再読み込み
  Future<void> refreshMessages(TalkRoom talkRoom) async {
    // AsyncValueのloading状態を設定
    state = AsyncValue.loading();
    // トークルームのリストを再取得
    state = await AsyncValue.guard(() => _loadMessage());
  }
}
