import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonMenu extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const ButtonMenu({
    required this.title,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(45),
      child: InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 18.w,
            vertical: 8.5.h,
          ),
          margin: EdgeInsets.only(right: 8.w),
          height: 33.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(45),
            border: Border.all(
              color: const Color(0xFF7F7F7F),
              width: 0.6,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}