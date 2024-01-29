import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'target_notifier.g.dart';

@riverpod
class TargetState extends _$TargetState {
  @override
  List<String> build() {
    return [];
  }

  void updateSelectedValue(List<String> tagList) {
    state = tagList;
  }
}
