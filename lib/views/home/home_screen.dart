import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spotifyAuth = Provider.of<SpotifyAuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Spotify Integration')),
      body: Center(
        child: spotifyAuth.isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (spotifyAuth.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        spotifyAuth.errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Text(
                    'Status: ${spotifyAuth.loginStatus}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (spotifyAuth.username.isNotEmpty)
                    Text(
                      'Username: ${spotifyAuth.username}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 20),
                  if (spotifyAuth.accessToken.isEmpty)
                    ElevatedButton(
                      onPressed: () =>
                          spotifyAuth.loginWithSpotify(context),
                      child: const Text('Login with Spotify'),
                    ),
                  if (spotifyAuth.accessToken.isNotEmpty)
                    Text(
                      'Access Token:\n${spotifyAuth.accessToken}',
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
      ),
    );
  }
}
