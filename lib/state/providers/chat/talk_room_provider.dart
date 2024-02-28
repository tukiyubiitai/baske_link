import 'package:basketball_app/infrastructure/firebase/room_firebase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/talk/talkroom.dart';
import '../account/account_notifier.dart';

part 'talk_room_provider.g.dart';

@riverpod
class TalkRoomNotifier extends _$TalkRoomNotifier {
  @override
  Future<List<TalkRoom>?> build() => _loadTalkRooms();

  Future<List<TalkRoom>?> _loadTalkRooms() async {
    try {
      String uid = ref.read(accountNotifierProvider).id;
      return await RoomFirestore().fetchJoinedRooms(uid);
    } catch (e) {
      throw Exception('データの取得に失敗しました');
    }
  }

  // トークルームリストを更新する関数
  Future<void> refreshTalkRooms() async {
    // AsyncValueのloading状態を設定
    state = AsyncValue.loading();


      // トークルームのリストを再取得
    state = await AsyncValue.guard(() => _loadTalkRooms());

  }
}
