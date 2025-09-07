// import 'package:flutter/material.dart';

// class SearchScreen extends StatelessWidget {
//   const SearchScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Dummy data
//     final playlists = [
//       {"name": "Chill Vibes", "imageUrl": ""},
//       {"name": "Workout Hits", "imageUrl": ""},
//       {"name": "Mood Booster", "imageUrl": ""},
//       {"name": "Late Night", "imageUrl": ""},
//       {"name": "Top Hits", "imageUrl": ""},
//       {"name": "Relaxing Tunes", "imageUrl": ""},
//     ];

//     return Scaffold(
//       appBar: AppBar(title: const Text("Dummy Playlist Grid")),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: GridView.builder(
//           itemCount: playlists.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2, // 2 kolom
//             mainAxisSpacing: 8,
//             crossAxisSpacing: 12,
//             childAspectRatio: 2.5, // lebar lebih besar dari tinggi
//           ),
//           itemBuilder: (context, index) {
//             final playlist = playlists[index];

//             return Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.grey[900],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Container(
//                       width: 60,
//                       height: 60,
//                       color: Colors.grey[700], // dummy image
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Flexible(
//                     child: Text(
//                       playlist["name"]!,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
  


import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  double appBarOpacity = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.axis == Axis.vertical) {
            final offset = scrollNotification.metrics.pixels;
            final newOpacity = (offset / 200).clamp(0.0, 1.0); // 200px jarak transisi
            if (newOpacity != appBarOpacity) {
              setState(() {
                appBarOpacity = newOpacity;
              });
            }
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height * 0.5, // setengah layar
              backgroundColor: Colors.blue.withOpacity(appBarOpacity),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Liked Songs",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "123 songs",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ListTile(
                  title: Text("Song $index"),
                  subtitle: const Text("Artist"),
                ),
                childCount: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
