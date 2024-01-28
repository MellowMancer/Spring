import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SleepMonitoringScreen()),
                );
              },
              child: Text('Sleep Monitoring'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MoodTrackingScreen()),
                );
              },
              child: Text('Mood Tracking'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GratitudeJournalingScreen()),
                );
              },
              child: Text('Gratitude Journaling'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DiaryScreen()),
                );
              },
              child: Text('Diary'),
            ),
          ],
        ),
      ),
    );
  }
}

class SleepMonitoringScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Monitoring'),
      ),
      body: Center(
        child: Text('Sleep Monitoring Screen'),
      ),
    );
  }
}

class MoodTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Tracking'),
      ),
      body: Center(
        child: Text('Mood Tracking Screen'),
      ),
    );
  }
}

class GratitudeJournalingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gratitude Journaling'),
      ),
      body: Center(
        child: Text('Gratitude Journaling Screen'),
      ),
    );
  }
}

class DiaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diary'),
      ),
      body: Center(
        child: Text('Diary Screen'),
      ),
    );
  }
}
