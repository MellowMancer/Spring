import 'package:flutter/material.dart';
import 'package:spring/features/widgets/form_container_widget.dart';
import 'package:spring/features/user_auth/signup_page.dart';
import 'package:spring/features/widgets/bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String routeName = '/loginpage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Add more email validation logic here
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // Add more password validation logic here
    return null;
  }

  Future<bool> logIn() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Invalid Credentials"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 59, 85));
    return MaterialApp(
      theme:
      ThemeData(
        colorScheme: colorScheme,
        ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user != null) {
              // User is signed in, navigate to the home page
              return const BottomNavBar();
            }
          }
          // User is not signed in or the auth state is still loading, show the login page
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Spring Up Your Health!',
                  style: TextStyle(
                      fontSize:  24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              backgroundColor: colorScheme.primary,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:  10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                fontSize:  40,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height:  30),
                          FormContainerWidget(
                              controller: emailController,
                              hintText: "Email",
                              isPasswordField: false,
                              validator: _validateEmail),
                          const SizedBox(height:  15),
                          FormContainerWidget(
                              controller: passwordController,
                              hintText: "Password",
                              isPasswordField: true,
                              validator: _validatePassword),
                          const SizedBox(height:  15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpPage()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                child: Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(color: colorScheme.primary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height:  10),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // All fields are valid, proceed with signUp
                                bool isValid = await logIn();
                                if (isValid) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomNavBar()),
                                    (Route<dynamic> route) => false,
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Log In',
                                style: TextStyle(
                                    fontSize:  20, fontWeight: FontWeight.bold)),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
