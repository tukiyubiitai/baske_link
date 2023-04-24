// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCzMPvN8IlDrkkAE9pgn1AUwdZn0DTb1N0',
    appId: '1:961571618026:web:315510405519ccbcdb2b93',
    messagingSenderId: '961571618026',
    projectId: 'basket-ball-app',
    authDomain: 'basket-ball-app.firebaseapp.com',
    storageBucket: 'basket-ball-app.appspot.com',
    measurementId: 'G-868Y39WB6L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDE59qeF5hMU4BYlMsdRrA5As0uBzZXUmg',
    appId: '1:961571618026:android:3ffc6b228bcf941fdb2b93',
    messagingSenderId: '961571618026',
    projectId: 'basket-ball-app',
    storageBucket: 'basket-ball-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5305mU3bn2HCu9zqGzzSOKLuXBA3PPwk',
    appId: '1:961571618026:ios:1faff1226bbad08ddb2b93',
    messagingSenderId: '961571618026',
    projectId: 'basket-ball-app',
    storageBucket: 'basket-ball-app.appspot.com',
    iosClientId: '961571618026-ova8unfl5d211vtsbfrihbc90djl5fnn.apps.googleusercontent.com',
    iosBundleId: 'com.example.searchMassage',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC5305mU3bn2HCu9zqGzzSOKLuXBA3PPwk',
    appId: '1:961571618026:ios:1faff1226bbad08ddb2b93',
    messagingSenderId: '961571618026',
    projectId: 'basket-ball-app',
    storageBucket: 'basket-ball-app.appspot.com',
    iosClientId: '961571618026-ova8unfl5d211vtsbfrihbc90djl5fnn.apps.googleusercontent.com',
    iosBundleId: 'com.example.searchMassage',
  );
}
