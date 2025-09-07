import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import '../models/search_model.dart';
import '../models/liked_track_model.dart';
import 'auth_provider.dart';

class SearchProvider extends ChangeNotifier {
  List<Track> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _query = '';
  Timer? _debounceTimer;

  // Getter
  List<Track> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get query => _query;

  Future<void> searchTracks(BuildContext context, String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _errorMessage = '';
      notifyListeners();
      return;
    }

    _query = query.trim();
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
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
          Uri.parse('https://api.spotify.com/v1/search?q=${Uri.encodeQueryComponent(_query)}&type=track&limit=10&offset=0'),
          headers: {'Authorization': 'Bearer $accessToken'},
        );

        if (response.statusCode == 200) {
          final searchResponse = SearchResponse.fromJson(json.decode(response.body));
          _searchResults = searchResponse.tracks.items;
        } else {
          final errorData = json.decode(response.body);
          final errorMsg = errorData['error']?['message'] ?? 'Unknown error';
          throw Exception('Gagal mencari: $errorMsg');
        }
      } catch (e) {
        _errorMessage = 'Error: ${e.toString()}';
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  void clearSearch() {
    _searchResults = [];
    _query = '';
    _errorMessage = '';
    _debounceTimer?.cancel();
    notifyListeners();
  }
}