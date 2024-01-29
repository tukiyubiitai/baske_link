import 'package:basketball_app/infrastructure/firebase/room_firebase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/talk/talkroom.dart';
import '../account/account_notifier.dart';

part 'talk_room_provider.g.dart';

@riverpod
class TalkRoomNotifier extends _$TalkRoomNotifier {
  @override
  Future<List<TalkRoom>?> build() async {
    try {
      String uid = ref.read(accountNotifierProvider).id;
      return RoomFirestore().fetchJoinedRooms(uid);
    } catch (e) {
      throw Exception('データの取得に失敗しました');
    }
  }

  // トークルームリストを更新する関数
  Future<void> refreshTalkRooms() async {
    // AsyncValueのloading状態を設定
    state = AsyncValue.loading();

    try {
      // トークルームのリストを再取得
      List<TalkRoom>? updatedRooms = await build();
      // 状態をAsyncValueのdata状態に更新
      state = AsyncValue.data(updatedRooms);
    } catch (e, stackTrace) {
      // エラーが発生した場合はAsyncValueのerror状態に更新
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
