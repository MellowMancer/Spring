import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
//

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedMood = -1; // -1 indicates no mood selected

  void _selectMood(int mood) {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _selectedMood = mood;
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('mood')
          .doc('mood${DateFormat('y-MM-dd').format(DateTime.now())}')
          .set({
        'mood': mood,
        'date': DateTime.now(),
      }, SetOptions(merge: true));
      // _updateMoodData(); // Update mood data when mood is selected
    });
  }

  // void _updateMoodData() {
  //   // Update mood data based on the selected mood and current day
  //   final DateTime now = DateTime.now();
  //   final DateFormat formatter = DateFormat('d'); // Format to get only the date
  //   final String formattedDay = formatter.format(now);

  // }

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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(
          "Home",
          style: Theme.of(context).textTheme.titleLarge,
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
                  windowContent = const SleepTrackingWindow();
                  break;
                case 1:
                  buttonText = 'Mood Tracking';
                  description = 'Track your mood over time';
                  buttonIcon = Icons.mood;
                  windowContent = const MoodTrackingWindow();
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
      icon: Icon(
        icon,
        color: _selectedMood == mood
            ? colorScheme.onPrimary
            : colorScheme.onSurface,
      ),
      label: Text(label,
          style: TextStyle(
            color: _selectedMood == mood
                ? colorScheme.onPrimary
                : colorScheme.onSurface,
          )),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _selectedMood == mood ? colorScheme.primary : colorScheme.surface,
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
  const SleepTrackingWindow({super.key});

  static const String routeName = '/sleeptrackingpage';

  @override
  _SleepTrackingWindowState createState() => _SleepTrackingWindowState();
}

class _SleepTrackingWindowState extends State<SleepTrackingWindow> {
  TimeOfDay _bedtime = TimeOfDay.now();
  TimeOfDay _wakeupTime = TimeOfDay.now();
  String _sleepQuality = '';
  String _hoursSlept = '';
  final List<double> _sleepData = [];
  final List<String> _sleepNotes = [];

  // Sleep Goals
  final TimeOfDay _targetBedtime =
      const TimeOfDay(hour: 22, minute: 0); // Default target bedtime
  final TimeOfDay _targetWakeupTime =
      const TimeOfDay(hour: 7, minute: 0); // Default target wakeup time

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Tracking Window'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sleep Goals
            _buildSectionTitle('Sleep Goals:'),
            _buildSleepGoals(),
            const SizedBox(height: 20),

            // Input Fields: Bedtime, Wakeup Time, Submit Button, Sleep Tracking Graph
            _buildInputFieldsAndGraph(),
            const SizedBox(height: 20),

            // Sleep Environment
            _buildSectionTitle('Sleep Environment:'),
            _buildSleepEnvironment(),
            const SizedBox(height: 20),

            // Sleep Tips
            _buildSectionTitle('Sleep Tips:'),
            _buildSleepTips(),
            const SizedBox(height: 20),

            // Sleep Notes
            // _buildSectionTitle('Sleep Notes:'),
            // _buildSleepNotes(),
          ],
        ),
      ),
    );
  }

  // Helper Methods

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSleepGoals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Target Bedtime: ${_formatTime(_targetBedtime)}'),
        Text('Target Wakeup Time: ${_formatTime(_targetWakeupTime)}'),
      ],
    );
  }

  Widget _buildInputFieldsAndGraph() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Bedtime:',
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () => _selectTime(context, true),
              child: Text(
                _formatTime(_bedtime),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Wakeup Time:',
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () => _selectTime(context, false),
              child: Text(
                _formatTime(_wakeupTime),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _calculateSleepQuality,
          child: const Text('Submit'),
        ),
        const SizedBox(height: 20),
        const Text(
          'Sleep Tracking',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: _generateSpots(),
                  isCurved: true,
                  colors: [Colors.blue],
                  barWidth: 4,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: SideTitles(showTitles: true),
                bottomTitles: SideTitles(showTitles: true),
              ),
              borderData: FlBorderData(show: true),
              minX: 0,
              maxX: _sleepData.length.toDouble() - 1,
              minY: 0,
              maxY: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSleepEnvironment() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('- Maintain a comfortable room temperature (around 65-70°F)'),
        Text('- Keep the bedroom dark and quiet'),
        Text(
            '- Consider using white noise machines or earplugs if noise is an issue'),
      ],
    );
  }

  Widget _buildSleepTips() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            '- Establish a consistent bedtime routine to signal to your body that it is time to sleep'),
        Text('- Avoid caffeine and heavy meals close to bedtime'),
        Text(
            '- Limit screen time before bed and consider using blue light filters on electronic devices'),
      ],
    );
  }

  Widget _buildSleepNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Add notes about your sleep...',
            border: OutlineInputBorder(),
          ),
          maxLines: null,
          onChanged: (value) {
            // Store sleep notes in a list
            setState(() {
              _sleepNotes.add(value);
            });
          },
        ),
        SizedBox(height: 10),
        Text('Sleep Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _sleepNotes.map((note) => Text('- $note')).toList(),
        ),
      ],
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
    final hoursSlept = ((wakeupTimeMinutes - bedtimeMinutes) / 60).round() + 24;

    setState(() {
      _sleepData.add(hoursSlept.toDouble());
      if (hoursSlept >= 7 && hoursSlept <= 9) {
        _sleepQuality = 'You slept well!';
      } else {
        _sleepQuality =
            'You should aim for 7-9 hours of sleep for better health.';
      }
      _hoursSlept = 'You slept for $hoursSlept hours.';
    });
  }

  List<FlSpot> _generateSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < _sleepData.length; i++) {
      spots.add(FlSpot(i.toDouble(), _sleepData[i]));
    }
    return spots;
  }

  // List<FlSpot> _generateWeeklySleepSpots() {
  //   List<FlSpot> spots = [];
  //   for (int i = 0; i < _weeklySleepDuration.length; i++) {
  //     spots.add(FlSpot(i.toDouble(), _weeklySleepDuration[i]));
  //   }
  //   return spots;
  // }
}

class MoodTrackingWindow extends StatefulWidget {
  const MoodTrackingWindow({super.key});

  @override
  _MoodTrackingWindowState createState() => _MoodTrackingWindowState();
}

class _MoodTrackingWindowState extends State<MoodTrackingWindow> {
  String? moodGoal;
  List<int> moodData = [];
  List<String> days = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final DateTime now = DateTime.now();
    final DateTime sevenDaysAgo = now.subtract(const Duration(days: 7));
    final user = FirebaseAuth.instance.currentUser;
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('mood')
        .where('date', isGreaterThanOrEqualTo: sevenDaysAgo)
        .orderBy('date', descending: true)
        .limit(7)
        .get();

    // Create a map to store mood data with date as key
    Map<DateTime, int> moodDataMap = {};
    for (var doc in querySnapshot.docs) {
      final DateTime date = doc['date'].toDate();
      final DateTime roundedDate = DateTime(date.year, date.month, date.day);
      moodDataMap[roundedDate] = doc['mood'] as int;
      // print(moodDataMap[date]);
    }
    

    // Generate a list of mood scores for the past  7 days, filling with  0 if not present
    List<int> moodDataList = List.generate(7, (index) {
      final DateTime date = now.subtract(Duration(days: index));
      final DateTime roundedDate = DateTime(date.year, date.month, date.day);
      return moodDataMap[roundedDate] ??
          0; // Use the mood score if available, or  0 if not
    });

    // Update state with the new data
    setState(() {
      moodData = moodDataList;
      days = moodDataMap.keys.map((date) {
        return DateFormat('E').format(date);
      }).toList();
      // Assuming days are already defined as ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracking Window'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Mood Tracking',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 300,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: moodData.asMap().entries.map((entry) {
                        return FlSpot(
                            entry.key.toDouble(), entry.value.toDouble());
                      }).toList(),
                      isCurved: true,
                      colors: [Colors.blue],
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  minY: 0,
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(showTitles: true),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return days[value.toInt()];
                        }
                        return '';
                      },
                      margin: 10,
                      rotateAngle: -45,
                      interval: 1,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                  ),
                  maxX: days.length.toDouble() - 1,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              moodGoal ?? 'No mood goal set yet.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showMoodGoalDialog(context),
              child: const Text('Set Mood Goal'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoodGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Mood Goal'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                moodGoal = value;
              });
            },
            decoration:
                const InputDecoration(hintText: "Enter your mood goal here"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Set'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class DiaryWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get today's date
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEEE, MMMM d, yyyy');
    final String formattedDate = formatter.format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Dear Diary,',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(10.0),
                child: const TextField(
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: 'Write your thoughts here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit button press
                  // You can add your submission logic here
                },
                child: const Text('Submit'),
              ),
            ),
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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Default Window'),
            // Add more UI elements for the default window
          ],
        ),
      ),
    );
  }
}
