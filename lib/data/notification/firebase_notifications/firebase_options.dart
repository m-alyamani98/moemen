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
    appId: '1:872313168403:android:755e8bfe017a975770d5e6',
    messagingSenderId: '872313168403',
    projectId: 'moemen-87f62',
    databaseURL: 'https://moemen-87f62.firebaseio.com',
    storageBucket: 'moemen-87f62.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADALlcxDkjiTdh3gr1cOi_jiBo0i7HPHE',
    appId: '1:872313168403:ios:3e67a9195454e7ef70d5e6',
    messagingSenderId: '872313168403',
    projectId: 'moemen-87f62',
    databaseURL: 'https://moemen-87f62-default-rtdb.firebaseio.com',
    storageBucket: 'moemen-87f62.firebasestorage.app',
    androidClientId: '872313168403-taufkrvrp01u0ld7j4mp88570vg868lb.apps.googleusercontent.com',
    iosClientId: '872313168403-dk0h7bg7bj4vg7hbppe65k1gcbv21pal.apps.googleusercontent.com',
    iosBundleId: 'com.moemen.moemen',
  );
}
