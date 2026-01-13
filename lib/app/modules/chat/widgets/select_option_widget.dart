import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/others/custom_size.dart';

class SelectOptionWidget extends StatelessWidget {
  const SelectOptionWidget({
    super.key,
    required this.currentIndex,
    required this.selectedIndex,
    required this.title,
    required this.lineColor,
  });

  final int currentIndex;
  final int selectedIndex;
  final String title;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: "Segoe UI",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: selectedIndex == currentIndex
                ? LightThemeColors.blueColor
                : const Color(0xff93A4B0),
          ),
        ),
        heightBox4,
        Container(
          height: 2.h,
          width: 40.w,
          color: selectedIndex == currentIndex ? lineColor : Colors.transparent,
        ),
      ],
    );
  }
}
