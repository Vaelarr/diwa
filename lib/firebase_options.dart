import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        // Added support for Windows platform
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

  // Replace these with your own Firebase project settings
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDrZRNim-amYbVriIpcri2kjsHxB44sPSY',
    authDomain: 'diwaapp-56163.firebaseapp.com',
    databaseURL: 'https://diwaapp-56163-default-rtdb.firebaseio.com',
    projectId: 'diwaapp-56163',
    storageBucket: 'diwaapp-56163.firebasestorage.app',
    messagingSenderId: '590290984500',
    appId: '1:590290984500:web:f60de2b8e371c823cef461',
    measurementId: 'G-F3GF92CQ53'
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBLhEf9A3AsJj4IRDmCsJKikOFHCPlP-eI',
    appId: '1:590290984500:android:0afa3a0a6753d032cef461',
    messagingSenderId: '590290984500',
    projectId: 'diwaapp-56163',
    databaseURL: 'https://diwaapp-56163-default-rtdb.firebaseio.com',
    storageBucket: 'diwaapp-56163.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAqrfEKZPj9HfhVDXZp5zrKtswxTGIdTDY',
    appId: '1:590290984500:ios:d23f1b1de3ab0a42cef461',
    messagingSenderId: '590290984500',
    projectId: 'diwaapp-56163',
    databaseURL: 'https://diwaapp-56163-default-rtdb.firebaseio.com',
    storageBucket: 'diwaapp-56163.firebasestorage.app',
    iosClientId: '590290984500-qgtlm5rm6f5n3e3gn7q9kp1gghtpnd0v.apps.googleusercontent.com',
    iosBundleId: 'com.example.diwa',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAqrfEKZPj9HfhVDXZp5zrKtswxTGIdTDY',
    appId: '1:590290984500:ios:d23f1b1de3ab0a42cef461',
    messagingSenderId: '590290984500',
    projectId: 'diwaapp-56163',
    databaseURL: 'https://diwaapp-56163-default-rtdb.firebaseio.com',
    storageBucket: 'diwaapp-56163.firebasestorage.app',
    iosClientId: '590290984500-qgtlm5rm6f5n3e3gn7q9kp1gghtpnd0v.apps.googleusercontent.com',
    iosBundleId: 'com.example.diwa',
  );
  
  // Add Windows configuration
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDrZRNim-amYbVriIpcri2kjsHxB44sPSY',
    authDomain: 'diwaapp-56163.firebaseapp.com',
    databaseURL: 'https://diwaapp-56163-default-rtdb.firebaseio.com',
    projectId: 'diwaapp-56163',
    storageBucket: 'diwaapp-56163.firebasestorage.app',
    messagingSenderId: '590290984500',
    appId: '1:590290984500:web:bcfe0c1213dbf5becef461',
    measurementId: 'G-NSC9E7GFD1',
    // Windows specific fields can be added as needed
  );
}