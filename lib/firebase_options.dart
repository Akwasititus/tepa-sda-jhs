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
    apiKey: 'AIzaSyAYjRn7HULKtA1DNKKxsaqLoHTJ8pYqles',
    appId: '1:992696169490:web:9331c48c62366624fe54cb',
    messagingSenderId: '992696169490',
    projectId: 'sda-jsh',
    authDomain: 'sda-jsh.firebaseapp.com',
    storageBucket: 'sda-jsh.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAY_hNbHRJ5lTywVbjs85fQSJeZwweOXqk',
    appId: '1:992696169490:android:ab7bc3e32efde227fe54cb',
    messagingSenderId: '992696169490',
    projectId: 'sda-jsh',
    storageBucket: 'sda-jsh.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtjdcroztSDYJtBj7E1OBFMo7_yrHCBck',
    appId: '1:992696169490:ios:18fedec6cee548e9fe54cb',
    messagingSenderId: '992696169490',
    projectId: 'sda-jsh',
    storageBucket: 'sda-jsh.firebasestorage.app',
    iosBundleId: 'com.titi.sda',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAtjdcroztSDYJtBj7E1OBFMo7_yrHCBck',
    appId: '1:992696169490:ios:18fedec6cee548e9fe54cb',
    messagingSenderId: '992696169490',
    projectId: 'sda-jsh',
    storageBucket: 'sda-jsh.firebasestorage.app',
    iosBundleId: 'com.titi.sda',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAYjRn7HULKtA1DNKKxsaqLoHTJ8pYqles',
    appId: '1:992696169490:web:61186d801b07f111fe54cb',
    messagingSenderId: '992696169490',
    projectId: 'sda-jsh',
    authDomain: 'sda-jsh.firebaseapp.com',
    storageBucket: 'sda-jsh.firebasestorage.app',
  );
}
