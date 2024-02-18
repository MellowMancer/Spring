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

  void _openNewWindow(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewWindow()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true, // Center the title
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Home Page'),
            SizedBox(height:   30),
            Text(
              'What is your mood today?',
              style: TextStyle(fontSize:   20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height:   10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _selectMood(0),
                  icon: Icon(Icons.sentiment_very_satisfied),
                  label: Text('Happy'),
                  style: ElevatedButton.styleFrom(
                    primary: _selectedMood ==   0 ? Colors.green : Colors.blue,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _selectMood(1),
                  icon: Icon(Icons.sentiment_neutral),
                  label: Text('Neutral'),
                  style: ElevatedButton.styleFrom(
                    primary: _selectedMood ==   1 ? Colors.green : Colors.blue,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _selectMood(2),
                  icon: Icon(Icons.sentiment_very_dissatisfied),
                  label: Text('Sad'),
                  style: ElevatedButton.styleFrom(
                    primary: _selectedMood ==   2 ? Colors.green : Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height:   30),
            ...List.generate(4, (index) {
              String buttonText;
              String description;
              IconData buttonIcon;
              switch (index) {
                case   0:
                  buttonText = 'Sleep Tracking';
                  description = 'Track your sleep patterns';
                  buttonIcon = Icons.bedtime;
                  break;
                case   1:
                  buttonText = 'Mood Tracking';
                  description = 'Track your mood over time';
                  buttonIcon = Icons.mood;
                  break;
                case   2:
                  buttonText = 'Gratitude Journaling';
                  description = 'Record your gratitude';
                  buttonIcon = Icons.edit;
                  break;
                case   3:
                  buttonText = 'Diary';
                  description = 'Write your thoughts and experiences';
                  buttonIcon = Icons.book;
                  break;
                default:
                  buttonText = 'Button ${index +   1}';
                  description = 'Default button description';
                  buttonIcon = Icons.star;
              }
              // Wrap the button with a SizedBox to give it a fixed size
              return SizedBox(
                width: MediaQuery.of(context).size.width *   0.9, //   90% of screen width
                child: ElevatedButton.icon(
                  onPressed: () => _openNewWindow(context),
                  icon: Icon(buttonIcon),
                  label: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        buttonText,
                        style: TextStyle(fontSize:   18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        description,
                        style: TextStyle(fontSize:   12),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal:   20),
                  ),
                ),
              );
            }).expand((button) => [button, SizedBox(height:   10)]).toList(),
          ],
        ),
      ),
    );
  }
}

class NewWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Window'),
      ),
      body: const Center(
        child: Text('This is a new window'),
      ),
    );
  }
}
