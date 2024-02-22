import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedMood = -1; // -1 indicates no mood selected

  List<int> _moodData = [0, 0, 0, 0, 0, 0, 0]; // List to store mood data for each day of the week
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']; // Days of the week

  void _selectMood(int mood) {
    setState(() {
      _selectedMood = mood;
      _updateMoodData(); // Update mood data when mood is selected
    });
  }

  void _updateMoodData() {
    // Update mood data based on the selected mood and current day
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('E'); // Format to get the day of the week (e.g., Mon, Tue, etc.)
    final String formattedDay = formatter.format(now);

    int dayIndex = _days.indexOf(formattedDay);
    if (dayIndex != -1) {
      _moodData[dayIndex] = _selectedMood;
    }
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
                  windowContent = MoodTrackingWindow(moodData: _moodData, days: _days);
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

  // Add a list to store the data points for the graph
  List<double> _sleepData = [];

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
            SizedBox(height: 20),
            // Add the graph below the existing text widgets
            Text(
              'Sleep Tracking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateSpots(), // Generate spots for the graph
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
        ),
      ),
    );
  }

  // Method to generate spots for the graph
  List<FlSpot> _generateSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < _sleepData.length; i++) {
      spots.add(FlSpot(i.toDouble(), _sleepData[i]));
    }
    return spots;
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
      _sleepData.add(hoursSlept.toDouble()); // Add the hours slept to the data for the graph
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
  final List<int> moodData;
  final List<String> days;

  const MoodTrackingWindow({required this.moodData, required this.days});

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
            Text(
              'Mood Tracking',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 300,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: moodData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.toDouble());
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
                      margin: 10, // Adjust the margin for better readability
                      rotateAngle: -45, // Rotate x-axis labels for better fit
                      interval: 1, // Specify the interval for displaying labels
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
                  maxX: days.length.toDouble() - 1, // Adjust maximum x value to fit all data points
                ),
              ),
            ),
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
