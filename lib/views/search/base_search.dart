import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/providers/user_provider.dart';
import 'package:sopotify/views/search/search_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header Row
                Row(
                  children: [
                    // Avatar dengan kondisi loading/error/null
                    if (userProvider.isLoading)
                      SizedBox(
                        width: 35.w,
                        height: 35.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    else if (userProvider.error.isNotEmpty)
                      const CircleAvatar(
                        child: Icon(Icons.error, color: Colors.red),
                      )
                    else if (userProvider.user?.imageUrl != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          userProvider.user!.imageUrl!,
                        ),
                        radius: 17.w,
                      )
                    else
                      const CircleAvatar(child: Icon(Icons.person)),

                    SizedBox(width: 10.w),

                    // Title
                    Text(
                      "Search",
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    // Add button
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt_outlined),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            DeepSearchScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              // Animasi slide
                              const begin = Offset(
                                1.0,
                                0.0,
                              ); // mulai dari kanan
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
                  child: Container(
                    width: 393.w,
                    height: 46.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 13.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.black, size: 21.w),
                        SizedBox(width: 11.w),
                        Text(
                          "Artists, songs, or podcasts",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 👇 Tempatkan konten lainnya di bawah sini
                Expanded(
                  child: ListView(
                    children: [
                      Teks(title: "Your top genres"),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 192.w / 109.h,
                        children: [
                          CardRecomendationSearch(
                            title: "Pop",
                            color: Colors.purple,
                          ),
                          CardRecomendationSearch(
                            title: "Indie",
                            color: Colors.lightGreen,
                          ),
                        ],
                      ),
                      Teks(title: "Popular podcast categories"),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 192.w / 109.h,
                        children: [
                          CardRecomendationSearch(
                            title: "News & Politics",
                            color: Colors.blue,
                          ),
                          CardRecomendationSearch(
                            title: "Comedy",
                            color: Colors.orange,
                          ),
                        ],
                      ),
                      Teks(title: "Browse All"),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 192.w / 109.h,
                        children: [
                          CardRecomendationSearch(
                            title: "2021 Wrapped",
                            color: Colors.lime[700]!,
                          ),
                          CardRecomendationSearch(
                            title: "Podcast",
                            color: Colors.blueAccent,
                          ),
                          CardRecomendationSearch(
                            title: "Made For You",
                            color: Colors.green[600]!,
                          ),
                          CardRecomendationSearch(
                            title: "Charts",
                            color: Colors.redAccent,
                          ),
                          CardRecomendationSearch(
                            title: "New Releases",
                            color: Colors.deepPurpleAccent,
                          ),
                          CardRecomendationSearch(
                            title: "Discover",
                            color: Colors.orangeAccent,
                          ),
                          CardRecomendationSearch(
                            title: "Concerts",
                            color: Colors.teal,
                          ),
                          CardRecomendationSearch(
                            title: "Genres & Moods",
                            color: Colors.pinkAccent,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Teks extends StatelessWidget {
  final String title;

  const Teks({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h, bottom: 20.h),
      child: Text(
        title,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CardRecomendationSearch extends StatelessWidget {
  final String title;
  final Color color;

  const CardRecomendationSearch({
    required this.title,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
