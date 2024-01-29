import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';

@freezed
class Account with _$Account {
  const factory Account({
    @Default('') String id,
    @Default('') String name,
    @Default('') String myToken,
    @Default('') String imagePath,
    @Default([]) List<String> blockList,
  }) = _Account;
}
