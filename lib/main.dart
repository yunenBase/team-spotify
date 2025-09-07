import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/providers/auth_provider.dart';
import 'package:sopotify/providers/bottom_navbar_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sopotify/providers/liked_track_provider.dart';
import 'package:sopotify/providers/playlist_provider.dart';
import 'package:sopotify/providers/search_provider.dart';
import 'package:sopotify/providers/user_provider.dart';
import 'package:sopotify/views/login/login_screen.dart';
import 'package:sopotify/widgets/bottom_navbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SpotifyAuthProvider()),
        ChangeNotifierProvider(create: (_) => NavProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PlaylistProvider()),
        ChangeNotifierProvider(create: (_) => LikedTracksProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(428, 926),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Spotify Flutter App',
          theme: ThemeData.dark(),
          initialRoute: "/login",
          routes: {
            "/login": (context) => LoginScreen(),

            // wrapper dengan BottomNavigationBar
            "/home": (context) => BottomNavExample(),
          },
        );
      },
    );
  }
}
