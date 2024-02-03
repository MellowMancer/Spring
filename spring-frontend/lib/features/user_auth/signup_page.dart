// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spring/features/user_auth/login_page.dart';
import 'package:spring/features/widgets/form_container_widget.dart';
import 'package:spring/features/pages/home_page.dart';
import 'package:spring/features/widgets/bottom_navigation_bar.dart';
// import 'package:spring/features/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const String routeName = '/signuppage';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // final FirebaseAuthServices _auth = FirebaseAuthServices();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    // Add more name validation logic here
    return null;
  }

  String? _validateDisplayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Display Name';
    }
    // Add more email validation logic here
    return null;
  }

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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<bool> signUp() async {
    final String name = nameController.text;
    final String displayName = displayNameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    // Send a POST request to the Flask signup endpoint
    final response = await http.post(
      Uri.parse('http://192.168.29.128:4000/signup'),
      body: {
        'name': name,
        'displayName': displayName,
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      var responseJson = json.decode(response.body);
      var errorMessage = responseJson['error'];
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(errorMessage),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sign Up',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    FormContainerWidget(
                        controller: nameController,
                        hintText: "Name",
                        isPasswordField: false,
                        validator: _validateName),
                    const SizedBox(height: 15),
                    FormContainerWidget(
                        controller: displayNameController,
                        hintText: "Display Name",
                        isPasswordField: false,
                        validator: _validateDisplayName),
                    const SizedBox(height: 15),
                    FormContainerWidget(
                        controller: emailController,
                        hintText: "Email",
                        isPasswordField: false,
                        validator: _validateEmail),
                    const SizedBox(height: 15),
                    FormContainerWidget(
                        controller: passwordController,
                        hintText: "Password",
                        isPasswordField: true,
                        validator: _validatePassword),
                    const SizedBox(height: 15),
                    FormContainerWidget(
                        controller: confirmPasswordController,
                        hintText: "Confirm Password",
                        isPasswordField: true,
                        validator: _validateConfirmPassword),
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // All fields are valid, proceed with signUp
                          bool isValid = await signUp();
                          if (isValid) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BottomNavBar()),
                              (Route<dynamic> route) => false,
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Sign Up',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
