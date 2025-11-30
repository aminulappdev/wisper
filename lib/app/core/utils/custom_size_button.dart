
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSizeButton extends StatelessWidget {
  final String title;
  final Color iconColor;
  final Color textColor;
  final IconData? icon;
  final Color color;
  final VoidCallback ontap;
  final double height;
  final double width;
  const CustomSizeButton({
    super.key,
    required this.title,
    this.icon,
    required this.ontap,
    required this.color,
    required this.textColor,
    required this.iconColor, required this.height, required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            SizedBox(width: 8,),
            icon == null
                ? const SizedBox()
                : Icon(icon, color: iconColor, size: 16),
          ],
        ),
      ),
    );
  }
}
