import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spring/features/widgets/profile_menu_widget.dart';
import 'package:spring/features/screens/profile/edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spring/features/user_auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static const String routeName = '/profilepage';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = "";
  String _displayName = "";
  DateTime _targetBedtime = DateTime.now();
  DateTime _targetWakeupTime = DateTime.now();
  TextEditingController _bedtimeController = TextEditingController();
  TextEditingController _wakeupTimeController = TextEditingController();

  Future<void> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (mounted) {
        setState(() {
          _name = userData['name'];
          _displayName = userData['displayName'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Method to show the popup dialog for setting bedtime and wakeup time
  void _showSetTimeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Bedtime and Wakeup Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Target Bedtime Input
              TextFormField(
                controller: _bedtimeController,
                decoration: InputDecoration(
                  labelText: 'Target Bedtime',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _bedtimeController.text = picked.format(context);
                          _targetBedtime = DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            picked.hour,
                            picked.minute,
                          );
                        });
                      }
                    },
                  ),
                ),
              ),
              // Target Wakeup Time Input
              TextFormField(
                controller: _wakeupTimeController,
                decoration: InputDecoration(
                  labelText: 'Target Wakeup Time',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _wakeupTimeController.text = picked.format(context);
                          _targetWakeupTime = DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            picked.hour,
                            picked.minute,
                          );
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .set({
                  'targetBedtime': _targetBedtime,
                  'targetWakeupTime': _targetWakeupTime,
                }, SetOptions(merge: true));
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    _getUserData();
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Profile", style: Theme.of(context).textTheme.headline6),
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
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(_name, style: Theme.of(context).textTheme.headline6),
                Text("@$_displayName", style: Theme.of(context).textTheme.bodyText1),
                const SizedBox(height: 20),
                // Edit Profile Button
                ProfileMenuWidget(
                  title: "Edit Profile",
                  icon: Icons.edit,
                  textColor: colorScheme.primary,
                  endIcon: false,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpdateProfileScreen()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                // Set Bedtime and Wakeup Time Widget
                ProfileMenuWidget(
                  title: "Set Bedtime and Wakeup Time",
                  icon: Icons.access_time,
                  textColor: colorScheme.primary,
                  endIcon: false,
                  onPress: _showSetTimeDialog,
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                // Logout Widget
                ProfileMenuWidget(
                  title: "Logout",
                  icon: const IconData(0xf88b, fontFamily: 'MaterialIcons'),
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Log Out'),
                          content: const SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text("Are you sure, you want to Logout?"),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                // ignore: use_build_context_synchronously
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                  (route) => false,
                                );
                              },
                            ),
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: Text('Edit Profile Screen'),
      ),
    );
  }
}

void main() {
  runApp(ProfilePage());
}
