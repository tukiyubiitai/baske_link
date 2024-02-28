import 'package:basketball_app/infrastructure/firebase/game_posts_firebase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/posts/game_model.dart';
import '../../../models/account/account.dart';
import '../../../view_models/game_view_model.dart';

part 'game_post_notifier.g.dart';

@riverpod
class GamePostNotifier extends _$GamePostNotifier {
  @override
  Future<GamePostData> build() => _loadGamePost();

  Future<GamePostData> _loadGamePost() async {
    try {
      final data = await GamePostFirestore().getGamePosts();
      return data;
    } catch (e, stack) {
      throw AsyncError(e, stack);
    }
  }

// ユーザーデータの再読み込みを行うメソッド

  Future<void> reloadGamePostData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadGamePost());
  }
}

@riverpod
class MyGamePostNotifier extends _$MyGamePostNotifier {
  @override
  Future<List<GamePost>?> build(Account myAccount) => _loadMyGamePost();

  Future<List<GamePost>?> _loadMyGamePost() async {
    try {
      final data = await GamePostManager().getMyGamePosts(myAccount);
      return data;
    } catch (e, stack) {
      throw AsyncError(e, stack);
    }
  }

  Future<void> reloadPosts(Account myAccount) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadMyGamePost());
  }
}

@riverpod
class GameSearchNotifier extends _$GameSearchNotifier {
  @override
  Future<GamePostData> build(
      String? selectedLocation, String? keywordLocation) async {
    try {
      final gamePostData = await GamePostManager()
          .retrieveFilteredGamePosts(selectedLocation, keywordLocation);
      return gamePostData;
    } catch (e, stack) {
      throw AsyncError(e, stack);
    }
  }
}
