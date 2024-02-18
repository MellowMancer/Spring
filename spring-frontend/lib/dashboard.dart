import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: Dashboard(),
  ));
}

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
          title: const Text('Homepage'),
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
          color: _darkMode ? Colors.grey[900] ?? Colors.black : Colors.white,
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
                    MaterialPageRoute(builder: (context) => SleepMonitoringScreen()),
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
                    MaterialPageRoute(builder: (context) => MoodTrackingScreen()),
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
                    MaterialPageRoute(builder: (context) => GratitudeJournalingScreen()),
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
                    MaterialPageRoute(builder: (context) => DiaryScreen()),
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
          color: _darkMode ? Colors.grey[800] ?? Colors.black : Colors.grey[200] ?? Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: _darkMode ? Colors.grey[700] ?? Colors.black : Colors.grey[400] ?? Colors.black,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: 40,
              color: _darkMode ? Colors.white : Colors.black,
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
                    color: _darkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: _darkMode ? Colors.white70 : Colors.black87,
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

// Mood Tracking Screen
class MoodTrackingScreen extends StatelessWidget {
  const MoodTrackingScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'How are you feeling today?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMoodButton(context, "😄", "Happy", Colors.yellow),
                _buildMoodButton(context, "😊", "Content", Colors.green),
                _buildMoodButton(context, "😐", "Neutral", Colors.blueGrey),
                _buildMoodButton(context, "😢", "Sad", Colors.blue),
                _buildMoodButton(context, "😡", "Angry", Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodButton(BuildContext context, String emoji, String label, Color color) {
    return ElevatedButton(
      onPressed: () {
        _showSelectedMoodDialog(context, emoji, label);
      },
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(24),
      ),
      child: Text(
        emoji,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showSelectedMoodDialog(BuildContext context, String emoji, String moodLabel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'You\'re feeling $moodLabel!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: TextStyle(fontSize: 64),
              ),
              SizedBox(height: 20),
              Text(
                'That\'s awesome!',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Sleep Monitoring Screen
class SleepMonitoringScreen extends StatefulWidget {
  const SleepMonitoringScreen({Key? key});

  @override
  _SleepMonitoringScreenState createState() => _SleepMonitoringScreenState();
}

class _SleepMonitoringScreenState extends State<SleepMonitoringScreen> {
  int _hoursSlept = 0;
  double _sleepProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Monitoring'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'How many hours did you sleep?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Slider(
              value: _hoursSlept.toDouble(),
              min: 0,
              max: 12,
              divisions: 12,
              onChanged: (value) {
                setState(() {
                  _hoursSlept = value.toInt();
                  _sleepProgress = value / 12;
                });
              },
              label: '$_hoursSlept',
            ),
            SizedBox(height: 20),
            Text(
              '$_hoursSlept hours',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              value: _sleepProgress,
              strokeWidth: 10,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _calculateSleepQuality(_hoursSlept);
              },
              child: Text('Calculate Sleep Quality'),
            ),
          ],
        ),
      ),
    );
  }

  void _calculateSleepQuality(int hoursSlept) {
    String qualityDescription = '';
    if (hoursSlept >= 8) {
      qualityDescription = 'Excellent';
    } else if (hoursSlept >= 6) {
      qualityDescription = 'Good';
    } else if (hoursSlept >= 4) {
      qualityDescription = 'Fair';
    } else {
      qualityDescription = 'Poor';
    }
    _showSnackBar(context, 'Sleep Quality: $qualityDescription');
  }
}

// Gratitude Journaling Screen
class GratitudeJournalingScreen extends StatelessWidget {
  const GratitudeJournalingScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gratitude Journaling'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Today\'s Gratitude',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'What are you grateful for today?',
                contentPadding: EdgeInsets.all(20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showSnackBar(context, 'Gratitude recorded!');
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

// Diary Screen
class DiaryScreen extends StatefulWidget {
  const DiaryScreen({Key? key});

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  late String _currentDate;
  late String _currentTime;

  @override
  void initState() {
    super.initState();
    _initializeDateTime();
  }

  void _initializeDateTime() {
    _updateDateTime();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _updateDateTime();
      });
    });
  }

  void _updateDateTime() {
    final now = DateTime.now();
    _currentDate = DateFormat.yMMMMd().format(now); // Example format: January 1, 2023
    _currentTime = DateFormat.Hm().format(now); // Example format: 12:00 PM
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your Personal Diary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Date: $_currentDate\nTime: $_currentTime',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Expanded(
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Dear Diary...',
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showSnackBar(context, 'Diary entry saved!');
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    ),
  );
}
