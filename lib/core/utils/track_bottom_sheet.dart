import 'package:flutter/material.dart';

void showTrackOptionsModal({
  required BuildContext context,
  required dynamic track, // Sesuaikan tipe dengan model track kamu
  VoidCallback? onShare,
  VoidCallback? onAddToPlaylist,
  VoidCallback? onRemove,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian atas: cover + judul + artist
            Row(
              children: [
                track.album.images.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          track.album.images[0].url,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.music_note, size: 50),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        track.artists.map((a) => a.name).join(", "),
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // Menu pilihan
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text("Share"),
              onTap: () {
                Navigator.pop(context);
                onShare?.call();
              },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text("Add to playlist"),
              onTap: () {
                Navigator.pop(context);
                onAddToPlaylist?.call();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Remove from Liked Songs"),
              onTap: () {
                Navigator.pop(context);
                onRemove?.call();
              },
            ),
          ],
        ),
      );
    },
  );
}