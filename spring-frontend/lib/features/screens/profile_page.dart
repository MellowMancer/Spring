import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spring/features/widgets/profile_menu_widget.dart';
import 'package:spring/features/screens/profile/edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const String routeName = '/profilepage';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = "Hllo";
  String _displayName = "Hello";

  Future<void> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    setState(() {
      _name = userData['name'];
      _displayName = userData['displayName'];
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    _getUserData();
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title:
              Text("Profile", style: Theme.of(context).textTheme.headlineSmall),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      // Positioned(
                      //   bottom: 0,
                      //   right: 0,
                      // child: Container(
                      //   width: 35,
                      //   height: 35,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(100),
                      //       color: colorScheme.primary),
                      //   child: const Icon(
                      //     Icons.edit,
                      //     color: Colors.black,
                      //     size: 20,
                      //   ),
                      // ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(_name, style: Theme.of(context).textTheme.headlineMedium),
                Text("@$_displayName",
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 20),

                /// -- BUTTON
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateProfileScreen()),
                                );
                              },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        side: BorderSide.none,
                        shape: const StadiumBorder()),
                    child: const Text("Edit Profile",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),

                /// -- MENU
                ProfileMenuWidget(
                    title: "Settings",
                    icon: const IconData(0xe900, fontFamily: 'settings'),
                    onPress: () {}),
                const Divider(),
                const SizedBox(height: 10),
                ProfileMenuWidget(
                    title: "Logout",
                    icon: const IconData(0xe900, fontFamily: 'logout'),
                    textColor: Colors.red,
                    endIcon: false,
                    onPress: () {
                      Get.defaultDialog(
                        title: "LOGOUT",
                        titleStyle: const TextStyle(fontSize: 20),
                        content: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          child: Text("Are you sure, you want to Logout?"),
                        ),
                        confirm: Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                "Logout Functionality goes here...",
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                side: BorderSide.none),
                            child: const Text("Yes"),
                          ),
                        ),
                        cancel: OutlinedButton(
                            onPressed: () => Get.back(),
                            child: const Text("No")),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
