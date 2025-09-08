import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/core/constant/app_colors.dart';
import 'package:sopotify/core/utils/track_bottom_sheet.dart';
import 'package:sopotify/providers/liked_track_provider.dart';
import 'package:sopotify/widgets/search_and_short.dart';

class LikedTracksView extends StatelessWidget {
  final ScrollController scrollController;

  const LikedTracksView({Key? key, required this.scrollController})
    : super(key: key);

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
          controller: scrollController,
          itemCount:
              provider.likedTracks.length + 1 + (provider.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            // Item pertama: Gambar background + Header
            if (index == 0) {
              return Stack(
                children: [
                  Container(
                    width: double.infinity, // Adjust width as needed
                    height: 300.h, // Adjust height as needed
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF00657c),
                          Colors.transparent, // Black for the bottom
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchAndShort(),
                      SizedBox(height: 75.h),
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Text(
                          'Liked Songs',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          '${provider.totalTracks} songs',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.download),
                            color: Colors.white,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.shuffle),
                            iconSize: 35,
                            color: AppColors.green,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.play_circle),
                            iconSize: 60,
                            color: AppColors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            }
            // Item terakhir: Loading indicator untuk paginasi
            if (index == provider.likedTracks.length + 1) {
              return const Center(child: CircularProgressIndicator());
            }
            final trackIndex = index - 1; // Kurangi 1 karena header di index 0
            final item = provider.likedTracks[trackIndex];
            final track = item.track;
            return ListTile(
              leading: track.album.images.isNotEmpty
                  ? Image.network(
                      track.album.images[0].url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.music_note),
                    )
                  : const Icon(Icons.music_note),
              title: Text(track.name),
              subtitle: Text(
                '${track.artists.map((a) => a.name)}',
                // .join(', ')} • ${track.album.name} • Added: ${item.addedAt}
              ),
              trailing: IconButton(
                onPressed: () {
                  showTrackOptionsModal(
                    context: context,
                    track: track,
                    onShare: () {
                      // Implementasi aksi share
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Shared ${track.name}')),
                      );
                    },
                    onAddToPlaylist: () {
                      // Implementasi aksi tambah ke playlist
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added ${track.name} to playlist')),
                      );
                    },
                    onRemove: () {
                      // Implementasi aksi hapus dari liked songs
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Removed ${track.name} from Liked Songs')),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.more_vert),
              ),

              // Text(
              //   '${(track.durationMs / 60000).toStringAsFixed(2)} min',
              // ),
              // onTap: () {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(content: Text('Tapped on ${track.name}')),
              //   );
              // },
            );
          },
        );
      },
    );
  }
}
