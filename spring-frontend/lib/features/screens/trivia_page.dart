import 'package:flutter/material.dart';

class TriviaPage extends StatefulWidget {
  const TriviaPage({super.key});

  static const String routeName = '/triviapage';

  @override
  State<TriviaPage> createState() => _TriviaPageState();
}

class _TriviaPageState extends State<TriviaPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Trivia Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 30),
          Text('Welcome to the Trivia Page'),
        ],
      ),
    );
  }
}
