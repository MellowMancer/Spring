// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KindnessPage extends StatefulWidget {
  const KindnessPage({super.key});

  static const String routeName = '/kindnesspage';

  @override
  State<KindnessPage> createState() => _KindnessPageState();
}

class _KindnessPageState extends State<KindnessPage> {
  final TextEditingController kindness1Controller = TextEditingController();
  final TextEditingController kindness2Controller = TextEditingController();
  final TextEditingController kindness3Controller = TextEditingController();

  Future<void> saveKkindnes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc('Perform 3 acts of kindness')
          .set({
        'completed': (kindness1Controller.text.isNotEmpty &&
                kindness2Controller.text.isNotEmpty &&
                kindness3Controller.text.isNotEmpty),
        'event_1': kindness1Controller.text,
        'event_2': kindness2Controller.text,
        'event_3': kindness3Controller.text,
      }, SetOptions(merge: true));
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
            'date': DateTime.now()
          }, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kindness Acts Saved!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save your Acts')),
      );
    }
  }

  Future<void> getKkindnes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc('Perform 3 acts of kindness')
          .get();
      if (mounted) {
        setState(() {
          kindness1Controller.text = userData['event_1'];
          kindness2Controller.text = userData['event_2'];
          kindness3Controller.text = userData['event_3'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getKkindnes();
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
          title: Text("Kindness",
              style: Theme.of(context).textTheme.headlineSmall),
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
                  Text(
                      "Bring a smile to other people's faces by performing acts of kindness. You can do this by helping someone in need, giving a compliment, or simply being there for someone who needs you.",
                      style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: kindness1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Kindness 1',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: kindness2Controller,
                    decoration: const InputDecoration(
                      labelText: 'Kindness 2',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: kindness3Controller,
                    decoration: const InputDecoration(
                      labelText: 'Kindness 3',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: saveKkindnes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Save'),
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
