import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';

import '../Screen/category_screen.dart';
import '../Screen/home_screen.dart';
import '../services/Themeconstants.dart';

class PrePage extends StatefulWidget {
  const PrePage({super.key});

  @override
  State<PrePage> createState() => _PrePageState();
}

class _PrePageState extends State<PrePage> {
  int _selectedIndex = 0;
  // List of pages corresponding to each tab
  final List<Widget> _pages = [
    HomeScreen(),
    CategoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index:
            _selectedIndex, // Display the current page based on the selected index
        children: _pages,
      ),
      bottomNavigationBar: FlashyTabBar(
        backgroundColor: Themeconstants.getbottomNavColor(context),
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(
                color: Themeconstants.getPrimaryTextColor(context),
              ),
            ),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.category),
            title: Text(
              'Categories',
              style: TextStyle(
                color: Themeconstants.getPrimaryTextColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
