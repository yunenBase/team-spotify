import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spotifyAuth = Provider.of<SpotifyAuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Status: ${spotifyAuth.loginStatus}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (spotifyAuth.username.isNotEmpty)
              Text(
                "Username: ${spotifyAuth.username}",
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            if (spotifyAuth.accessToken.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Access Token:\n${spotifyAuth.accessToken}",
                  textAlign: TextAlign.center,
                ),
              )
            else
              const Text(
                "No access token found. Please login first.",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
