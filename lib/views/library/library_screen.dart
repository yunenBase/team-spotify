import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sopotify/controllers/library_controller.dart';
import 'package:sopotify/views/liked_track/liked_track.dart';
import 'package:sopotify/widgets/button_menu.dart';
import 'package:sopotify/views/library/playlist_view.dart';
import 'package:sopotify/widgets/user_profile_view.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late final LibraryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LibraryController();
    _controller.init(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfileView(
              onAddPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LikedTracksScreen()),
                );
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  ButtonMenu(title: "Playlist"),
                  ButtonMenu(title: "Artist"),
                  ButtonMenu(title: "Albums"),
                  ButtonMenu(title: "Podcasts & Shows"),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              margin: EdgeInsets.symmetric(vertical: 12.h),
              child: Row(
                children: [
                  Icon(Icons.sync_alt, size: 16.sp),
                  Text(
                    "Recently Played",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.apps_rounded, size: 20.sp),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: PlaylistView(
                scrollController: _controller.scrollController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
