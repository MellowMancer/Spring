import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class PetPage extends StatefulWidget {
  const PetPage({super.key});

  static const String routeName = '/petpage';

  @override
  State<PetPage> createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  final List<Map<String, dynamic>> tasks = [
    {
      'icon': Icons.pets,
      'title': 'Play with your pet',
      'description': 'Play with your pet by rubbing your finger on them!',
      'completed': false
    },
    {
      'icon': Icons.person,
      'title': 'Meditate for 30 minutes',
      'description': 'Ease your mind and relax to refresh your day!',
      'completed': true
    },
    {
      'icon': Icons.local_fire_department,
      'title': 'Exercise for 30 minutes',
      'description': 'Get your body moving and your heart pumping!',
      'completed': false
    },
    {
      'icon': Icons.handshake,
      'title': 'Perform 3 acts of kindness',
      'description': 'Perform acts of kindness to make someone smile!',
      'completed': false
    },
    {
      'icon': Icons.star,
      'title': 'Note 3 events you are grateful for',
      'description': 'Write down 3 events that made you happy today!',
      'completed': false
    },
    {
      'icon': Icons.bookmark,
      'title': 'Read a book for 30 minutes',
      'description': 'Read a book to relax and escape into a different world!',
      'completed': false
    },
    {
      'icon': Icons.bedtime,
      'title': 'Sleep for  8 hours', 
      'description': 'Get a good night\'s sleep to refresh your mind and body!',
      'completed': false
    },
  ];
  final assetList = [
    'assets/images/pets/cat/cat_default.gif',
    'assets/images/pets/cat/cat_happy.gif',
    'assets/images/pets/cat/cat_sad.gif',
    'assets/images/pets/cat/cat_sleep.gif',
    'assets/images/pets/cat/cat_meditate.gif',
  ];
  final index = 0;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Pet", style: Theme.of(context).textTheme.headlineSmall),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GifView.asset(
                    assetList[index],
                    height: 200,
                    width: 200,
                    frameRate: 10,
                  ),
                  const Divider(),
                  const Text('Melfie', style: TextStyle(fontSize: 18)),
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    '2 Goals Completed Today!',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Material(
                      color: Colors.white,
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Card(
                        elevation: 0,
                        margin: const EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: tasks.map((task) {
                            return ListTile(
                              leading: Icon(task['icon'],
                                  color: task['completed']
                                      ? Colors.red
                                      : Colors.grey),
                              title: Text(
                                task['title'],
                                textAlign: TextAlign.start,
                              ),
                              trailing: Icon(
                                  task['completed']
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: task['completed']
                                      ? Colors.red
                                      : Colors.grey),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                    ),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Card(
                        color: colorScheme.primaryContainer,
                        elevation: 5,
                        child: ListTile(
                          isThreeLine: true,
                          title: Text(task['title'], style: TextStyle(color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold, fontSize: 18)),
                          subtitle: Text(task['description']),
                          onTap: () {
                            // Handle task tap, e.g., navigate to task details
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
