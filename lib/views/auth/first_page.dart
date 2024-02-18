import 'package:basketball_app/models/auth/auth_status.dart';
import 'package:basketball_app/models/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bottom_navigation.dart';
import '../../state/providers/auth/auth_notifier.dart';
import '../../state/providers/global_loader.dart';
import '../../widgets/progress_indicator.dart';
import '../account/create_account_page.dart';
import 'sign_in_screen.dart';

class FirstPage extends ConsumerWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsyncValue = ref.watch(authStateNotifierProvider);
    final loader = ref.watch(globalLoaderProvider); // ローディング状態を監視

    return Scaffold(
      backgroundColor: AppColors.baseColor,
      body: authAsyncValue.when(
        error: (e, stack) => Center(
          child: Text(
            '予期せぬエラーが発生しました\nアプリを再起動させて下さい',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        loading: () => ShowProgressIndicator(
          textColor: Colors.white,
          indicatorColor: Colors.white,
        ),
        data: (status) {
          switch (status) {
            case AuthStatus.unauthenticated:
              //サインイン表示
              return SignInScreen(loader: loader, ref: ref);
            case AuthStatus.accountNotCreated:
              //アカウント作成ページ
              return CreateAccount();
            case AuthStatus.authenticated:
              //タイムラインページ
              return BottomTabNavigator(initialIndex: 3, userId: '');
          }
        },
      ),
    );
  }
}
