import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sopotify/views/home/playlist_grid.dart';
import 'package:sopotify/views/home/top_liked_track.dart';
import 'package:sopotify/widgets/user_profile_view.dart'; // Untuk min

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 15.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ProfileAvatar(size: 17),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications_outlined),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.history)),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.settings_outlined),
                    ),
                  ],
                ),
                PlaylistGrid(),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15.h),
                  child: Text(
                    "Your recent rotation",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                TopLikedTracksView(),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15.h),
                  child: Text(
                    "Editor's Pick",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      EditorsPick(warna: Colors.amber, teks: "Amber",),
                      EditorsPick(warna: Colors.purple, teks: "Purple",),
                      EditorsPick(warna: Colors.green, teks: "Green",),
                      EditorsPick(warna: Colors.cyan, teks: "Cyan",),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditorsPick extends StatelessWidget {
  final Color warna;
  final String teks;

  const EditorsPick({
    required this.warna,
    required this.teks,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10.h),
            color: warna,
            width: 154.w,
            height: 154.h,
          ),
          Text(teks)
        ],
      ),
    );
  }
}
