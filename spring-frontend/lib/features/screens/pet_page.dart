import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:spring/features/screens/daily_tasks/gratitude_page.dart';
import 'package:spring/features/screens/daily_tasks/walk_page.dart';
import 'package:spring/features/screens/daily_tasks/kindness_page.dart';
import 'package:spring/features/screens/daily_tasks/exercise_page.dart';
import 'package:spring/features/screens/daily_tasks/hobby_page.dart';
import 'package:spring/features/screens/daily_tasks/meditate_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    },
    {
      'icon': Icons.person,
      'title': 'Meditate for 30 minutes',
      'description': 'Ease your mind and relax to refresh your day!',
      'navigateTo': MeditatePage()
    },
    {
      'icon': Icons.local_fire_department,
      'title': 'Exercise for 30 minutes',
      'description': 'Get your body moving and your heart pumping!',
      'navigateTo': ExercisePage()
    },
    {
      'icon': Icons.handshake,
      'title': 'Perform 3 acts of kindness',
      'description': 'Perform acts of kindness to make someone smile!',
      'navigateTo': const KindnessPage()
    },
    {
      'icon': Icons.star,
      'title': 'Note 3 events you are grateful for',
      'description': 'Write down 3 events that made you happy today!',
      'navigateTo': const GratitudePage()
    },
    {
      'icon': Icons.bookmark,
      'title': 'Indulge in a hobby',
      'description': 'Take some time to relax and do something you love!',
      'navigateTo': const HobbyPage()
    },
    {
      'icon': Icons.bedtime,
      'title': 'Sleep for 8 hours',
      'description': 'Get a good night\'s sleep to refresh your mind and body!',
      'navigateTo': WalkPage()
    },
    {
      'icon': Icons.directions_walk,
      'title': 'Walk 500 steps',
      'description': 'Get up and walk around to get your body moving!',
      'navigateTo': const WalkPage()
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = FirebaseAuth.instance.currentUser;
    Offset _sparklePosition = Offset.zero;
    bool _showSparkle = false;

    Future<int> getCountPlayed() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('tasks')
            .doc('Play with your pet')
            .get();
        return userData.exists ? userData['count'] : 0;
      }
      return 0;
    }

    Future<bool> getCompletion(String title) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('tasks')
            .doc(title)
            .get();
        return userData.exists && userData['completed'];
      }
      return false;
    }

    Future<int> getCompletedTasksCount(String userId) async {
      final userTasks = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .where('completed', isEqualTo: true)
          .get();

      return userTasks
          .docs.length; // This will give you the count of completed tasks
    }

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
                  Stack(
                    children: [
                      GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          setState(() {
                            _sparklePosition = details.localPosition;
                            _showSparkle = true;
                            getCountPlayed().then((count) {
                              if (count < 3) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user!.uid)
                                    .collection('tasks')
                                    .doc('Play with your pet')
                                    .set({'count': count + 1}, SetOptions(merge: true));
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection('tasks')
                                    .doc('Play with your pet')
                                    .set({'completed': false}, SetOptions(merge: true));
                              }
                              else{
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user!.uid)
                                    .collection('tasks')
                                    .doc('Play with your pet')
                                    .set({'completed': true}, SetOptions(merge: true));
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection('tasks')
                                    .doc('Play with your pet')
                                    .set({'count': count + 1}, SetOptions(merge: true));
                              }
                            });
                          });
                        },
                        child: GifView.asset(
                          assetList[index],
                          height: 200,
                          width: 200,
                          frameRate: 10,
                        ),
                      ),
                      if (_showSparkle) Sparkle(position: _sparklePosition),
                    ],
                  ),
                  const Divider(),
                  const Text('Melfie', style: TextStyle(fontSize: 18)),
                  const Divider(),
                  const SizedBox(height: 20),
                  FutureBuilder<int>(
                    future: getCompletedTasksCount(user!.uid),
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Show a loading indicator while waiting
                      } else if (snapshot.hasError) {
                        return const Text(
                            'Error loading tasks'); // Show error message if there's an error
                      } else {
                        return Text(
                          '${snapshot.data} Goals Completed Today!',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary),
                        );
                      }
                    },
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
                              leading: Icon(task['icon'], color: Colors.grey),
                              title: Text(
                                task['title'],
                                textAlign: TextAlign.start,
                              ),
                              trailing: FutureBuilder<bool>(
                                future: getCompletion(task['title']),
                                builder: (BuildContext context,
                                    AsyncSnapshot<bool> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator(); // Show a loading indicator while waiting
                                  } else if (snapshot.hasError) {
                                    return const Icon(Icons
                                        .error); // Show error icon if there's an error
                                  } else {
                                    return Icon(
                                      snapshot.data == true
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: snapshot.data == true
                                          ? Colors.red
                                          : Colors.grey,
                                    );
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                          title: Text(task['title'],
                              style: TextStyle(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          subtitle: Text(task['description']),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => task['navigateTo']));
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

class Particle {
  late Offset position;
  late Offset velocity;
  late double size;
  late Color color;
  late AnimationController controller;
  late Animation<double> animation;

  Particle({required this.position, required this.size, required this.color});

  void createAnimation(TickerProvider vsync) {
    controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: vsync,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    controller.forward();
  }

  void update(double dt) {
    position += velocity * dt;
  }

  void dispose() {
    controller.dispose();
  }
}

class Sparkle extends StatefulWidget {
  final Offset position;

  Sparkle({required this.position});

  @override
  _SparkleState createState() => _SparkleState();
}

class _SparkleState extends State<Sparkle> with TickerProviderStateMixin {
  List<Particle> particles = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      particles.add(Particle(
        position: widget.position,
        size: 5.0, // Adjust size as needed
        color: Colors.yellow, // Adjust color as needed
      ));
      particles[i].createAnimation(this);
    }
  }

  @override
  void dispose() {
    for (var particle in particles) {
      particle.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: particles.map((particle) {
        return AnimatedBuilder(
          animation: particle.controller,
          builder: (BuildContext context, Widget? child) {
            return Positioned(
              left: particle.position.dx,
              top: particle.position.dy,
              child: Opacity(
                opacity: particle.animation.value,
                child: Container(
                  width: particle.size,
                  height: particle.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: particle.color,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
