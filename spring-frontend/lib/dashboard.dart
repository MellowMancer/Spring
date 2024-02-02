import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Dashboard(),
  ));
}

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
                    MaterialPageRoute(builder: (context) => SleepMonitoringScreen()),
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
                    MaterialPageRoute(builder: (context) => MoodTrackingScreen()),
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
                    MaterialPageRoute(builder: (context) => GratitudeJournalingScreen()),
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
        padding: const EdgeInsets.all(20.0),
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
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _darkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
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

class SleepMonitoringScreen extends StatefulWidget {
  const SleepMonitoringScreen({Key? key});

  @override
  _SleepMonitoringScreenState createState() => _SleepMonitoringScreenState();
}

class _SleepMonitoringScreenState extends State<SleepMonitoringScreen> {
  int _hoursSlept = 0;
  String _qualityDescription = '';

  void _calculateSleepQuality() {
    if (_hoursSlept >= 8) {
      setState(() {
        _qualityDescription = 'Excellent';
      });
    } else if (_hoursSlept >= 6) {
      setState(() {
        _qualityDescription = 'Good';
      });
    } else if (_hoursSlept >= 4) {
      setState(() {
        _qualityDescription = 'Fair';
      });
    } else {
      setState(() {
        _qualityDescription = 'Poor';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Monitoring'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Hours Slept',
              ),
              onChanged: (value) {
                setState(() {
                  _hoursSlept = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _calculateSleepQuality();
              },
              child: Text('Calculate Sleep Quality'),
            ),
            SizedBox(height: 20),
            _qualityDescription.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        'Sleep Quality: $_qualityDescription',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SleepReportScreen(hoursSlept: _hoursSlept)),
                          );
                        },
                        child: Text('View Detailed Report'),
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class SleepReportScreen extends StatelessWidget {
  final int hoursSlept;

  SleepReportScreen({required this.hoursSlept});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Detailed Sleep Report',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'You slept for $hoursSlept hours last night.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // Add more details or analytics here
          ],
        ),
      ),
    );
  }
}

class MoodTrackingScreen extends StatefulWidget {
  const MoodTrackingScreen({Key? key});

  @override
  _MoodTrackingScreenState createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends State<MoodTrackingScreen> {
  List<String> moods = ['Happy', 'Content', 'Neutral', 'Sad', 'Angry'];

  String selectedMood = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracking'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'How are you feeling today?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: moods
                .map(
                  (mood) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMood = mood;
                      });
                      // You can add logic here to save the mood entry
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selectedMood == mood ? Colors.blue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _getMoodIcon(mood),
                            size: 60,
                            color: selectedMood == mood ? Colors.white : Colors.black,
                          ),
                          SizedBox(height: 10),
                          Text(
                            mood,
                            style: TextStyle(
                              color: selectedMood == mood ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add logic here to save mood entry with notes
            },
            child: Text('Save Mood'),
          ),
        ],
      ),
    );
  }

  IconData _getMoodIcon(String mood) {
    switch (mood) {
      case 'Happy':
        return Icons.sentiment_very_satisfied;
      case 'Content':
        return Icons.sentiment_satisfied;
      case 'Neutral':
        return Icons.sentiment_neutral;
      case 'Sad':
        return Icons.sentiment_dissatisfied;
      case 'Angry':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.sentiment_neutral;
    }
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Oh I had such an amazing day today....',
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
              ),
            ),
          ],
        ),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Personal Diary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/diary_bg.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write your thoughts...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
