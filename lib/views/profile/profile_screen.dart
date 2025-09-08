import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/providers/playlist_provider.dart';
import 'package:sopotify/providers/user_provider.dart';
import 'package:sopotify/widgets/user_profile_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, PlaylistProvider>(
      builder: (context, userProvider, playlistProvider, child) {
        if (userProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userProvider.error.isNotEmpty) {
          return Center(
            child: Text(
              "Error: ${userProvider.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (userProvider.user == null) {
          return const Center(child: Text("No profile"));
        }

        final userName = userProvider.user!.displayName;
        final userPlaylists = playlistProvider.playlists
            .where((playlist) => playlist.ownerName == userName)
            .toList();

        return Scaffold(
          body: Stack(
            children: [
              /// === Background image ===
              Positioned.fill(
                child: Image.asset(
                  'assets/images/bg_profile.png',
                  fit: BoxFit.cover,
                ),
              ),

              /// === Scrollable content di atas gambar ===
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 40.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// === Profile section ===
                        UserProfileWidget(),
                        Container(
                          margin: EdgeInsets.only(left: 20.h),
                          child: Text(
                            "Your Playlists",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),

                        if (userPlaylists.isEmpty)
                          const Text(
                            "No playlists found",
                            style: TextStyle(color: Colors.white70),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: userPlaylists.length,
                            itemBuilder: (context, index) {
                              final playlist = userPlaylists[index];
                              return ListTile(
                                leading: playlist.imageUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          playlist.imageUrl!,
                                          width: 67.h,
                                          height: 67.w,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.music_note,
                                        color: Colors.white,
                                      ),
                                title: Text(
                                  playlist.name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  "by ${playlist.ownerName}",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
