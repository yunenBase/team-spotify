import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/core/utils/navigation_helper.dart';
import 'package:sopotify/providers/user_provider.dart';
import 'package:sopotify/views/profile/profile_screen.dart';

class UserProfileView extends StatelessWidget {
  final VoidCallback onAddPressed;

  const UserProfileView({Key? key, required this.onAddPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 15.h),
          child: Row(
            children: [
              ProfileAvatar(size: 17, onProfilePressed: ProfileScreen(),),
              SizedBox(width: 10.w),
              Text(
                // userProvider.user!.displayName,
                "Your Library",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(onPressed: onAddPressed, icon: const Icon(Icons.add)),
            ],
          ),
        );
      },
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final int? size;
  final Widget? onProfilePressed;

  const ProfileAvatar({Key? key, required this.size, this.onProfilePressed, })
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Container(
          // padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
          child: userProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : userProvider.error.isNotEmpty
              ? Text(
                  "Error: ${userProvider.error}",
                  style: const TextStyle(color: Colors.red),
                )
              : userProvider.user == null
              ? const Text("No profile loaded")
              : Row(
                  children: [
                    if (userProvider.user!.imageUrl != null)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            createSlideFadeRoute(onProfilePressed!),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            userProvider.user!.imageUrl!,
                          ),
                          radius: size?.w,
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }
}

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
          child: userProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : userProvider.error.isNotEmpty
              ? Text(
                  "Error: ${userProvider.error}",
                  style: const TextStyle(color: Colors.red),
                )
              : userProvider.user == null
              ? const Text("No profile loaded")
              : Row(
                  children: [
                    if (userProvider.user!.imageUrl != null)
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              backgroundColor: const Color.fromARGB(
                                137,
                                0,
                                0,
                                0,
                              ),
                              child: GestureDetector(
                                onTap: () => Navigator.pop(
                                  context,
                                ), // tutup kalau ditekan lagi
                                child: InteractiveViewer(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.r),
                                    child: Image.network(
                                      userProvider.user!.imageUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            userProvider.user!.imageUrl!,
                          ),
                          radius: 40.w,
                        ),
                      ),

                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // userProvider.user!.displayName,
                          userProvider.user!.displayName,
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(userProvider.user!.email),
                        Text(
                          userProvider.user!.followers != null
                              ? "${userProvider.user!.followers} followers"
                              : "No followers info",
                        ),
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }
}
