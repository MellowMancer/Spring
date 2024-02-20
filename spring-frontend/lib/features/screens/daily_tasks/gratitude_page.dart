// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GratitudePage extends StatefulWidget {
  const GratitudePage({super.key});

  static const String routeName = '/gratitudepage';

  @override
  State<GratitudePage> createState() => _GratitudePageState();
}

class _GratitudePageState extends State<GratitudePage> {
  final TextEditingController gratitude1Controller = TextEditingController();
  final TextEditingController gratitude2Controller = TextEditingController();
  final TextEditingController gratitude3Controller = TextEditingController();

  Future<void> saveGratitudes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc('Note 3 events you are grateful for')
          .set({
        'completed': (gratitude1Controller.text.isNotEmpty &&
                gratitude2Controller.text.isNotEmpty &&
                gratitude3Controller.text.isNotEmpty)? true : false,
        'event_1': gratitude1Controller.text,
        'event_2': gratitude2Controller.text,
        'event_3': gratitude3Controller.text,
      }, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gratitudes saved!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save your gratitudes.')),
      );
    }
  }

  Future<void> getGratitudes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc('Note 3 events you are grateful for')
          .get();
      if (mounted) {
        setState(() {
          gratitude1Controller.text = userData['event_1'];
          gratitude2Controller.text = userData['event_2'];
          gratitude3Controller.text = userData['event_3'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getGratitudes();
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),
          title: Text("Gratitude", style: Theme.of(context).textTheme.headlineSmall),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text('Practice positive thinking by shifting our focus from what we lack to what we have. Write down 3 events that made you happy today!',
                      style: TextStyle(fontSize: 18, color: colorScheme.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: gratitude1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Gratitude 1',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: gratitude2Controller,
                    decoration: const InputDecoration(
                      labelText: 'Gratitude 2',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: gratitude3Controller,
                    decoration: const InputDecoration(
                      labelText: 'Gratitude 3',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: saveGratitudes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Save Gratitudes'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
