import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/providers/liked_track_provider.dart';
import 'package:sopotify/views/liked_track/liked_track.dart';

class LikedSongsCard extends StatelessWidget {
  const LikedSongsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        "assets/images/icon_spotify.png",
        width: 67.w,
        height: 67.w,
        fit: BoxFit.contain,
      ),
      title: Text("Liked Songs"),
      subtitle: Consumer<LikedTracksProvider>(
        builder: (context, provider, child) {
          return Text('${provider.totalTracks} liked songs');
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LikedTracksScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  // Animasi slide
                  const begin = Offset(1.0, 0.0); // mulai dari kanan
                  const end = Offset.zero;
                  final slideTween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.easeInOut));

                  // Animasi fade
                  final fadeTween = Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).chain(CurveTween(curve: Curves.easeInOut));

                  return SlideTransition(
                    position: animation.drive(slideTween),
                    child: FadeTransition(
                      opacity: animation.drive(fadeTween),
                      child: child,
                    ),
                  );
                },
            transitionDuration: const Duration(
              milliseconds: 450,
            ), // lebih smooth
          ),
        );
      },
    );
  }
}
