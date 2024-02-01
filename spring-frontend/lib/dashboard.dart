import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const String routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _darkMode = false;

  void _toggleDarkMode() {
    setState(() {
      _darkMode = !_darkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _darkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Dashboard'),
          actions: [
            Switch(
              value: _darkMode,
              onChanged: (value) {
                _toggleDarkMode();
              },
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildDashboardItem(
                context,
                'Sleep Monitoring',
                'Track your sleep patterns',
                Icons.bedtime,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SleepMonitoringScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildDashboardItem(
                context,
                'Mood Tracking',
                'Record your daily mood',
                Icons.mood,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MoodTrackingScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildDashboardItem(
                context,
                'Gratitude Journaling',
                'Express gratitude daily',
                Icons.sentiment_satisfied_alt,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GratitudeJournalingScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildDashboardItem(
                context,
                'Diary',
                'Write your thoughts',
                Icons.book,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DiaryScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    void Function() onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
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

void main() {
  runApp(const MaterialApp(
    home: Dashboard(),
  ));
}
