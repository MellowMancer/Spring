import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:spring/features/widgets/countdown_timer.dart';
import 'dart:async';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  static const String routeName = '/exercisepage';

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  @override
  Widget build(BuildContext context) {
    const int duration = 1800;
    final CountDownController controller = CountDownController();
    int currentStepIndex = 0;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final List<String> exerciseSteps = [
      'Step  1: Warm-up for 1-2 minutes by stretching and jogging in place',
      'Step  2: Do 10 push-ups',
      'Step  3: Perform 10 squats',
      'Step  4: Do a plank for 30 seconds',
      'Step  5: Rest for 1 minute',
      'Step  6: Repeat steps 2-5 three times',
    ];

    return MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back)),
            title: Text("Exercise",
                style: Theme.of(context).textTheme.headlineSmall),
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(seconds: 1),
                    onEnd: () {
                      setState(() {
                        bool isVisible = false;
                        isVisible = !isVisible;
                      });
                    },
                    child: Text(
                      exerciseSteps[currentStepIndex],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("",
                      style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold)),
                  CountdownTimer(
                      controller: controller,
                      duration: duration,
                      taskTitle: "Exercise for 30 minutes",
                      onChange: (String timeStamp) {
                        int remainingSeconds =
                            int.parse(timeStamp.split(':').last);
                        if (remainingSeconds == 60 ||
                            remainingSeconds == 50 ||
                            remainingSeconds == 40 ||
                            remainingSeconds == 30) {
                          setState(() {
                            currentStepIndex++;
                          });
                        }
                      }),
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
                onPressed: () => [controller.start()],
              ),
              const SizedBox(
                width: 10,
              ),
              _button(
                title: "Pause",
                onPressed: () => [controller.pause()],
              ),
              const SizedBox(
                width: 10,
              ),
              _button(
                title: "Resume",
                onPressed: () => [controller.resume()],
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ));
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