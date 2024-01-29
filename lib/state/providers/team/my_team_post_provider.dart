import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/account/account.dart';
import '../../../../models/posts/team_model.dart';
import '../../../view_models/team_view_model.dart';

part 'my_team_post_provider.g.dart';

@riverpod
class MyTeamPostNotifier extends _$MyTeamPostNotifier {
  @override
  Future<List<TeamPost>?> build(Account myAccount) async {
    try {
      final data = await TeamPostViewModel().getMyTeamPosts(myAccount);
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
