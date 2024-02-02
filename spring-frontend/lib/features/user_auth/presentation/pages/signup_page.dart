import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spring/features/user_auth/presentation/pages/login_page.dart';
import 'package:spring/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:spring/features/user_auth/presentation/pages/home_page.dart';
import 'package:spring/features/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:logger/logger.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const String routeName = '/signuppage';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  TextEditingController nameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    displayNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('Sign Up',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            FormContainerWidget(
                controller: nameController,
                hintText: "Name",
                isPasswordField: false),
            const SizedBox(height: 15),
            FormContainerWidget(
                controller: displayNameController,
                hintText: "Display Name",
                isPasswordField: false),
            const SizedBox(height: 15),
            FormContainerWidget(
                controller: emailController,
                hintText: "Email",
                isPasswordField: false),
            const SizedBox(height: 15),
            FormContainerWidget(
                controller: passwordController,
                hintText: "Password",
                isPasswordField: true),
            const SizedBox(height: 15),
            FormContainerWidget(
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                isPasswordField: true),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _signUp, // Assign the _signUp function here
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
              ),
              child: const Text('Sign Up',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
          ]),
        ),
      ),
    );
  }

  void _signUp() async {
    // final String name = nameController.text;
    // final String displayName = displayNameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    // final String confirmPassword = confirmPasswordController.text;

    print("Im signing up");

    UserCredential? user =
        await _auth.createUserWithEmailAndPassword(email, password);
    if (user != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (Route<dynamic> route) => false,
                  );
    } else {
      print('User creation failed');
    }
  }
}
