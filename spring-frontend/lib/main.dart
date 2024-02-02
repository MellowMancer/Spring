import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'dashboard.dart';
import 'login.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  // );
  // if(kIsWeb){
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(apiKey: "AIzaSyCYe3ASqwa3ahPVYy8uXYfr9K0C6i2zRVw",
  //     authDomain: "spring-a-ling.firebaseapp.com",
  //     databaseURL: "https://spring-a-ling-default-rtdb.asia-southeast1.firebasedatabase.app",
  //     projectId: "spring-a-ling",
  //     storageBucket: "spring-a-ling.appspot.com",
  //     messagingSenderId: "610922772594",
  //     appId: "1:610922772594:web:e33e3664db737349f82aeb",
  //     measurementId: "G-869YBQ6538"),
  //   );
  // }
  runApp(MyApp(settingsController: SettingsController(SettingsService())));

} 

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: LoginForm(),
    );
  }
}
