import 'dart:async';
import 'package:spring/features/firebase_auth_implementation/firebase_auth_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spring/features/widgets/bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final String displayName;
  const EmailVerificationScreen(
      {super.key,
      required this.email,
      required this.password,
      required this.name,
      required this.displayName});

  static const String routeName = '/emailverificationpage';

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      final currentUser = FirebaseAuth.instance.currentUser;
      final db = FirebaseFirestore.instance;

      db.collection('users').doc(currentUser?.uid).set({
        'id': currentUser?.uid,
        'name': widget.name,
        'displayName': widget.displayName,
        'email': widget.email,
      });
      Future.delayed(const Duration(seconds: 2));
      // TODO: implement your code after email verification
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
        (Route<dynamic> route) => false,
      );

      timer?.cancel();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Check your \n Email',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'We have sent you a Email on  ${auth.currentUser?.email}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'Verifying email....',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 57),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  child: const Text('Resend'),
                  onPressed: () {
                    try {
                      FirebaseAuth.instance.currentUser
                          ?.sendEmailVerification();
                    } catch (e) {
                      debugPrint('$e');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
