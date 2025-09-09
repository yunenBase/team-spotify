import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/providers/playlist_provider.dart';
import 'dart:math'; // Untuk min

class PlaylistGrid extends StatelessWidget {
  const PlaylistGrid({Key? key}) : super(key: key);

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

        return Container(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.8,
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 8.w,
            ),
            itemCount: min(6, playlistProvider.playlists.length), // Batasi ke 6 teratas
            itemBuilder: (context, index) {
              final playlist = playlistProvider.playlists[index];
              return GestureDetector(
                onTap: () {
                  // Tambahkan navigasi atau aksi saat playlist diklik
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected: ${playlist.name}')),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: playlist.imageUrl != null
                          ? Image.network(
                              playlist.imageUrl!,
                              width: 50.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 50.w,
                                height: 50.h,
                                color: Theme.of(context).colorScheme.surfaceVariant,
                                child: const Icon(Icons.music_note, size: 24),
                              ),
                            )
                          : Container(
                              width: 50.w,
                              height: 50.h,
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              child: const Icon(Icons.music_note, size: 24),
                            ),
                    ),
                    title: Text(
                      playlist.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}