import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/posts/team_model.dart';
import '../../../view_models/team_view_model.dart';

part 'team_search_notifier.g.dart';

@riverpod
class TeamSearchNotifier extends _$TeamSearchNotifier {
  @override
  Future<TeamPostData> build(
      String? selectedLocation, String? keywordLocation) async {
    try {
      final teamPostData = await TeamPostViewModel()
          .retrieveFilteredTeamPosts(selectedLocation, keywordLocation);
      return teamPostData;
    } catch (e, stack) {
      throw AsyncError(e, stack);
    }
  }
}
