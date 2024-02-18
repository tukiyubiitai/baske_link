import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/account/account.dart';

part 'account_notifier.g.dart';

//アカウント情報を管理
@Riverpod(keepAlive: true)
class AccountNotifier extends _$AccountNotifier {
  @override
  Account build() {
    return Account();
  }

  void updateAccount(Account newAccount) {
    state = newAccount;
  }
}

@riverpod
class AccountStateNotifier extends _$AccountStateNotifier {
  @override
  AccountState build() {
    ref.onDispose(() {
      debugPrint("データを破棄しました");
    });
    return AccountState();
  }

  void onUserIsAccountCreatedSuccessfully(bool isSuccess) {
    state = state.copyWith(isAccountCreatedSuccessfully: isSuccess);
  }

  void updateIsEditing(bool isEditing) {
    state = state.copyWith(isEditing: isEditing);
  }

  void onUserNameChange(String name) {
    state = state.copyWith(name: name);
  }

  void onUserImageChange(String imagePath) {
    state = state.copyWith(imagePath: imagePath);
  }

  void updateAll(Account newAccount) {
    state = state.copyWith(
      id: newAccount.id,
      name: newAccount.name,
      imagePath: newAccount.imagePath,
    );
  }
}
