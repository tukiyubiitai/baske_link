// import 'package:flutter/material.dart';
//
// import '../../services/authentication.dart';
// import '../../services/error_messages.dart';
// import '../../utils/snackbar_utils.dart';
// import '../../widgets/auth/sign_in_button.dart';
// import '../../widgets/progress_indicator.dart';
//
// /*
// アプリの一番初めのページ
//  */
//
// class LoginAndSignupPage extends StatefulWidget {
//   const LoginAndSignupPage({super.key});
//
//   @override
//   State<LoginAndSignupPage> createState() => _LoginAndSignupPageState();
// }
//
// class _LoginAndSignupPageState extends State<LoginAndSignupPage> {
//   bool _isLoading = false;
//
//   // ローディング状態を更新する関数
//   void _setLoading(bool isLoading) {
//     setState(() {
//       _isLoading = isLoading;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.indigo[900],
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/images/login.jpg',
//                 height: 250,
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'アプリを使用するには\nサインインが必要です',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 30,
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               FutureBuilder(
//                 future: Authentication.initializeFirebase(context: context),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return ShowProgressIndicator(
//                       textColor: Colors.white,
//                       indicatorColor: Colors.white,
//                     );
//                   } else {
//                     if (snapshot.hasError) {
//                       String errorMessage =
//                           firebaseErrorMessage(snapshot.error);
//                       return Center(
//                           child: Text(
//                         errorMessage,
//                         style: TextStyle(color: Colors.red),
//                       ));
//                     } else {
//                       return _isLoading
//                           ? ShowProgressIndicator(
//                               textColor: Colors.white,
//                               indicatorColor: Colors.white,
//                             )
//                           : SignInButtons(
//                               onGoogleSignIn: () async {
//                                 // Googleサインインの処理
//                                 try {
//                                   _setLoading(true);
//                                   await Authentication.signInWithGoogle(
//                                       context: context);
//                                 } catch (e) {
//                                   showErrorSnackBar(
//                                       context: context, text: 'エラーが発生しました $e');
//                                 } finally {
//                                   _setLoading(false);
//                                 }
//                               },
//                               onAppleSignIn: () async {
//                                 // Appleサインインの処理
//                                 try {
//                                   _setLoading(true);
//
//                                   await Authentication.AppleSignIn(
//                                       context: context);
//                                 } catch (e) {
//                                   showErrorSnackBar(
//                                       context: context, text: 'エラーが発生しました $e');
//                                 } finally {
//                                   _setLoading(false);
//                                 }
//                               },
//                             );
//                     }
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
