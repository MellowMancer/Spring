import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Home",
                style: Theme.of(context).textTheme.headlineSmall),
            centerTitle: true,
          ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the Home Page'),
            const SizedBox(height:   30),
            const Text(
              'What is your mood today?',
              style: TextStyle(fontSize:   20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height:   10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _selectMood(0),
                  icon: const Icon(Icons.sentiment_very_satisfied),
                  label: const Text('Happy'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: _selectedMood ==   0 ? colorScheme.primary : colorScheme.onPrimaryContainer,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _selectMood(1),
                  icon: const Icon(Icons.sentiment_neutral),
                  label: const Text('Neutral'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: _selectedMood ==   1 ? colorScheme.primary : colorScheme.onPrimaryContainer,),
                ),
                ElevatedButton.icon(
                  onPressed: () => _selectMood(2),
                  icon: const Icon(Icons.sentiment_very_dissatisfied),
                  label: const Text('Sad'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: _selectedMood ==   2 ? colorScheme.primary : colorScheme.onPrimaryContainer,),
                ),
              ],
            ),
            const SizedBox(height:   30),
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
                width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                child: ElevatedButton.icon(
                  onPressed: () => _openNewWindow(context),
                  icon: Icon(buttonIcon),
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start (left)
                    children: [
                      Text(
                        buttonText,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    foregroundColor: colorScheme.onPrimaryContainer, backgroundColor: colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                  ),
                ),
              );
            }).expand((button) => [button, const SizedBox(height:   10)]),
          ],
        ),
      ),
    ),
    );
  }
}

class NewWindow extends StatelessWidget {
  const NewWindow({super.key});

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
