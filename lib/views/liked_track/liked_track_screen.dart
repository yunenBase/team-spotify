import 'package:flutter/material.dart';
import 'package:sopotify/controllers/liked_tracks_controller.dart';
import 'package:sopotify/views/liked_track/liked_track_view.dart';

class LikedTracksScreen extends StatefulWidget {
  const LikedTracksScreen({Key? key}) : super(key: key);

  @override
  _LikedTracksScreenState createState() => _LikedTracksScreenState();
}

class _LikedTracksScreenState extends State<LikedTracksScreen> {
  late final LikedTracksController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LikedTracksController();
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF00667B),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _controller.refresh(context);
        },
        child: LikedTracksView(scrollController: _controller.scrollController),
      ),
    );
  }
}
