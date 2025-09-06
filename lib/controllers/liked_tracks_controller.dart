import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/providers/auth_provider.dart';
import 'package:sopotify/providers/liked_track_provider.dart';

class LikedTracksController {
  final ScrollController scrollController = ScrollController();
  BuildContext? _context; 
  bool _isInitialized = false;

  LikedTracksController() {
    scrollController.addListener(_onScroll);
  }

  void init(BuildContext context) {
    if (_isInitialized) return;
    _isInitialized = true;

    _context = context;

    // Gunakan addPostFrameCallback untuk memastikan context siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<SpotifyAuthProvider>();
      final likedTracksProvider = context.read<LikedTracksProvider>();
      if (authProvider.accessToken.isNotEmpty) {
        likedTracksProvider.fetchLikedTracks(context);
      }
    });
  }

  void _onScroll() {
    if (_context == null) return;

    final likedTracksProvider = _context!.read<LikedTracksProvider>();
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        likedTracksProvider.hasMore &&
        !likedTracksProvider.isLoading) {
      likedTracksProvider.fetchMoreLikedTracks(_context!);
    }
  }

  void refresh(BuildContext context) {
    final authProvider = context.read<SpotifyAuthProvider>();
    final likedTracksProvider = context.read<LikedTracksProvider>();
    likedTracksProvider.reset();
    if (authProvider.accessToken.isNotEmpty) {
      likedTracksProvider.fetchLikedTracks(context);
    }
  }

  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
  }
}