import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:sopotify/models/liked_track_model.dart';
import 'package:sopotify/providers/auth_provider.dart';

class LikedTracksProvider extends ChangeNotifier {
  List<LikedTrackItem> _likedTracks = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _totalTracks = 0;
  String? _nextUrl;

  // Getter
  List<LikedTrackItem> get likedTracks => _likedTracks;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get totalTracks => _totalTracks;
  bool get hasMore => _nextUrl != null;

  Future<void> fetchLikedTracks(BuildContext context, {int limit = 20, int offset = 0}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final authProvider = Provider.of<SpotifyAuthProvider>(context, listen: false);
    final accessToken = authProvider.accessToken;

    if (accessToken.isEmpty) {
      _errorMessage = 'Tidak ada access token. Silakan login terlebih dahulu.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me/tracks?limit=$limit&offset=$offset'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final likedTracksResponse = LikedTracksResponse.fromJson(json.decode(response.body));
        _likedTracks = likedTracksResponse.items;
        _totalTracks = likedTracksResponse.total;
        _nextUrl = likedTracksResponse.next;
      } else {
        final errorData = json.decode(response.body);
        final errorMsg = errorData['error']?['message'] ?? 'Unknown error';
        throw Exception('Gagal mengambil liked tracks: $errorMsg');
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreLikedTracks(BuildContext context) async {
    if (_nextUrl == null || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    final authProvider = Provider.of<SpotifyAuthProvider>(context, listen: false);
    final accessToken = authProvider.accessToken;

    try {
      final response = await http.get(
        Uri.parse(_nextUrl!),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final likedTracksResponse = LikedTracksResponse.fromJson(json.decode(response.body));
        _likedTracks.addAll(likedTracksResponse.items);
        _totalTracks = likedTracksResponse.total;
        _nextUrl = likedTracksResponse.next;
      } else {
        final errorData = json.decode(response.body);
        final errorMsg = errorData['error']?['message'] ?? 'Unknown error';
        throw Exception('Gagal mengambil lebih banyak liked tracks: $errorMsg');
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _likedTracks = [];
    _totalTracks = 0;
    _nextUrl = null;
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }
}