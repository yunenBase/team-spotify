import 'package:flutter/material.dart';
import 'package:sopotify/controllers/liked_tracks_controller.dart';
import 'package:sopotify/widgets/liked_track.dart';

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
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.refresh(context),
          ),
        ],
      ),
      body: LikedTracksView(scrollController: _controller.scrollController),
    );
  }
}