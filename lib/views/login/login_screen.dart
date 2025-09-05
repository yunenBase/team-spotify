// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sopotify/providers/auth_provider.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final spotifyAuth = Provider.of<SpotifyAuthProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Center(
//         child: spotifyAuth.isLoading
//             ? const CircularProgressIndicator()
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // error message
//                   if (spotifyAuth.errorMessage.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         spotifyAuth.errorMessage,
//                         style: const TextStyle(color: Colors.red),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),

//                   const Text(
//                     'Login to Spotify',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 20),

//                   // tombol login
//                   ElevatedButton(
//                     onPressed: () async {
//                       await spotifyAuth.loginWithSpotify(context);

//                       if (spotifyAuth.accessToken.isNotEmpty) {
//                         // setelah login → ganti layar ke home (dengan bottom navbar)
//                         Navigator.pushReplacementNamed(context, "/home");
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 30, vertical: 15),
//                       backgroundColor: Colors.green,
//                       foregroundColor: Colors.white,
//                     ),
//                     child: const Text("Login with Spotify"),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spotifyAuth = Provider.of<SpotifyAuthProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Gambar latar belakang bg_login_screen.png dengan dimensi 428 x 465
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: 428.w,
              height: 465.h,
              child: Image.asset(
                'assets/images/bg_login_screen.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Container hitam di belakang teks "Million of Songs."
          Positioned(
            top: 397
                .h, // Disesuaikan agar sejajar dengan teks "Million of Songs."
            left: 187.w, // Memusatkan: 46.w + (337.w - 55.w) / 2
            child: Container(
              width: 62.w,
              height: 62.h,
              color: Color(0xFF121212),
            ),
          ),
          // Pesan error atau loading
          if (spotifyAuth.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (spotifyAuth.errorMessage.isNotEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Text(
                  spotifyAuth.errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          // Gambar icon_spotify.png
          Positioned(
            top: 325.h,
            left: 46.w,
            child: SizedBox(
              width: 337.w,
              child: Center(
                child: Image.asset(
                  'assets/images/icon_spotify.png',
                  width: 100.w,
                  height: 100.h,
                ),
              ),
            ),
          ),
          // Teks "Million of Songs." dan "Free on Spotify." dalam Column
          Positioned(
            top: 415.h,
            left: 46.w,
            child: SizedBox(
              width: 337.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Million of Songs.',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'Free on Spotify.',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tombol pertama (asli)
          Positioned(
            top: 519.h,
            left: 46.w,
            child: SizedBox(
              width: 337.w,
              height: 49.h,
              child: ElevatedButton(
                onPressed: () async {
                  await spotifyAuth.loginWithSpotify(context);
                  if (spotifyAuth.accessToken.isNotEmpty) {
                    // Pindah ke layar home setelah login
                    Navigator.pushReplacementNamed(context, "/home");
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 15.h,
                  ),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45.r),
                  ),
                ),
                child: Text(
                  "Sign up free",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Tombol kedua, ketiga, keempat, dan teks Log In dalam Column
          Positioned(
            top: 580.h,
            left: 46.w,
            child: Column(
              children: [
                SignInMethod(
                  image: 'assets/images/icon_google.png',
                  text: 'Continue with Google',
                ),
                SizedBox(height: 12.h),
                SignInMethod(
                  image: 'assets/images/icon_facebook.png',
                  text: 'Continue with Facebook',
                ),
                SizedBox(height: 12.h),
                SignInMethod(
                  image: 'assets/images/icon_apple.png',
                  text: 'Continue with Apple',
                ),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: () async {
                    await spotifyAuth.loginWithSpotify(context);
                    if (spotifyAuth.accessToken.isNotEmpty) {
                      // Pindah ke layar home setelah login
                      Navigator.pushReplacementNamed(context, "/home");
                    }
                    print("Log In ditekan");
                    // Contoh navigasi: Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SignInMethod extends StatelessWidget {
  final String image;
  final String text;

  const SignInMethod({super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 337.w,
      height: 49.h,
      child: ElevatedButton(
        onPressed: () async {
          print("$text ditekan");
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45.r),
            side: BorderSide(color: Color(0xFFFFFFFF), width: 0.6.w),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 10.w),
                Image.asset(image, width: 18.w, height: 18.h),
              ],
            ),
            Text(text, style: TextStyle(fontSize: 16.sp)),
            SizedBox(width: 28.w),
          ],
        ),
      ),
    );
  }
}