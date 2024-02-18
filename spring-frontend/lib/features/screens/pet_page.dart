import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class PetPage extends StatefulWidget {
  const PetPage({super.key});

  static const String routeName = '/petpage';

  @override
  State<PetPage> createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
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
                  // const Text('Pet Page',
                  //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  // const SizedBox(height: 30),
                  // Image.asset('assets/images/pets/cat/cat_happy.gif'),
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
                  Text('2 Goals Completed Today!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.primary), ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child:
                        Material(
                            color: Colors.white,
                            elevation:  5, // Add elevation
                            borderRadius: BorderRadius.circular(10), // Optional: for rounded corners
                            child: Card(
                            elevation: 0, // Remove shadow
                            margin: const EdgeInsets.all(0), // Remove margin
                            child: Column(
                              children: [
                                const ListTile(
                                  leading: Icon(Icons.pets),
                                  title: Text('Play with your pet!'),
                                  trailing:
                                      Icon(Icons.favorite_border, color: Colors.grey),
                                ),
                                Divider(color: colorScheme.primaryContainer),
                                const ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text('Meditate for 30 minutes'),
                                  trailing: Icon(Icons.favorite, color: Colors.red),
                                ),
                                Divider(color: colorScheme.primaryContainer),
                                const ListTile(
                                  leading: Icon(Icons.local_fire_department),
                                  title: Text('Exercise for 30 minutes'),
                                  trailing:
                                      Icon(Icons.favorite_border, color: Colors.grey),
                                ),
                                Divider(color: colorScheme.primaryContainer),
                                const ListTile(
                                  leading: Icon(Icons.handshake),
                                  title: Text('Perform 3 acts of kindness'),
                                  trailing:
                                      Icon(Icons.favorite_border, color: Colors.grey),
                                ),
                                Divider(color: colorScheme.primaryContainer),
                                const ListTile(
                                  leading: Icon(Icons.local_fire_department),
                                  title: Text('Exercise for 30 minutes'),
                                  trailing:
                                      Icon(Icons.favorite_border, color: Colors.grey),
                                ),
                                Divider(color: colorScheme.primaryContainer),
                                const ListTile(
                                  leading: Icon(Icons.local_fire_department),
                                  title: Text('Exercise for 30 minutes'),
                                  trailing:
                                      Icon(Icons.favorite_border, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
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
