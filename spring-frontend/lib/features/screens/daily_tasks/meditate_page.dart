import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:spring/features/widgets/countdown_timer.dart';
import 'package:gif_view/gif_view.dart';

class MeditatePage extends StatefulWidget {
  const MeditatePage({super.key});

  static const String routeName = '/meditatepage';

  @override
  State<MeditatePage> createState() => _MeditatePageState();
}

class _MeditatePageState extends State<MeditatePage> {
  @override
  Widget build(BuildContext context) {
    const int duration = 1800;
    final CountDownController controller = CountDownController();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String meditateSteps =
      'Step  1: Find a quiet place to sit or lie down \nStep  2: Close your eyes and take deep breaths \nStep  3: Focus on your breath and clear your mind \nStep  4: Continue for 30 minutes';
    final List<String> assetList = [
      'assets/images/pets/cat/cat_default.gif',
      'assets/images/pets/cat/cat_meditate.gif',
    ];
    int index = 0;
    

    return MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back)),
            title: Text("Meditate",
                style: Theme.of(context).textTheme.headlineSmall),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text("Ease your mind with meditation",
                        style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold)),
                    GifView.asset(
                      assetList[1],
                      height:   200,
                      width:   200,
                      frameRate:   10,
                    ),
                    CountdownTimer(
                      controller: controller,
                      duration: duration,
                      taskTitle: "Meditate for 30 minutes",
                    ),
                    Text(
                      meditateSteps,
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 40,
              ),
              _button(
                title: "Start",
                onPressed: () => [controller.start(),setState(() {
                index = 1;
                debugPrint('Index updated to: $index'); // Debug print the new index value
      })],
              ),
              const SizedBox(
                width: 10,
              ),
              _button(
                title: "Pause",
                onPressed: () => [controller.pause(), setState(() {
                index = 0;
                debugPrint('Index updated to: $index'); // Debug print the new index value
      })],
              ),
              const SizedBox(
                width: 10,
              ),
              _button(
                title: "Resume",
                onPressed: () => [controller.resume(), setState(() {
                index = 1;
                debugPrint('Index updated to: $index'); // Debug print the new index value
      })],
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
