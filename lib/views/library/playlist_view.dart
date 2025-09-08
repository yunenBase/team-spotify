import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/providers/playlist_provider.dart';
import 'package:sopotify/widgets/liked_songs_card.dart';

class PlaylistView extends StatelessWidget {
  final ScrollController scrollController;

  const PlaylistView({Key? key, required this.scrollController})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, playlistProvider, child) {
        if (playlistProvider.isLoading && playlistProvider.playlists.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (playlistProvider.errorMessage.isNotEmpty) {
          return Center(child: Text(playlistProvider.errorMessage));
        }
        if (playlistProvider.playlists.isEmpty) {
          return const Center(child: Text('Tidak ada playlist ditemukan'));
        }
        return ListView.builder(
          controller: scrollController,
          itemCount:
              playlistProvider.playlists.length +
              (playlistProvider.hasMore ? 1 : 0) +
              1, // +1 untuk header
          itemBuilder: (context, index) {
            if (index == 0) {
              // Header di paling atas list
              return LikedSongsCard();
            }

            // geser index agar sesuai dengan data playlist
            final playlistIndex = index - 1;

            // Loader ketika masih ada data yang akan diambil
            if (playlistIndex == playlistProvider.playlists.length) {
              return const Center(child: CircularProgressIndicator());
            }

            final playlist = playlistProvider.playlists[playlistIndex];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 4.h),
              child: ListTile(
                leading: playlist.imageUrl != null
                    ? Image.network(
                        playlist.imageUrl!,
                        width: 67.w,
                        height: 67.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.music_note),
                      )
                    : const Icon(Icons.music_note),
                title: Text(playlist.name),
                subtitle: Text(
                  '${playlist.ownerName} • ${playlist.totalTracks} tracks',
                ),
                onTap: () {},
              ),
            );
          },
        );
      },
    );
  }
}
