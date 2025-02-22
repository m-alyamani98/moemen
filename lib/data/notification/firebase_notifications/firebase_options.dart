import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBw-N2YTdXwVEf8NZ7tRwTfBK0nkbh2OIw',
    appId: '1:872313168403:android:1f8adbd416dbf13170d5e6',
    messagingSenderId: '872313168403',
    projectId: 'moemen-87f62',
    databaseURL: 'https://moemen-87f62.firebaseio.com',
    storageBucket: 'moemen-87f62.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADALlcxDkjiTdh3gr1cOi_jiBo0i7HPHE',
    appId: '1:872313168403:ios:761b7dfbc7d3be9070d5e6',
    messagingSenderId: '872313168403',
    projectId: 'moemen-87f62',
    databaseURL: 'https://moemen-87f62-default-rtdb.firebaseio.com',
    storageBucket: 'moemen-87f62.firebasestorage.app',
    androidClientId: '872313168403-v2f5o0ed9pnqdm6ujhnemfj74a4p5b2f.apps.googleusercontent.com',
    iosClientId: '872313168403-4eqb2lls92dq768il9gbru4fguomad2p.apps.googleusercontent.com',
    iosBundleId: 'com.example.momen',
  );
}
