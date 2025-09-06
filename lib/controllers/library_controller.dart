import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/providers/auth_provider.dart';
import 'package:sopotify/providers/liked_track_provider.dart';
import 'package:sopotify/providers/playlist_provider.dart';
import 'package:sopotify/providers/user_provider.dart';

class LibraryController {
  final ScrollController scrollController = ScrollController();
  BuildContext? _context; // Store BuildContext
  bool _isInitialized = false;

  LibraryController();

  void init(BuildContext context) {
    if (_isInitialized) return;
    _isInitialized = true;

    // Store the context
    _context = context;

    // Initialize data fetching
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<SpotifyAuthProvider>();
      final playlistProvider = context.read<PlaylistProvider>();
      final userProvider = context.read<UserProvider>();
      final likedTracksProvider = context.read<LikedTracksProvider>();

      // Fetch data if access token is available
      if (authProvider.accessToken.isNotEmpty) {
        playlistProvider.fetchPlaylists(context);
        userProvider.fetchUserProfile(authProvider.accessToken);
        likedTracksProvider.fetchLikedTracks(context);
      }
    });

    // Attach scroll listener
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_context == null) return;

    final playlistProvider = _context!.read<PlaylistProvider>();
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        playlistProvider.hasMore &&
        !playlistProvider.isLoading) {
      playlistProvider.fetchMorePlaylists(_context!);
    }
  }

  // void refresh(BuildContext context) {
  //   final playlistProvider = context.read<PlaylistProvider>();
  //   final authProvider = context.read<SpotifyAuthProvider>();
  //   final userProvider = context.read<UserProvider>();

  //   playlistProvider.reset();
  //   if (authProvider.accessToken.isNotEmpty) {
  //     playlistProvider.fetchPlaylists(context);
  //     userProvider.fetchUserProfile(authProvider.accessToken);
  //   }
  // }

  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    _context = null; // Clear context to avoid memory leaks
  }
}