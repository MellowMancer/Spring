import 'package:flutter/material.dart';

class PetPage extends StatefulWidget {
  const PetPage({super.key});

  static const String routeName = '/petpage';

  @override
  State<PetPage> createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Pet Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 30),
          Text('Welcome to the Pet Page'),
        ],
      ),
    );
  }
}