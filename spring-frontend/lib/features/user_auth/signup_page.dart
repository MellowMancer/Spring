// import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:spring/features/user_auth/login_page.dart';
import 'package:spring/features/widgets/form_container_widget.dart';
import 'package:spring/features/widgets/bottom_navigation_bar.dart';
import 'package:spring/features/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spring/main.dart';
import 'package:spring/features/user_auth/email_verification_page.dart';

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

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // await FirebaseAuth.instance.signInWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );

      // final currentUser = FirebaseAuth.instance.currentUser;
      // final db = FirebaseFirestore.instance;

      // db.collection('users').doc(currentUser?.uid).set({
      //   'id': currentUser?.uid,
      //   'name': name,
      //   'displayName': displayName,
      //   'email': email,
      // });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("The password provided is too weak."),
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
      else if (e.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("This account already exists. Please login."),
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
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }

    // if (FirebaseAuth.instance.currentUser != null) {
    //   return true;
    // } else {
    //   // ignore: use_build_context_synchronously
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text('Error'),
    //         content: const SingleChildScrollView(
    //           child: ListBody(
    //             children: <Widget>[
    //               Text("Email already exists"),
    //             ],
    //           ),
    //         ),
    //         actions: <Widget>[
    //           TextButton(
    //             child: const Text('OK'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    //   return false;
    return true;

    // Send a POST request to the Flask signup endpoint
    // final response = await http.post(
    //   Uri.parse('http://10.0.2.2:5000/signup'),
    //   body: {
    //     'name': name,
    //     'displayName': displayName,
    //     'email': email,
    //     'password': password,
    //   },
    // );
    // if (response.statusCode == 200) {
    //   return true;
    // } else {
    //   var responseJson = json.decode(response.body);
    //   var errorMessage = responseJson['error'];
    //   // ignore: use_build_context_synchronously
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text('Error'),
    //         content: SingleChildScrollView(
    //           child: ListBody(
    //             children: <Widget>[
    //               Text("Email already exists"),
    //             ],
    //           ),
    //         ),
    //         actions: <Widget>[
    //           TextButton(
    //             child: const Text('OK'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    //   return false;
    // }
  }

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme.copyWith(
    //       primary: Color.fromARGB(255, 28, 76, 138), // Change the primary color
    //       secondary: Color.fromARGB(255, 39, 21, 169),
    //       tertiary: const Color.fromARGB(255, 12, 66, 172),
    //     );
    final colorScheme = Theme.of(context).colorScheme;
    final auth = FirebaseAuth.instance;

    return MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Spring Up Your Health!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            backgroundColor: colorScheme.primary,
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
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
                              child: Text(
                                'Already have an account?',
                                style: TextStyle(color: colorScheme.primary),
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
                                if (auth.currentUser != null) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EmailVerificationScreen(
                                                  email: emailController.text,
                                                  password: passwordController.text,
                                                  name: nameController.text,
                                                  displayName: displayNameController.text)));
                                }
                                // Navigator.pushAndRemoveUntil(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           const BottomNavBar()),
                                //   (Route<dynamic> route) => false,
                                // );
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
                          child: const Text('Sign Up',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ));
  }
}
