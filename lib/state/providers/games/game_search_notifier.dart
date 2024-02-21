import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/posts/game_model.dart';
import '../../../view_models/game_view_model.dart';

part 'game_search_notifier.g.dart';

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
