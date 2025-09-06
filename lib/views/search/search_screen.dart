import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    final playlists = [
      {"name": "Chill Vibes", "imageUrl": ""},
      {"name": "Workout Hits", "imageUrl": ""},
      {"name": "Mood Booster", "imageUrl": ""},
      {"name": "Late Night", "imageUrl": ""},
      {"name": "Top Hits", "imageUrl": ""},
      {"name": "Relaxing Tunes", "imageUrl": ""},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Dummy Playlist Grid")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: playlists.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 kolom
            mainAxisSpacing: 8,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5, // lebar lebih besar dari tinggi
          ),
          itemBuilder: (context, index) {
            final playlist = playlists[index];

            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[700], // dummy image
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      playlist["name"]!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
  