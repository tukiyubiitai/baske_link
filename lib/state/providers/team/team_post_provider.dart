import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/posts/team_model.dart';
import '../../../models/account/account.dart';
import '../../../view_models/team_view_model.dart';

part 'team_post_provider.g.dart';

@riverpod
class TeamPostNotifier extends _$TeamPostNotifier {
  @override
  Future<TeamPostData> build() => _loadTeamPost();

  Future<TeamPostData> _loadTeamPost() async {
    try {
      final data = await TeamPostManager().getTeamPosts();
      return data;
    } catch (e, stack) {
      throw AsyncError(e, stack);
    }
  }

// ユーザーデータの再読み込みを行うメソッド
  Future<void> reloadTeamPostData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadTeamPost());
  }
}

@riverpod
class MyTeamPostNotifier extends _$MyTeamPostNotifier {
  @override
  Future<List<TeamPost>?> build(Account myAccount) => _loadMyTeamPost();

  Future<List<TeamPost>?> _loadMyTeamPost() async {
    try {
      final data = await TeamPostManager().getMyTeamPosts(myAccount);
      return data;
    } catch (e, stack) {
      throw AsyncError(e, stack);
    }
  }

  Future<void> reloadPosts(Account myAccount) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadMyTeamPost());
  }
}

@riverpod
class TeamSearchNotifier extends _$TeamSearchNotifier {
  @override
  Future<TeamPostData> build(
      String? selectedLocation, String? keywordLocation) async {
    try {
      final teamPostData = await TeamPostManager()
          .retrieveFilteredTeamPosts(selectedLocation, keywordLocation);
      return teamPostData;
    } catch (e, stack) {
      throw AsyncError(e, stack);
    }
  }
}
