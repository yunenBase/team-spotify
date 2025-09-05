import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spotifyAuth = Provider.of<SpotifyAuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: spotifyAuth.isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // error message
                  if (spotifyAuth.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        spotifyAuth.errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const Text(
                    'Login to Spotify',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // tombol login
                  ElevatedButton(
                    onPressed: () async {
                      await spotifyAuth.loginWithSpotify(context);

                      if (spotifyAuth.accessToken.isNotEmpty) {
                        // setelah login → ganti layar ke home (dengan bottom navbar)
                        Navigator.pushReplacementNamed(context, "/home");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Login with Spotify"),
                  ),
                ],
              ),
      ),
    );
  }
}
