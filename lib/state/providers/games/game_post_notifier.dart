import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/posts/game_post_state.dart';
part 'game_post_notifier.g.dart';

@riverpod
class GameStateNotifier extends _$GameStateNotifier {
  @override
  GameState build() {
    return GameState();
  }

  void onTeamNameChange(String teamName) {
    state = state.copyWith(teamName: teamName);
  }

  void onLocationTagStringChange(String locationTagString) {
    state = state.copyWith(locationTagString: locationTagString);
  }

  void onPrefectureChange(String prefecture) {
    state = state.copyWith(prefecture: prefecture);
  }

  void onLevelChange(int level) {
    state = state.copyWith(level: level);
  }

  void onMemberChange(String member) {
    state = state.copyWith(member: member);
  }

  void onAgeListChange(String ageString) {
    state = state.copyWith(ageString: ageString);
  }

  void onNoteChange(String note) {
    state = state.copyWith(note: note);
  }

  void onImageChange(String imageUrl) {
    state = state.copyWith(imageUrl: imageUrl);
  }

  void addOldImage(String? imageUrl) {
    state = state.copyWith(oldImageUrl: imageUrl);
  }
}
