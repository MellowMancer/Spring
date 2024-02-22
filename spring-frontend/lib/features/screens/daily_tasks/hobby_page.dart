import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:spring/features/widgets/countdown_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HobbyPage extends StatefulWidget {
  const HobbyPage({super.key});

  static const String routeName = '/hobbypage';

  @override
  State<HobbyPage> createState() => _HobbyPageState();
}

class _HobbyPageState extends State<HobbyPage> {
  @override
  Widget build(BuildContext context) {
    final int _duration = 10;
    final CountDownController _controller = CountDownController();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),
          title:
              Text("Hobby", style: Theme.of(context).textTheme.headlineSmall),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                    "Engage in a hobby that you enjoy. This can be anything from painting, playing an instrument, or even gardening. Doing something you love can help reduce stress and improve your overall mood. You deserve it!",
                    style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold)),
                CountdownTimer(
                  controller: _controller,
                  duration: _duration,
                  taskTitle: "Indulge in a hobby",
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 30,
            ),
            _button(
              title: "Start",
              onPressed: () => _controller.start(),
            ),
            const SizedBox(
              width: 10,
            ),
            _button(
              title: "Pause",
              onPressed: () => _controller.pause(),
            ),
            const SizedBox(
              width: 10,
            ),
            _button(
              title: "Resume",
              onPressed: () => _controller.resume(),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _button({required String title, VoidCallback? onPressed}) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(colorScheme.primary),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
