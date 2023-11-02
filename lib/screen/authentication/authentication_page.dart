import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import '../../utils/authentication.dart';
import '../../widgets/common_widgets/snackbar_utils.dart';

class LoginAndSignupPage extends StatefulWidget {
  const LoginAndSignupPage({super.key});

  @override
  State<LoginAndSignupPage> createState() => _LoginAndSignupPageState();
}

class _LoginAndSignupPageState extends State<LoginAndSignupPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: SafeArea(
        child: Center(
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
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: Colors.white), // インジケータを表示
                    );
                  } else {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Column(
                              children: [
                                SignInButton(Buttons.GoogleDark,
                                    text: 'Sign in with Google',
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    shape: const StadiumBorder(),
                                    onPressed: () async {
                                  try {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await Authentication.signInWithGoogle(
                                        context: context);
                                  } catch (e) {
                                    showErrorSnackBar(
                                        context: context,
                                        text: 'エラーが発生しました $e');
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }),
                                const SizedBox(height: 20),
                                SignInButton(Buttons.Apple,
                                    text: 'Sign in with Apple',
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 13),
                                    shape: const StadiumBorder(),
                                    onPressed: () async {
                                  try {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await Authentication.AppleSignIn(
                                        context: context);
                                  } catch (e) {
                                    showErrorSnackBar(
                                        context: context,
                                        text: 'エラーが発生しました $e');
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }),
                              ],
                            );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
