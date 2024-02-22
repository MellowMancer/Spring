import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/services.dart';

class CountdownTimer extends StatefulWidget {
  final int duration;
  final CountDownController controller;
  final String taskTitle;
  final Function? onChange;
  final Function? onComplete;

  CountdownTimer({
    super.key,
    required this.controller,
    required this.duration,
    required this.taskTitle,
    this.onChange,
    this.onComplete,
  });

  @override
  State<CountdownTimer> createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  int currentIndex = 0;
  static AudioPlayer player = new AudioPlayer();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CircularCountDownTimer(
      // Countdown duration in Seconds.
      duration: widget.duration,

      // Countdown initial elapsed Duration in Seconds.
      initialDuration: 0,

      // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
      controller: widget.controller,

      // Width of the Countdown Widget.
      width: MediaQuery.of(context).size.width / 2,

      // Height of the Countdown Widget.
      height: MediaQuery.of(context).size.height / 2,

      // Ring Color for Countdown Widget.
      ringColor: const Color.fromARGB(255, 255, 255, 255),

      // Ring Gradient for Countdown Widget.
      ringGradient: null,

      // Filling Color for Countdown Widget.
      fillColor: colorScheme.primaryContainer,

      // Filling Gradient for Countdown Widget.
      fillGradient: null,

      // Background Color for Countdown Widget.
      backgroundColor: colorScheme.primary,

      // Background Gradient for Countdown Widget.
      backgroundGradient: null,

      // Border Thickness of the Countdown Ring.
      strokeWidth: 20.0,

      // Begin and end contours with a flat edge and no extension.
      strokeCap: StrokeCap.round,

      // Text Style for Countdown Text.
      textStyle: const TextStyle(
        fontSize: 33.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),

      // Format for the Countdown Text.
      textFormat: CountdownTextFormat.S,

      // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
      isReverse: true,

      // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
      isReverseAnimation: true,

      // Handles visibility of the Countdown Text.
      isTimerTextShown: true,

      // Handles the timer start.
      autoStart: false,

      // This Callback will execute when the Countdown Starts.
      onStart: () {
        // Here, do whatever you want
        debugPrint('Countdown Started');
      },

      // This Callback will execute when the Countdown Ends.
      onComplete: () {
        final user = FirebaseAuth.instance.currentUser;
        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('tasks')
            .doc(widget.taskTitle)
            .set({'completed': true}, SetOptions(merge: true));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Daily Task Completed!')),
        );
        player.play(AssetSource('audio/simple-notification-152054.mp3'));
      },
      // This Callback will execute when the Countdown Changes.
      onChange: (String value) {
        // Here, do whatever you want with the value
        print('Countdown Changed: $value');
      },

      /* 
                  * Function to format the text.
                  * Allows you to format the current duration to any String.
                  * It also provides the default function in case you want to format specific moments
                    as in reverse when reaching '0' show 'GO', and for the rest of the instances follow 
                    the default behavior.
                */
      timeFormatterFunction: (defaultFormatterFunction, duration) {
        if (duration.inSeconds == 0) {
          return 0;
        } else {
          int remainingSeconds = duration.inSeconds;
          int hours = duration.inSeconds ~/ 3600;
          int minutes = (duration.inSeconds ~/ 60) % 60;
          int seconds = duration.inSeconds % 60;
          return '$hours:$minutes:$seconds';
        }
      },
    );
  }
}
