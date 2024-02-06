import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spring/features/widgets/form_container_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String routeName = '/Updateprofilepage';

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}


class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


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
              onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
          title: Text("Edit",
              style: Theme.of(context).textTheme.headlineSmall),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  
                  const SizedBox(height: 20),
                  FormContainerWidget(
                              controller: nameController,
                              hintText: "Name",

                              isPasswordField: false,),
                          const SizedBox(height: 15),
                          FormContainerWidget(
                              controller: displayNameController,
                              hintText: "Display Name",
                              isPasswordField: false,),
                          const SizedBox(height: 15),
                          FormContainerWidget(
                              controller: emailController,
                              hintText: "Email",
                              isPasswordField: false,),
                          const SizedBox(height: 15),
                          FormContainerWidget(
                              controller: passwordController,
                              hintText: "Password",
                              isPasswordField: true,),
                          const SizedBox(height: 15),
                          FormContainerWidget(
                              controller: confirmPasswordController,
                              hintText: "Confirm Password",
                              isPasswordField: true,),
                          ],
                          ),
                          ),
                          ),
        ),
                        ),
                        );
                        }
                        }
                    //     const SizedBox(height: 20),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // ignore: avoid_print
                    //     print("Update Profile");
                    //   },