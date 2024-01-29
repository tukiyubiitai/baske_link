// import 'package:basketball_app/presentation/utils/error_handler.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../application/state/providers/account/account_notifier.dart';
// import '../application/state/providers/global_loader.dart';
// import '../domain/types/account/account.dart';
// import '../domain/types/account/account_state.dart';
// import '../infrastructure/firebase/account_firebase.dart';
// import 'dialogs/snackbar_utils.dart';
//
// class AccountViewModel extends StateNotifier<AccountState> {
//   AccountViewModel(super.state);
//
//   Future<bool> createUserAccount(WidgetRef ref) async {
//     try {
//       // 現在のユーザーを取得
//       final User? user = await AccountFirestore.getCurrentUser();
//       if (user == null) {
//         showErrorSnackBar(context: ref.context, text: "ユーザーが見つかりません");
//         return false;
//       }
//
//       // 以下、アカウント保存処理
//       var accountState = ref.read(accountStateNotifierProvider);
//       String name = accountState.name;
//
//       if (accountState.name.isEmpty || name.isEmpty) {
//         showErrorSnackBar(context: ref.context, text: "名前が入力されていません");
//         return false;
//       }
//
//       if (accountState.name.length < 1 || name.length < 1) {
//         showErrorSnackBar(context: ref.context, text: "名前が短いです");
//         return false;
//       }
//
//       // ロード開始
//       ref.read(globalLoaderProvider.notifier).setLoaderValue(true);
//
//       // アカウントオブジェクトを取得
//       final Account newAccount = await repareNewUserAccountData(
//           user.uid, accountState.name, accountState.imagePath);
//
//       // firestore　保存処理
//       var result = await AccountFirestore().saveNewUserToFirestore(newAccount);
//       if (result) {
//         //riverpodにAccountの状態を保存
//         ref.read(accountStateNotifierProvider.notifier).updateAll(newAccount);
//         return true;
//       }
//       return false;
//     } catch (e) {
//       throw getErrorMessage(e);
//     } finally {
//       // ロード終了
//       ref.read(globalLoaderProvider.notifier).setLoaderValue(false);
//     }
//   }
//
//   final accountViewModelProvider =
//       StateNotifierProvider<AccountViewModel, AccountState>((ref) {
//     return AccountViewModel();
//   });
// }
