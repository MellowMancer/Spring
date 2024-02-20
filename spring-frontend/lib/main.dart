// ignore_for_file: unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spring/features/app/splashscreen/splashscreen.dart';
import 'package:spring/features/user_auth/login_page.dart';
import 'package:spring/features/screens/home_page.dart';
import 'package:spring/features/user_auth/signup_page.dart';
import 'package:spring/features/screens/chatbot_screen.dart';

// import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCYe3ASqwa3ahPVYy8uXYfr9K0C6i2zRVw",
          authDomain: "spring-a-ling.firebaseapp.com",
          databaseURL:
              "https://spring-a-ling-default-rtdb.asia-southeast1.firebasedatabase.app",
          projectId: "spring-a-ling",
          storageBucket: "spring-a-ling.appspot.com",
          messagingSenderId: "610922772594",
          appId: "1:610922772594:web:e33e3664db737349f82aeb",
          measurementId: "G-869YBQ6538"),
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(MyApp(settingsController: SettingsController(SettingsService())));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.settingsController});

  final SettingsController settingsController;
  final ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 132, 0, 255));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        // routes: {
        //   '/login': (context) => LoginPage(),
        //   '/home': (context) => HomePage(),
        //   '/signup': (context) => SignUpPage(),
        //   '/chatbot': (context) => ChatScreen(),
        // },

        theme: ThemeData.from(colorScheme: colorScheme),
        

        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        // home: LoginForm(),
        home: SplashScreen(child: LoginPage())
    );
  }
}
