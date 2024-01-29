import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import '../../../utils/error_handler.dart';
import '../../view_models/auth_view_model.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/progress_indicator.dart';
import '../account/create_account_page.dart';

class SignInScreen extends ConsumerWidget {
  final bool loader;
  final WidgetRef ref;

  const SignInScreen({super.key, required this.loader, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/login.jpg',
            height: 250,
          ),
          const SizedBox(height: 20),
          const Text(
            'アプリを使用するには\nサインインが必要です',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 20),
          !loader
              ? SignInButtons(
                  onGoogleSignIn: () async {
                    await onGoogleSignIn(ref);
                  },
                  onAppleSignIn: () async {
                    await onAppleSignIn(ref);
                  },
                )
              : ShowProgressIndicator(
                  textColor: Colors.white,
                  indicatorColor: Colors.white,
                ),
        ],
      ),
    );
  }

  // Googleサインインの処理
  Future<void> onGoogleSignIn(
    WidgetRef ref,
  ) async {
    try {
      final result = await AuthViewModel().signInWithGoogle(ref);
      if (result) {
        Navigator.pushReplacement(
          ref.context,
          MaterialPageRoute(
              builder: (context) => const BottomTabNavigator(
                    initialIndex: 0,
                    userId: '',
                  )),
        );
      } else {
        //ユーザーが存在しない　=>  CreateAccount()
        Navigator.of(ref.context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CreateAccount(),
          ),
        );
      }
    } catch (e) {
      handleError(e, ref.context);
    }
  }

// Appleサインインの処理
  Future<void> onAppleSignIn(WidgetRef ref) async {
    try {
      final result = await AuthViewModel().signInWithApple(ref);
      if (result) {
        Navigator.pushReplacement(
          ref.context,
          MaterialPageRoute(
              builder: (context) => const BottomTabNavigator(
                    initialIndex: 0,
                    userId: '',
                  )),
        );
      } else {
        //ユーザーが存在しない　=>  CreateAccount()
        Navigator.of(ref.context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CreateAccount(),
          ),
        );
      }
    } catch (e) {
      handleError(e, ref.context);
    }
  }
}

class SignInButtons extends StatelessWidget {
  final VoidCallback onGoogleSignIn;
  final VoidCallback onAppleSignIn;

  const SignInButtons({
    Key? key,
    required this.onGoogleSignIn,
    required this.onAppleSignIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SignInButton(
          Buttons.GoogleDark,
          text: 'Sign in with Google',
          onPressed: onGoogleSignIn,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          shape: const StadiumBorder(),
        ),
        const SizedBox(height: 20),
        SignInButton(
          Buttons.Apple,
          text: 'Sign in with Apple',
          onPressed: onAppleSignIn,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: const StadiumBorder(),
        ),
      ],
    );
  }
}
