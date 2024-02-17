import 'package:flutter/material.dart';
import 'package:spring/features/screens/home_page.dart';
import 'package:spring/features/screens/pet_page.dart';
import 'package:spring/features/screens/profile_page.dart';
import 'package:spring/features/screens/trivia_page.dart';
import 'package:spring/chatbot_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  static const String routeName = '/bottomnav';

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final List<Widget> pageList = <Widget>[
      const HomePage(),
      const PetPage(),
      const TriviaPage(),
      const ProfilePage(),
    ];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatApp()),
          );
        },
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.chat, color: Colors.black) ,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
        selectedLabelStyle: textTheme.bodySmall,
        unselectedLabelStyle: textTheme.bodySmall,
        onTap: (value) {
          // Respond to item press.
          setState(() => _currentIndex = value);
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Pet',
            icon: Icon(Icons.pets),
          ),
          BottomNavigationBarItem(
            label: 'Trivia',
            icon: Icon(Icons.book_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: Center(
        child: pageList.elementAt(_currentIndex),
      ),
    );
  }
}
