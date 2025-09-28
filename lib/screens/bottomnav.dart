import 'package:flutter/material.dart';
import 'package:sahayak_ui/screens/home/homescreen.dart';
import 'package:sahayak_ui/screens/notes/notes.dart';
import 'package:sahayak_ui/screens/settings/settings.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomeScreen(),
    Notes(),
    Settings(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Settings'),
        ],
      ),
    );
  }
}
