import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../infrastructure/firebase/account_firebase.dart';
import '../../../../infrastructure/firebase/authentication_service.dart';
import '../../../models/auth/auth_status.dart';
import '../../../view_models/auth_view_model.dart';
import '../account/account_notifier.dart';
import '../account/account_state_notifier.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthStateNotifier extends _$AuthStateNotifier {
  @override
  Future<AuthStatus> build() async {
    try {
      final user = await AuthenticationService().getCurrentUser();
      if (user == null) return AuthStatus.unauthenticated; // 認証されていない

      //Firestoreにユーザーデータがあるかチェック
      final userAccount = await AccountFirestore.fetchUserData(user.uid);
      if (userAccount != null) {
        //トークン更新
        AuthenticationService().updateUserToken(user);
        ref.read(accountNotifierProvider.notifier).updateAccount(userAccount);
        // AuthenticationService.updateMyAccount(userAccount);
        ref.read(accountStateNotifierProvider.notifier).updateAll(userAccount);
        return AuthStatus.authenticated; // 認証され、Firestoreにデータがある
      } else {
        return AuthStatus.accountNotCreated; // アカウントはあるが、Firestoreにデータがない
      }
      // final AuthStatus status =
      //     await AuthViewModel().signIn(ref); //アカウント情報を状態管理

      // return status;
    } catch (e, stack) {
      throw AsyncError(e, stack);
    }
  }

  Future<AuthStatus> signOut() async {
    final success = await AuthViewModel().signOut();
    if (success) {
      return AuthStatus.unauthenticated; // サインアウト成功時は未認証状態にする
    } else {
      return AuthStatus.authenticated; // サインアウト失敗時は認証済み状態を維持
    }
  }
}
