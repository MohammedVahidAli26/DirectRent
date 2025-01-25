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
    apiKey: 'AIzaSyBFVUaYnNJa_6n90u2ITuRSMnPy0hIuXZk',
    appId: '1:106851533819:web:b5e214c509469341d3815e',
    messagingSenderId: '106851533819',
    projectId: 'quizapp-5fdcc',
    authDomain: 'quizapp-5fdcc.firebaseapp.com',
    storageBucket: 'quizapp-5fdcc.firebasestorage.app',
    measurementId: 'G-CF4VL27XHB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBMrqkJd3rcB2EsAOzSZYFP6zQW7GUerBo',
    appId: '1:106851533819:android:dae63a70289df172d3815e',
    messagingSenderId: '106851533819',
    projectId: 'quizapp-5fdcc',
    storageBucket: 'quizapp-5fdcc.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBzb1DsoSxtPTmP-d2y4wfPbwNKHbGotO8',
    appId: '1:106851533819:ios:80a3512b99468a7dd3815e',
    messagingSenderId: '106851533819',
    projectId: 'quizapp-5fdcc',
    storageBucket: 'quizapp-5fdcc.firebasestorage.app',
    iosBundleId: 'com.example.quizapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBzb1DsoSxtPTmP-d2y4wfPbwNKHbGotO8',
    appId: '1:106851533819:ios:80a3512b99468a7dd3815e',
    messagingSenderId: '106851533819',
    projectId: 'quizapp-5fdcc',
    storageBucket: 'quizapp-5fdcc.firebasestorage.app',
    iosBundleId: 'com.example.quizapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBFVUaYnNJa_6n90u2ITuRSMnPy0hIuXZk',
    appId: '1:106851533819:web:bb0dcbcb3d77b535d3815e',
    messagingSenderId: '106851533819',
    projectId: 'quizapp-5fdcc',
    authDomain: 'quizapp-5fdcc.firebaseapp.com',
    storageBucket: 'quizapp-5fdcc.firebasestorage.app',
    measurementId: 'G-BW3J75LP13',
  );
}
