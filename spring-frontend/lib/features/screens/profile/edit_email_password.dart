import 'package:flutter/material.dart';
import 'package:spring/features/screens/profile/edit_profile.dart';
import 'package:spring/features/screens/profile_page.dart';
import 'package:spring/features/widgets/form_container_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class UpdateEmailPasswordScreen extends StatefulWidget {
  const UpdateEmailPasswordScreen({super.key});

  static const String routeName = '/Updateprofilepage';

  @override
  _UpdateEmailPasswordScreenState createState() =>
      _UpdateEmailPasswordScreenState();
}

class _UpdateEmailPasswordScreenState extends State<UpdateEmailPasswordScreen> {
  final GlobalKey<FormState> _editProfileKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String? _validateOldPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your old password';
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == oldPasswordController.text) {
      return 'New password cannot be the same as old password';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty && newPasswordController.text.isNotEmpty) {
      return 'Please confirm your new password';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
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
      emailController.text = userData['email'];
    });
  }

  Future<bool> editProfile() async {
    final String email = emailController.text;
    final String oldPassword = oldPasswordController.text;
    final String newPassword = newPasswordController.text;
    final String confirmPassword = confirmPasswordController.text;
    final user = FirebaseAuth.instance.currentUser!;

    try {
      if (email != user.email) {
        {
          final user = FirebaseAuth.instance.currentUser!;
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: oldPassword,
          );
          await user.reauthenticateWithCredential(credential);
          // User has been successfully reauthenticated

          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Email Verification'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('A verification email has been sent to $email to change your email address'), 
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
          await user.verifyBeforeUpdateEmail(email);
        }
      }
      if(newPassword.isNotEmpty){
        final user = FirebaseAuth.instance.currentUser!;
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: oldPassword,
          );
          await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'email': email,
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
                      controller: emailController,
                      hintText: "Email",
                      isPasswordField: false,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 20),
                    FormContainerWidget(
                      controller: oldPasswordController,
                      hintText: "Old Password",
                      isPasswordField: true,
                      validator: _validateOldPassword,
                    ),
                    const SizedBox(height: 20),
                    FormContainerWidget(
                      controller: newPasswordController,
                      hintText: "New Password (Leave Empty If Not Changing)",
                      isPasswordField: true,
                      validator: _validateNewPassword,
                    ),
                    const SizedBox(height: 20),
                    FormContainerWidget(
                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                      isPasswordField: true,
                      validator: _validateConfirmPassword,
                    ),
                     Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const UpdateProfileScreen()),
                                );
                              },
                              child: Text(
                                'Already have an account?',
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
                                    builder: (context) => const ProfilePage()),
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
