import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/core/constant/app_colors.dart';
import 'package:sopotify/providers/bottom_navbar_provider.dart';
import 'package:sopotify/views/home/home_screen.dart';
import 'package:sopotify/views/library/library_screen.dart';
import 'package:sopotify/views/search/search_screen.dart';

class BottomNavExample extends StatelessWidget {
  BottomNavExample({super.key});

  final List<Widget> _pages = const [
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);

    return Scaffold(
      body: _pages[navProvider.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.black,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.white70,
        currentIndex: navProvider.selectedIndex,
        onTap: (index) => navProvider.changeIndex(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: "Library",
          ),
        ],
      ),
    );
  }
}
