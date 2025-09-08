import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oauth2_client/spotify_oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpotifyAuthProvider extends ChangeNotifier {
  String _accessToken = '';
  String _errorMessage = '';
  String _loginStatus = 'Belum Login';
  String _username = '';
  bool _isLoading = false;

  // Getter
  String get accessToken => _accessToken;
  String get errorMessage => _errorMessage;
  String get loginStatus => _loginStatus;
  String get username => _username;
  bool get isLoading => _isLoading;

  // Client ID dan redirect URI kamu
  final String clientId = dotenv.env['CLIENT_ID'] ?? '';
  final String redirectUri = dotenv.env['REDIRECT_URI'] ?? '';
  final List<String> scopes = [
    'user-read-private',
    'user-read-email',
    'playlist-read-private',
    'user-follow-read',
    'user-library-read',
    'playlist-modify-public',
    'playlist-modify-private',
  ];

  Future<void> loginWithSpotify(BuildContext context) async {
    _isLoading = true;
    _errorMessage = '';
    _loginStatus = 'Sedang login...';
    notifyListeners();

    try {
      var helper = OAuth2Helper(
        SpotifyOAuth2Client(
          redirectUri: redirectUri,
          customUriScheme: 'myspotifyapp',
        ),
        grantType: OAuth2Helper.authorizationCode,
        clientId: clientId,
        scopes: scopes,
      );

      var resp = await helper.getToken();

      if (resp != null && resp.accessToken != null) {
        _accessToken = resp.accessToken!;
        await fetchUserProfile(context);
      } else {
        throw Exception('Login gagal: Tidak mendapatkan access token');
      }
    } catch (e) {
      _errorMessage = 'Gagal login: ${e.toString()}';
      _loginStatus = 'Login Gagal';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage)));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserProfile(BuildContext context) async {
    if (_accessToken.isEmpty) {
      _errorMessage = 'Tidak ada access token untuk mengambil data pengguna';
      _loginStatus = 'Login Gagal';
      notifyListeners();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage)));
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _username = data['display_name'] ?? 'Tidak ada nama pengguna';
        _loginStatus = 'Login Berhasil';
        print('Access token : $_accessToken');
      } else {
        final errorData = json.decode(response.body);
        final errorMsg = errorData['error']?['message'] ?? 'Unknown error';
        throw Exception('Gagal mengambil data pengguna: $errorMsg');
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      _loginStatus = 'Login Gagal';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage)));
    } finally {
      notifyListeners();
    }
  }
}
