import 'package:flutter/material.dart';
import 'package:spring/features/screens/profile/edit_email_password.dart';
import 'package:spring/features/screens/profile_page.dart';
import 'package:spring/features/widgets/bottom_navigation_bar.dart';
import 'package:spring/features/widgets/form_container_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String routeName = '/Updateprofilepage';

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> _editProfileKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateDisplayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Display Name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  }

  Future<void> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    setState(() {
      nameController.text = userData['name'];
      displayNameController.text = userData['displayName'];
      emailController.text = userData['email'];
    });
  }

  Future<bool> editProfile() async {
    final String name = nameController.text;
    final String displayName = displayNameController.text;
    final user = FirebaseAuth.instance.currentUser!;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'name': name,
        'displayName': displayName,
      });
      return true;
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(e.toString()),
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
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),
          title: Text("Edit", style: Theme.of(context).textTheme.headlineSmall),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _editProfileKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    FormContainerWidget(
                      controller: nameController,
                      hintText: "Name",
                      isPasswordField: false,
                      validator: _validateName,
                    ),
                    const SizedBox(height: 30),
                    FormContainerWidget(
                      controller: displayNameController,
                      hintText: "Display Name",
                      isPasswordField: false,
                      validator: _validateDisplayName,
                    ),
                    const SizedBox(height: 30),
                     Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const UpdateEmailPasswordScreen()),
                                );
                              },
                              child: Text(
                                'Edit Email and/or Password?',
                                style: TextStyle(color: colorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (_editProfileKey.currentState!.validate()) {
                          // All fields are valid, proceed with editProfile
                          bool isValid = await editProfile();
                          if (isValid) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BottomNavBar()),
                                (Route<dynamic> route) => false);
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
                      child: const Text('Update Profile',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
