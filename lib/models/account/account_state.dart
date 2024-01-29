import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_state.freezed.dart';

@freezed
class AccountState with _$AccountState {
  const factory AccountState({
    @Default('') String id,
    @Default('') String name,
    @Default('') String myToken,
    @Default('') String imagePath,
    @Default([]) List<String> blockList,
    @Default(false) bool isAccountCreatedSuccessfully,
    @Default(false) bool isEditing,
  }) = _AccountState;
}
