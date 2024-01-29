import 'package:basketball_app/view_models/team_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'models/posts/team_model.dart';
part 'team_post_model_provider.g.dart';

@riverpod
class PostStateNotifier extends _$PostStateNotifier {
  @override
  Future<TeamPost?> build(String? postId, bool isEditing) async {
    final TeamPost? post =
        await TeamPostViewModel().checkMode(postId, isEditing);
    return post;
  }
}
