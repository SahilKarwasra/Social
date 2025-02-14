import 'package:flutter/material.dart';

import 'features/home/presentation/pages/home.dart';
import 'features/home/presentation/components/search.dart';
import 'features/profile/presentation/pages/profile.dart';

class MainPageWithBottomBar extends StatefulWidget {
  const MainPageWithBottomBar({super.key});

  @override
  State<MainPageWithBottomBar> createState() => _MainPageWithBottomBarState();
}

class _MainPageWithBottomBarState extends State<MainPageWithBottomBar> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const Home(),
    const Search(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _navigateBottomBar,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
