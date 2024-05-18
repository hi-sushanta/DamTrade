// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCcQutfQIBCldYJc7TyVvjGMrDJVDhnKow',
    appId: '1:467721621108:web:072d5dcdf914f5878b0b21',
    messagingSenderId: '467721621108',
    projectId: 'damtrade-c06f8',
    authDomain: 'damtrade-c06f8.firebaseapp.com',
    storageBucket: 'damtrade-c06f8.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAd21jAwm5Cz5q1ZMQRE5pfBCSshgQqDLE',
    appId: '1:467721621108:android:f8ca7249f78e51ef8b0b21',
    messagingSenderId: '467721621108',
    projectId: 'damtrade-c06f8',
    storageBucket: 'damtrade-c06f8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCd81SR-j28w4ykNnoaxHy1_SeVAqYlDh4',
    appId: '1:467721621108:ios:1e45a7f824ec92888b0b21',
    messagingSenderId: '467721621108',
    projectId: 'damtrade-c06f8',
    storageBucket: 'damtrade-c06f8.appspot.com',
    iosBundleId: 'com.example.damtrade',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCd81SR-j28w4ykNnoaxHy1_SeVAqYlDh4',
    appId: '1:467721621108:ios:1e45a7f824ec92888b0b21',
    messagingSenderId: '467721621108',
    projectId: 'damtrade-c06f8',
    storageBucket: 'damtrade-c06f8.appspot.com',
    iosBundleId: 'com.example.damtrade',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCcQutfQIBCldYJc7TyVvjGMrDJVDhnKow',
    appId: '1:467721621108:web:7452eb915c6adace8b0b21',
    messagingSenderId: '467721621108',
    projectId: 'damtrade-c06f8',
    authDomain: 'damtrade-c06f8.firebaseapp.com',
    storageBucket: 'damtrade-c06f8.appspot.com',
  );
}
