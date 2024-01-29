import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/posts/team_model.dart';
import '../../../view_models/team_view_model.dart';

part 'team_post_provider.g.dart';

@riverpod
class TeamPostNotifier extends _$TeamPostNotifier {
  @override
  Future<TeamPostData> build() async {
    try {
      final data = await TeamPostViewModel().getTeamPosts();
      print("notifierが呼ばれた");
      return data;
    } catch (e, stack) {
      throw AsyncError(e, stack);
    }
  }

// ユーザーデータの再読み込みを行うメソッド
  Future<void> reloadTeamPostData() async {
    final newTeamPostData = await build();
    state = AsyncValue.data(newTeamPostData);
  }
}
