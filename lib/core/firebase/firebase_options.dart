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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBAMAYq_I_TWH8GJdoAsZPXRq59cOqFQK8',
    appId: '1:469088548357:web:710fd8e0fcb32a424b4e6c',
    messagingSenderId: '469088548357',
    projectId: 'manhwa-helper',
    authDomain: 'manhwa-helper.firebaseapp.com',
    storageBucket: 'manhwa-helper.appspot.com',
    measurementId: 'G-V4B7MT69N6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBessK1R-zo7bT2YQxgg0i_wK4zY6zyrWE',
    appId: '1:469088548357:android:5b52bfbc5b0590d54b4e6c',
    messagingSenderId: '469088548357',
    projectId: 'manhwa-helper',
    storageBucket: 'manhwa-helper.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDswOKmutHjWfYmKkJAPnc5cYB1bIkyokc',
    appId: '1:469088548357:ios:85235a7be4fe0e724b4e6c',
    messagingSenderId: '469088548357',
    projectId: 'manhwa-helper',
    storageBucket: 'manhwa-helper.appspot.com',
    iosClientId: '469088548357-617r78h4nb3dsmrulo0q5o7mmola4e72.apps.googleusercontent.com',
    iosBundleId: 'com.example.manhwaAlert',
  );
}
