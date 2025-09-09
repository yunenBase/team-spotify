import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/core/utils/track_bottom_sheet.dart';
import 'package:sopotify/providers/liked_track_provider.dart';
import 'dart:math'; // Untuk min

class TopLikedTracksView extends StatelessWidget {
  const TopLikedTracksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LikedTracksProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.likedTracks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.errorMessage.isNotEmpty) {
          return Center(child: Text(provider.errorMessage));
        }
        if (provider.likedTracks.isEmpty) {
          return const Center(child: Text('Tidak ada liked tracks ditemukan'));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: min(3, provider.likedTracks.length),
          itemBuilder: (context, index) {
            final item = provider.likedTracks[index];
            final track = item.track;
            return ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 4.h,
              ),
              leading: track.album.images.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(
                        4.r,
                      ), // bisa ganti sesuai kebutuhan
                      child: Image.network(
                        track.album.images[0].url,
                        width: 50.w,
                        height: 50.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 50.w,
                          height: 50.h,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: const Icon(Icons.music_note, size: 24),
                        ),
                      ),
                    )
                  : Container(
                      width: 50.w,
                      height: 50.h,
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Icon(Icons.music_note, size: 24),
                    ),
              title: Text(
                track.name,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                track.artists.isNotEmpty
                    ? track.artists.map((a) => a.name).join(', ')
                    : 'Unknown Artist',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                onPressed: () {
                  showTrackOptionsModal(
                    context: context,
                    track: track,
                    onShare: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Shared ${track.name}')),
                      );
                    },
                    onAddToPlaylist: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added ${track.name} to playlist'),
                        ),
                      );
                    },
                    onRemove: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Removed ${track.name} from Liked Songs',
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.more_vert),
              ),
            );
          },
        );
      },
    );
  }
}
