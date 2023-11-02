import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import '../../utils/authentication.dart';

// アプリへの初回サインインとログインする時に表示される画面

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              SizedBox(height: 20), // 画像とテキストの間にスペースを追加
              Text(
                'アプリを使用するには\nサインインが必要です',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: 20,
              ),

              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Futureがまだ完了していない場合、CircularProgressIndicatorを表示
                    return CircularProgressIndicator();
                  } else {
                    if (snapshot.hasError) {
                      // エラーが発生した場合、エラーメッセージを表示
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Futureが完了し、データが利用可能な場合、SignInButtonを表示
                      return Column(
                        children: [
                          //google
                          SignInButton(
                            Buttons.GoogleDark,
                            text: 'Sign in with Google',
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            shape: StadiumBorder(),
                            onPressed: () => Authentication.signInWithGoogle(
                                context: context),
                          ),
                          SizedBox(height: 20),
                          //apple
                          SignInButton(
                            Buttons.Apple,
                            text: 'Sign in with Apple',
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 13),
                            shape: StadiumBorder(),
                            onPressed: () =>
                                Authentication.AppleSignIn(context: context),
                          ),
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
