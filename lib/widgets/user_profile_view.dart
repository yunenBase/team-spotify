import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sopotify/providers/user_provider.dart';

class UserProfileView extends StatelessWidget {
  final VoidCallback onAddPressed;

  const UserProfileView({Key? key, required this.onAddPressed}) : super(key: key);

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
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  userProvider.user!.imageUrl!,
                                ),
                                radius: 17.5.w,
                              ),
                            SizedBox(width: 10.w),
                            Text(
                              // userProvider.user!.displayName,
                              "Your Library",
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: onAddPressed,
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
        );
      },
    );
  }
}