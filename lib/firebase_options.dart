import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase config for apex-fund (same project as apex-firm web).
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
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAVT4h6lCxEBzbIute3cuZyX4dc0Dxm3F4',
    appId: '1:553844680664:web:4183c9f12d8e25221274ad',
    messagingSenderId: '553844680664',
    projectId: 'apex-fund',
    authDomain: 'apex-fund.firebaseapp.com',
    storageBucket: 'apex-fund.firebasestorage.app',
    measurementId: 'G-JPEB574VY4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAVT4h6lCxEBzbIute3cuZyX4dc0Dxm3F4',
    appId: '1:553844680664:web:4183c9f12d8e25221274ad',
    messagingSenderId: '553844680664',
    projectId: 'apex-fund',
    storageBucket: 'apex-fund.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAVT4h6lCxEBzbIute3cuZyX4dc0Dxm3F4',
    appId: '1:553844680664:web:4183c9f12d8e25221274ad',
    messagingSenderId: '553844680664',
    projectId: 'apex-fund',
    storageBucket: 'apex-fund.firebasestorage.app',
    iosBundleId: 'com.apexfirm.mobile',
  );
}
