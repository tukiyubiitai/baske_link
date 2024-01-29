import 'package:basketball_app/infrastructure/firebase/game_posts_firebase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/posts/game_model.dart';

part 'game_post_provider.g.dart';

@riverpod
class GamePostNotifier extends _$GamePostNotifier {
  @override
  Future<GamePostData> build() async {
    try {
      final data = await GamePostFirestore().getGamePosts();
      return data;
    } catch (e, stack) {
      throw AsyncError(e, stack);
    }
  }

// ユーザーデータの再読み込みを行うメソッド

  Future<void> reloadGamePostData() async {
    final newGamePostData = await build();
    state = AsyncValue.data(newGamePostData);
  }
}
