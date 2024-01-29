import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/account/account.dart';
import '../../../../models/account/account_state.dart';
part 'account_state_notifier.g.dart';

@riverpod
class AccountStateNotifier extends _$AccountStateNotifier {
  @override
  AccountState build() {
    return AccountState();
  }

  void onUserNameChange(String name) {
    state = state.copyWith(name: name);
  }

  void onUserImageChange(String imagePath) {
    state = state.copyWith(imagePath: imagePath);
  }

  void onUserBlockListChange(List<String> blockList) {
    state = state.copyWith(blockList: blockList);
  }

  void onUserTokenChange(String token) {
    state = state.copyWith(myToken: token);
  }

  void onUserIsAccountCreatedSuccessfully(bool value) {
    state = state.copyWith(isAccountCreatedSuccessfully: value);
  }

  void onUserIsEditing(bool isEditing) {
    state = state.copyWith(isEditing: isEditing);
  }

  void updateAll(Account newAccount) {
    state = state.copyWith(
      id: newAccount.id ?? state.id,
      name: newAccount.name ?? state.name,
      imagePath: newAccount.imagePath ?? state.imagePath,
      blockList: newAccount.blockList ?? state.blockList,
      myToken: newAccount.myToken ?? state.myToken,
    );
  }
}
