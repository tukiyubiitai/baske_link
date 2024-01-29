import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'area_notifier.g.dart';

@riverpod
class AreaState extends _$AreaState {
  @override
  String build() {
    return "";
  }

  void setSelectedValue(String value) {
    state = value;
  }

  void clearTags() {
    state = "";
  }
}
