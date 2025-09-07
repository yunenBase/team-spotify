import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/core/constant/app_colors.dart';
import 'package:sopotify/providers/bottom_navbar_provider.dart';
import 'package:sopotify/views/home/home_screen.dart';
import 'package:sopotify/views/library/library_screen.dart';
import 'package:sopotify/views/search/search_screen.dart';

class BottomNavExample extends StatelessWidget {
  BottomNavExample({super.key});

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Home
    GlobalKey<NavigatorState>(), // Search
    GlobalKey<NavigatorState>(), // Library
  ];

  final List<Widget> _rootPages = const [
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);

    return Scaffold(
      body: IndexedStack(
        index: navProvider.selectedIndex,
        children: List.generate(_rootPages.length, (index) {
          return Navigator(
            key: _navigatorKeys[index],
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) => _rootPages[index],
              );
            },
          );
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 19, 19, 19),
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.white70,
        currentIndex: navProvider.selectedIndex,
        onTap: (index) {
          if (index == navProvider.selectedIndex) {
            // 👇 Reset ke halaman root tab yang sama
            _navigatorKeys[index]
                .currentState!
                .popUntil((route) => route.isFirst);
          } else {
            navProvider.changeIndex(index);
          }
        },
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
