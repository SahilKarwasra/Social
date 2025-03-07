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
    apiKey: 'AIzaSyAiEfaouxvBX_0HCdROMLHfB9VQnVY53lU',
    appId: '1:136046190225:web:e613031058dc9aedc72930',
    messagingSenderId: '136046190225',
    projectId: 'social-a7325',
    authDomain: 'social-a7325.firebaseapp.com',
    storageBucket: 'social-a7325.firebasestorage.app',
    measurementId: 'G-ZFKKCR32VM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdm2KBd7ZQuJ5yeCe-PvjKt_6maC_4diE',
    appId: '1:136046190225:android:66720ee45f9543f9c72930',
    messagingSenderId: '136046190225',
    projectId: 'social-a7325',
    storageBucket: 'social-a7325.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDpgOlWWLAZUhHMdoBUPbjWOZrtY9cPfdk',
    appId: '1:136046190225:ios:861e2a5de5a42b1fc72930',
    messagingSenderId: '136046190225',
    projectId: 'social-a7325',
    storageBucket: 'social-a7325.firebasestorage.app',
    iosBundleId: 'com.example.social',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDpgOlWWLAZUhHMdoBUPbjWOZrtY9cPfdk',
    appId: '1:136046190225:ios:861e2a5de5a42b1fc72930',
    messagingSenderId: '136046190225',
    projectId: 'social-a7325',
    storageBucket: 'social-a7325.firebasestorage.app',
    iosBundleId: 'com.example.social',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAiEfaouxvBX_0HCdROMLHfB9VQnVY53lU',
    appId: '1:136046190225:web:4439bc062eb6a9d4c72930',
    messagingSenderId: '136046190225',
    projectId: 'social-a7325',
    authDomain: 'social-a7325.firebaseapp.com',
    storageBucket: 'social-a7325.firebasestorage.app',
    measurementId: 'G-KCCVSNNCBD',
  );
}
