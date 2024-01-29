import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/account/account.dart';
part 'account_notifier.g.dart';

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
