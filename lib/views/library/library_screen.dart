// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:sopotify/providers/playlist_provider.dart';
// import 'package:sopotify/providers/user_provider.dart';
// import 'package:sopotify/providers/auth_provider.dart';

// class LibraryScreen extends StatefulWidget {
//   const LibraryScreen({super.key});

//   @override
//   State<LibraryScreen> createState() => _LibraryScreenState();
// }

// class _LibraryScreenState extends State<LibraryScreen> {
//   @override
//   void initState() {
//     super.initState();
//     final spotifyAuth = context.read<SpotifyAuthProvider>();
//     final userProvider = context.read<UserProvider>();

//     if (spotifyAuth.accessToken.isNotEmpty) {
//       userProvider.fetchUserProfile(spotifyAuth.accessToken);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = context.watch<UserProvider>();
//     final playlistProvider = context.watch<PlaylistProvider>();

//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             userProvider.isLoading
//                 ? const CircularProgressIndicator()
//                 : userProvider.error.isNotEmpty
//                 ? Text(
//                     "Error: ${userProvider.error}",
//                     style: const TextStyle(color: Colors.red),
//                   )
//                 : userProvider.user == null
//                 ? const Text("No profile loaded")
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 20.w,
//                           vertical: 15.h,
//                         ),
//                         child: Row(
//                           children: [
//                             if (userProvider.user!.imageUrl != null)
//                               CircleAvatar(
//                                 backgroundImage: NetworkImage(
//                                   userProvider.user!.imageUrl!,
//                                 ),
//                                 radius: 17.5.w,
//                               ),
//                             SizedBox(width: 10.w),
//                             Text(
//                               userProvider.user!.displayName,
//                               style: TextStyle(
//                                 fontSize: 24.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Spacer(),
//                             IconButton(onPressed: () {}, icon: Icon(Icons.add)),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 20.h),
//                       playlistProvider.isLoading
//                           ? Center(child: CircularProgressIndicator())
//                           : ListView.builder(
//                               padding: EdgeInsets.symmetric(horizontal: 16.w),
//                               itemCount: playlistProvider.playlists.length,
//                               itemBuilder: (context, index) {
//                                 final playlist =
//                                     playlistProvider.playlists[index];
//                                 return Container(
//                                   padding: EdgeInsets.only(bottom: 12.h),
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       // Cover Image
//                                       Container(
//                                         width: 67.w,
//                                         height: 67.w,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                             9.r,
//                                           ),
//                                           color: Colors
//                                               .grey[900], // fallback kalau image kosong
//                                         ),
//                                         clipBehavior: Clip.antiAlias,
//                                         child: playlist.imageUrl.isNotEmpty
//                                             ? Image.network(
//                                                 playlist.imageUrl,
//                                                 fit: BoxFit.cover,
//                                               )
//                                             : const Icon(
//                                                 Icons.music_note,
//                                                 color: Colors.white,
//                                               ),
//                                       ),
//                                       SizedBox(width: 12.w),

//                                       // Playlist info
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             playlist.name,
//                                             style: TextStyle(
//                                               fontSize: 16.sp,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                           SizedBox(height: 5.h),
//                                           Text(
//                                             "${playlist.owner.displayName} • ${playlist.totalTracks} songs",
//                                             style: TextStyle(
//                                               fontSize: 12.sp,
//                                               color: Colors.grey,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                       Column(
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 width: 67.w,
//                                 height: 67.w,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(9.r),
//                                 ),
//                                 child: Image.asset(
//                                   'assets/images/playlist1.png',
//                                 ),
//                               ),
//                               Column(
//                                 children: [
//                                   Text(
//                                     'My Playlist #1',
//                                     style: TextStyle(
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(height: 5.h),
//                                   Text(
//                                     'Playlist • 20 songs',
//                                     style: TextStyle(
//                                       fontSize: 12.sp,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/providers/auth_provider.dart';
import 'package:sopotify/providers/playlist_provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Ambil playlist saat halaman dimuat
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    final authProvider = Provider.of<SpotifyAuthProvider>(context, listen: false);
    if (authProvider.accessToken.isNotEmpty) {
      playlistProvider.fetchPlaylists(context);
    }

    // Listener untuk paginasi
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          playlistProvider.hasMore &&
          !playlistProvider.isLoading) {
        playlistProvider.fetchMorePlaylists(context);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Playlists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
              playlistProvider.reset();
              playlistProvider.fetchPlaylists(context);
            },
          ),
        ],
      ),
      body: Consumer<PlaylistProvider>(
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
            controller: _scrollController,
            itemCount: playlistProvider.playlists.length + (playlistProvider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == playlistProvider.playlists.length) {
                return const Center(child: CircularProgressIndicator());
              }

              final playlist = playlistProvider.playlists[index];
              return ListTile(
                leading: playlist.imageUrl != null
                    ? Image.network(
                        playlist.imageUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.music_note),
                      )
                    : const Icon(Icons.music_note),
                title: Text(playlist.name),
                subtitle: Text('By ${playlist.ownerName} • ${playlist.totalTracks} tracks'),
                onTap: () {
                  // TODO: Navigasi ke halaman detail playlist
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tapped on ${playlist.name}')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}