import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

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
          padding: EdgeInsets.all(20.0),
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
              SizedBox(height: 20),
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
              SizedBox(height: 20),
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
              SizedBox(height: 20),
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
        padding: EdgeInsets.all(20.0),
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
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
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
  const SleepMonitoringScreen({Key? key});

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
  const MoodTrackingScreen({Key? key});

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
  const GratitudeJournalingScreen({Key? key});

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
  const DiaryScreen({Key? key});

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
  runApp(MaterialApp(
    home: Dashboard(),
  ));
}
