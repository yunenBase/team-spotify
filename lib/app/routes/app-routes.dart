import 'package:flutter/material.dart';
import 'package:sopotify/app/routes/app_pages.dart';
import 'package:sopotify/views/home/home_screen.dart';
import 'package:sopotify/views/library/library_screen.dart';
import 'package:sopotify/views/search/search_screen.dart';
import 'package:sopotify/widgets/bottom_navbar.dart';

class AppPages {
  static Map<String, WidgetBuilder> get routes => {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.search: (context) => const SearchScreen(),
        AppRoutes.library: (context) => const LibraryScreen(),
        AppRoutes.bottomNav: (context) => BottomNavExample(),
        // Add other routes here
      };
}