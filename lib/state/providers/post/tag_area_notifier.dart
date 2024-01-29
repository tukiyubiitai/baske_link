import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tag_area_notifier.g.dart';

@riverpod
class TagAreaState extends _$TagAreaState {
  @override
  List<String> build() {
    return [];
  }

  void addTag(String tag) {
    state.add(tag);
  }

  void removeTag(int index) {
    state.removeAt(index);
  }

  void clearTags() {
    state.clear();
  }
}
