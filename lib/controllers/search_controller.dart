// File: controllers/spotify_search_controller.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';

class SpotifySearchController {
  final ScrollController scrollController = ScrollController();
  BuildContext? _context;
  bool _isInitialized = false;

  SpotifySearchController() {
    scrollController.addListener(_onScroll);
  }

  void init(BuildContext context) {
    if (_isInitialized) return;
    _isInitialized = true;

    _context = context;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchProvider = context.read<SearchProvider>();
      searchProvider.clearSearch();
    });
  }

  void _onScroll() {
    if (_context == null) return;

    final searchProvider = _context!.read<SearchProvider>();
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        searchProvider.hasMore &&
        !searchProvider.isLoading) {
      searchProvider.fetchMore(_context!);
    }
  }

  void refresh(BuildContext context, String query) {
    final searchProvider = context.read<SearchProvider>();
    searchProvider.clearSearch();
    if (query.isNotEmpty) {
      searchProvider.searchTracks(context, query);
    }
  }

  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
  }
}
