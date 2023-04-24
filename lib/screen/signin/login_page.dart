import 'package:flutter/material.dart';

import '../../utils/authentication.dart';
import '../../widgets/google_signin_button.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(), // 上部の余白を追加
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
              Spacer(), // 下部の余白を追加
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton();
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.purple,
                    ),
                  );
                },
              ),
              Spacer(), // 下部の余白を追加
            ],
          ),
        ),
      ),
    );
  }
}
