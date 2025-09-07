import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import '../models/search_model.dart';
import '../models/liked_track_model.dart';
import 'auth_provider.dart';

class SearchProvider extends ChangeNotifier {
  List<Track> _tracks = [];
  List<Album> _albums = [];
  List<Artist> _artists = [];
  List<Playlist> _playlists = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _query = '';
  String? _tracksNextUrl;
  String? _albumsNextUrl;
  String? _artistsNextUrl;
  String? _playlistsNextUrl;
  String _selectedType = 'track';

  // Getter
  List<Track> get tracks => _tracks;
  List<Album> get albums => _albums;
  List<Artist> get artists => _artists;
  List<Playlist> get playlists => _playlists;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get query => _query;
  String get selectedType => _selectedType;
  bool get hasMore {
    switch (_selectedType) {
      case 'track':
        return _tracksNextUrl != null;
      case 'album':
        return _albumsNextUrl != null;
      case 'artist':
        return _artistsNextUrl != null;
      case 'playlist':
        return _playlistsNextUrl != null;
      case 'all':
        return _tracksNextUrl != null ||
            _albumsNextUrl != null ||
            _artistsNextUrl != null ||
            _playlistsNextUrl != null;
      default:
        return false;
    }
  }

  // Getter untuk View All
  List<Map<String, dynamic>> get allItems {
    List<Map<String, dynamic>> items = [];
    items.addAll(_tracks.map((track) => {'type': 'track', 'item': track}));
    items.addAll(_albums.map((album) => {'type': 'album', 'item': album}));
    items.addAll(_artists.map((artist) => {'type': 'artist', 'item': artist}));
    items.addAll(_playlists.map((playlist) => {'type': 'playlist', 'item': playlist}));
    return items;
  }

  // Method untuk mendapatkan nama item berdasarkan tipe
  String _getItemName(dynamic item, String type) {
    switch (type) {
      case 'track':
        return item.name ?? 'Unknown Track';
      case 'album':
        return item.name ?? 'Unknown Album';
      case 'artist':
        return item.name ?? 'Unknown Artist';
      case 'playlist':
        return item.name ?? 'Unknown Playlist';
      default:
        return 'Unknown';
    }
  }

  // Setter untuk filter
  void setSelectedType(String type) {
    if (_selectedType != type) {
      _selectedType = type;
      notifyListeners();
    }
  }

  Future<void> searchTracks(BuildContext context, String query) async {
    if (query.trim().isEmpty) {
      _clearResults();
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
          Uri.parse('https://api.spotify.com/v1/search?q=${Uri.encodeQueryComponent(_query)}&type=track,album,artist,playlist&limit=10&offset=0'),
          headers: {'Authorization': 'Bearer $accessToken'},
        );

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body) as Map<String, dynamic>?;
          if (jsonData == null) {
            throw Exception('Response body is null');
          }
          print('Search response: $jsonData');
          print('Tracks: ${jsonData['tracks'] != null ? "present" : "null"}');
          print('Albums: ${jsonData['albums'] != null ? "present" : "null"}');
          print('Artists: ${jsonData['artists'] != null ? "present" : "null"}');
          print('Playlists: ${jsonData['playlists'] != null ? "present" : "null"}');
          final searchResponse = SearchResponse.fromJson(jsonData);
          _tracks = searchResponse.tracks.items;
          _albums = searchResponse.albums.items;
          _artists = searchResponse.artists.items;
          _playlists = searchResponse.playlists.items;
          _tracksNextUrl = searchResponse.tracks.next;
          _albumsNextUrl = searchResponse.albums.next;
          _artistsNextUrl = searchResponse.artists.next;
          _playlistsNextUrl = searchResponse.playlists.next;
          print('Parsed all items: ${allItems.map((e) => {"type": e['type'], "name": _getItemName(e['item'], e['type'])}).toList()}');
        } else {
          final errorData = json.decode(response.body) as Map<String, dynamic>?;
          final errorMsg = errorData?['error']?['message'] ?? 'Unknown error';
          throw Exception('Gagal mencari: $errorMsg (Status: ${response.statusCode})');
        }
      } catch (e) {
        _errorMessage = 'Error: ${e.toString()}';
        print('Search error: $_errorMessage');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> fetchMore(BuildContext context) async {
    if (_isLoading || !hasMore) return;

    _isLoading = true;
    notifyListeners();

    final authProvider = Provider.of<SpotifyAuthProvider>(context, listen: false);
    final accessToken = authProvider.accessToken;

    try {
      if (_selectedType == 'all') {
        // Fetch lebih banyak untuk semua tipe yang masih memiliki nextUrl
        final responses = await Future.wait([
          if (_tracksNextUrl != null)
            http.get(Uri.parse(_tracksNextUrl!), headers: {'Authorization': 'Bearer $accessToken'}),
          if (_albumsNextUrl != null)
            http.get(Uri.parse(_albumsNextUrl!), headers: {'Authorization': 'Bearer $accessToken'}),
          if (_artistsNextUrl != null)
            http.get(Uri.parse(_artistsNextUrl!), headers: {'Authorization': 'Bearer $accessToken'}),
          if (_playlistsNextUrl != null)
            http.get(Uri.parse(_playlistsNextUrl!), headers: {'Authorization': 'Bearer $accessToken'}),
        ]);

        for (var response in responses) {
          if (response.statusCode == 200) {
            final jsonData = json.decode(response.body) as Map<String, dynamic>?;
            if (jsonData == null) {
              throw Exception('Response body is null');
            }
            final searchResponse = SearchResponse.fromJson(jsonData);
            if (_tracksNextUrl == response.request?.url.toString()) {
              _tracks.addAll(searchResponse.tracks.items);
              _tracksNextUrl = searchResponse.tracks.next;
            } else if (_albumsNextUrl == response.request?.url.toString()) {
              _albums.addAll(searchResponse.albums.items);
              _albumsNextUrl = searchResponse.albums.next;
            } else if (_artistsNextUrl == response.request?.url.toString()) {
              _artists.addAll(searchResponse.artists.items);
              _artistsNextUrl = searchResponse.artists.next;
            } else if (_playlistsNextUrl == response.request?.url.toString()) {
              _playlists.addAll(searchResponse.playlists.items);
              _playlistsNextUrl = searchResponse.playlists.next;
            }
          } else {
            final errorData = json.decode(response.body) as Map<String, dynamic>?;
            final errorMsg = errorData?['error']?['message'] ?? 'Unknown error';
            throw Exception('Gagal memuat lebih banyak: $errorMsg (Status: ${response.statusCode})');
          }
        }
      } else {
        String? nextUrl;
        switch (_selectedType) {
          case 'track':
            nextUrl = _tracksNextUrl;
            break;
          case 'album':
            nextUrl = _albumsNextUrl;
            break;
          case 'artist':
            nextUrl = _artistsNextUrl;
            break;
          case 'playlist':
            nextUrl = _playlistsNextUrl;
            break;
        }

        if (nextUrl == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        final response = await http.get(
          Uri.parse(nextUrl),
          headers: {'Authorization': 'Bearer $accessToken'},
        );

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body) as Map<String, dynamic>?;
          if (jsonData == null) {
            throw Exception('Response body is null');
          }
          print('Fetch more response: $jsonData');
          print('Fetch more type: $_selectedType');
          final searchResponse = SearchResponse.fromJson(jsonData);
          switch (_selectedType) {
            case 'track':
              _tracks.addAll(searchResponse.tracks.items);
              _tracksNextUrl = searchResponse.tracks.next;
              break;
            case 'album':
              _albums.addAll(searchResponse.albums.items);
              _albumsNextUrl = searchResponse.albums.next;
              break;
            case 'artist':
              _artists.addAll(searchResponse.artists.items);
              _artistsNextUrl = searchResponse.artists.next;
              break;
            case 'playlist':
              _playlists.addAll(searchResponse.playlists.items);
              _playlistsNextUrl = searchResponse.playlists.next;
              break;
          }
        } else {
          final errorData = json.decode(response.body) as Map<String, dynamic>?;
          final errorMsg = errorData?['error']?['message'] ?? 'Unknown error';
          throw Exception('Gagal memuat lebih banyak: $errorMsg (Status: ${response.statusCode})');
        }
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      print('Fetch more error: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _clearResults() {
    _tracks = [];
    _albums = [];
    _artists = [];
    _playlists = [];
    _tracksNextUrl = null;
    _albumsNextUrl = null;
    _artistsNextUrl = null;
    _playlistsNextUrl = null;
    _query = '';
    _errorMessage = '';
    _debounceTimer?.cancel();
  }

  void clearSearch() {
    _clearResults();
    notifyListeners();
  }

  Timer? _debounceTimer;
}