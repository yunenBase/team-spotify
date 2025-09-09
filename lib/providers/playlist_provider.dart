import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:sopotify/models/playlist_model.dart';
import 'auth_provider.dart';

class PlaylistProvider extends ChangeNotifier {
  List<Playlist> _playlists = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _totalPlaylists = 0;
  String? _nextUrl; // Untuk paginasi

  // Getter
  List<Playlist> get playlists => _playlists;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get totalPlaylists => _totalPlaylists;
  bool get hasMore => _nextUrl != null;

  Future<void> fetchPlaylists(BuildContext context, {int limit = 20, int offset = 0}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    // Ambil accessToken dari SpotifyAuthProvider
    final authProvider = Provider.of<SpotifyAuthProvider>(context, listen: false);
    final accessToken = authProvider.accessToken;

    if (accessToken.isEmpty) {
      _errorMessage = 'Tidak ada access token. Silakan login terlebih dahulu.';
      _isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage)),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me/playlists?limit=$limit&offset=$offset'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final playlistResponse = PlaylistResponse.fromJson(json.decode(response.body));
        _playlists = playlistResponse.playlists;
        _totalPlaylists = playlistResponse.total;
        _nextUrl = playlistResponse.next;
      } else {
        final errorData = json.decode(response.body);
        final errorMsg = errorData['error']?['message'] ?? 'Unknown error';
        throw Exception('Gagal mengambil playlist: $errorMsg');
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage)),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi untuk memuat lebih banyak playlist (paginasi)
  Future<void> fetchMorePlaylists(BuildContext context) async {
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
        final playlistResponse = PlaylistResponse.fromJson(json.decode(response.body));
        _playlists.addAll(playlistResponse.playlists);
        _totalPlaylists = playlistResponse.total;
        _nextUrl = playlistResponse.next;
      } else {
        final errorData = json.decode(response.body);
        final errorMsg = errorData['error']?['message'] ?? 'Unknown error';
        throw Exception('Gagal mengambil lebih banyak playlist: $errorMsg');
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage)),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset data playlist
  void reset() {
    _playlists = [];
    _totalPlaylists = 0;
    _nextUrl = null;
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  void fetchMore(BuildContext context) {}
}