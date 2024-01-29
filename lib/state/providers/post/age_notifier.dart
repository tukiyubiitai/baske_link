import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'age_notifier.g.dart';

@riverpod
class AgeState extends _$AgeState {
  @override
  List<String> build() {
    return [];
  }

  void updateSelectedValue(List<String> value) {
    state = value;
  }
}
