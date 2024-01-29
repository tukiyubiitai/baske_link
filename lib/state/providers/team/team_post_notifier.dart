import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/posts/team_post_state.dart';

part 'team_post_notifier.g.dart';

@riverpod
class TeamStateNotifier extends _$TeamStateNotifier {
  @override
  TeamPostState build() {
    // ref.onDispose(() {});
    return TeamPostState();
  }

  void onUserIdChange(String id) {
    state = state.copyWith(id: id);
  }

  void onPostAccountIdChange(String postAccountId) {
    state = state.copyWith(postAccountId: postAccountId);
  }

  void onTeamNameChange(String teamName) {
    state = state.copyWith(teamName: teamName);
  }

  void onActivityTimeChange(String activityTime) {
    state = state.copyWith(activityTime: activityTime);
  }

  void onPrefectureChange(String prefecture) {
    state = state.copyWith(prefecture: prefecture);
  }

  void onLocationTagStringChange(String locationTagString) {
    state = state.copyWith(locationTagString: locationTagString);
  }

  void onTargetStringChange(String targetString) {
    state = state.copyWith(targetString: targetString);
  }

  void onAgeStringChange(String ageString) {
    state = state.copyWith(ageString: ageString);
  }

  void onTeamAppealChange(String teamAppeal) {
    state = state.copyWith(teamAppeal: teamAppeal);
  }

  void onCostChange(String cost) {
    state = state.copyWith(cost: cost);
  }

  void onGoalChange(String goal) {
    state = state.copyWith(goal: goal);
  }

  void onMemberCountChange(String memberCount) {
    state = state.copyWith(memberCount: memberCount);
  }

  void onImageChange(String imageUrl) {
    state = state.copyWith(imageUrl: imageUrl);
  }

  void onHeaderUrlChange(String headerUrl) {
    debugPrint("変更されました：　${headerUrl}");
    state = state.copyWith(headerUrl: headerUrl);
  }

  void onNoteChange(String note) {
    state = state.copyWith(note: note);
  }

  void onTypeChange(String type) {
    state = state.copyWith(type: type);
  }

  void addOldImage(String? imageUrl) {
    state = state.copyWith(oldImageUrl: imageUrl);
  }

  void addOldHeaderImage(String? headerUrl) {
    state = state.copyWith(oldHeaderUrl: headerUrl);
  }
}
