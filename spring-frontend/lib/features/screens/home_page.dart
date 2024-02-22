import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedMood = -1; // -1 indicates no mood selected

  void _selectMood(int mood) {
    setState(() {
      _selectedMood = mood;
    });
  }

  void _openWindow(BuildContext context, Widget windowContent) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => windowContent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(
          "Home",
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Home Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text(
              'What is your mood today?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMoodButton(
                    0, Icons.sentiment_very_satisfied, 'Happy', colorScheme),
                _buildMoodButton(
                    1, Icons.sentiment_neutral, 'Neutral', colorScheme),
                _buildMoodButton(
                    2, Icons.sentiment_very_dissatisfied, 'Sad', colorScheme),
              ],
            ),
            const SizedBox(height: 30),
            ...List.generate(3, (index) {
              String buttonText;
              String description;
              IconData buttonIcon;
              Widget windowContent;
              switch (index) {
                case 0:
                  buttonText = 'Sleep Tracking';
                  description = 'Track your sleep patterns';
                  buttonIcon = Icons.bedtime;
                  windowContent = SleepTrackingWindow();
                  break;
                case 1:
                  buttonText = 'Mood Tracking';
                  description = 'Track your mood over time';
                  buttonIcon = Icons.mood;
                  windowContent = MoodTrackingWindow();
                  break;
                case 2:
                  buttonText = 'Diary';
                  description = 'Write your thoughts and experiences';
                  buttonIcon = Icons.book;
                  windowContent = DiaryWindow();
                  break;
                default:
                  buttonText = 'Button ${index + 1}';
                  description = 'Default button description';
                  buttonIcon = Icons.star;
                  windowContent = DefaultWindow();
              }
              return SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.9, //  90% of screen width
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () => _openWindow(context, windowContent),
                  icon: Icon(buttonIcon),
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        buttonText,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: colorScheme.onPrimaryContainer,
                    backgroundColor: colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                  ),
                ),
              );
            }).expand((button) => [button, const SizedBox(height: 10)]),
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildMoodButton(
      int mood, IconData icon, String label, ColorScheme colorScheme) {
    return ElevatedButton.icon(
      onPressed: () => _selectMood(mood),
      icon: Icon(icon, color: _selectedMood == mood
            ? colorScheme.onPrimary
            : colorScheme.onSurface,),
      label: Text(label, style: TextStyle(color: _selectedMood == mood
            ? colorScheme.onPrimary
            : colorScheme.onSurface,)),
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedMood == mood
            ? colorScheme.primary
            : colorScheme.surface,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center, // This aligns the text vertically
      ),
    );
  }
}

class SleepTrackingWindow extends StatefulWidget {
  @override
  _SleepTrackingWindowState createState() => _SleepTrackingWindowState();
}

class _SleepTrackingWindowState extends State<SleepTrackingWindow> {
  TimeOfDay _bedtime = TimeOfDay.now();
  TimeOfDay _wakeupTime = TimeOfDay.now();
  String _sleepQuality = '';
  String _hoursSlept = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Tracking Window'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bedtime:',
                  style: TextStyle(fontSize: 18),
                ),
                ElevatedButton(
                  onPressed: () => _selectTime(context, true),
                  child: Text(
                    _formatTime(_bedtime),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Wakeup Time:',
                  style: TextStyle(fontSize: 18),
                ),
                ElevatedButton(
                  onPressed: () => _selectTime(context, false),
                  child: Text(
                    _formatTime(_wakeupTime),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateSleepQuality,
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            Text(
              _sleepQuality,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              _hoursSlept,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isBedtime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isBedtime ? _bedtime : _wakeupTime,
    );
    if (picked != null && picked != (isBedtime ? _bedtime : _wakeupTime)) {
      setState(() {
        if (isBedtime) {
          _bedtime = picked;
        } else {
          _wakeupTime = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _calculateSleepQuality() {
    final bedtimeMinutes = _bedtime.hour * 60 + _bedtime.minute;
    final wakeupTimeMinutes = _wakeupTime.hour * 60 + _wakeupTime.minute;
    final hoursSlept = ((wakeupTimeMinutes - bedtimeMinutes) / 60).round();

    setState(() {
      if (hoursSlept >= 7 && hoursSlept <= 9) {
        _sleepQuality = 'You slept well!';
      } else {
        _sleepQuality =
            'You should aim for 7-9 hours of sleep for better health.';
      }
      _hoursSlept = 'You slept for $hoursSlept hours.';
    });
  }
}

class MoodTrackingWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracking Window'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Mood Tracking Window'),
            // Add more UI elements specific to mood tracking
          ],
        ),
      ),
    );
  }
}

class GratitudeJournalingWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gratitude Journaling Window'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Gratitude Journaling Window'),
            // Add more UI elements specific to gratitude journaling
          ],
        ),
      ),
    );
  }
}

class DiaryWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Window'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Diary Window'),
            // Add more UI elements specific to diary
          ],
        ),
      ),
    );
  }
}

class DefaultWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Default Window'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Default Window'),
            // Add more UI elements for the default window
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}
