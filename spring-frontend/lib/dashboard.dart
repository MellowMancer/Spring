import 'package:flutter/material.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const String routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SleepMonitoringScreen()),
                );
              },
              child: const Text('Sleep Monitoring'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MoodTrackingScreen()),
                );
              },
              child: const Text('Mood Tracking'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GratitudeJournalingScreen()),
                );
              },
              child: const Text('Gratitude Journaling'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DiaryScreen()),
                );
              },
              child: const Text('Diary'),
            ),
          ],
        ),
      ),
    );
  }
}

class SleepMonitoringScreen extends StatelessWidget {
  const SleepMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Monitoring'),
      ),
      body: const Center(
        child: Text('Sleep Monitoring Screen'),
      ),
    );
  }
}

class MoodTrackingScreen extends StatelessWidget {
  const MoodTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracking'),
      ),
      body: const Center(
        child: Text('Mood Tracking Screen'),
      ),
    );
  }
}

class GratitudeJournalingScreen extends StatelessWidget {
  const GratitudeJournalingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gratitude Journaling'),
      ),
      body: const Center(
        child: Text('Gratitude Journaling Screen'),
      ),
    );
  }
}

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary'),
      ),
      body: const Center(
        child: Text('Diary Screen'),
      ),
    );
  }
}
