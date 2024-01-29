import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/account/account.dart';
import '../../../../models/posts/game_model.dart';
import '../../../view_models/game_view_model.dart';

part 'my_game_post_provider.g.dart';

@riverpod
class MyGamePostNotifier extends _$MyGamePostNotifier {
  @override
  Future<List<GamePost>?> build(Account myAccount) async {
    try {
      final data = await GamePostViewModel().getMyGamePosts(myAccount);
      return data;
    } catch (e, stack) {
      throw AsyncError(e, stack);
    }
  }

  Future<void> reloadPosts(Account myAccount) async {
    try {
      final newPosts = await build(myAccount);
      if (newPosts != null) {
        state = AsyncValue.data(newPosts);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
