import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabelData extends StatelessWidget {
  final Color? bgColor;
  final String title;
  final double? horizontalPadding;
  final double? verticalPadding;

  const LabelData({
    super.key,
    required this.title,
    this.bgColor,
    this.horizontalPadding,
    this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: bgColor ?? Color(0xff1B1E25).withValues(alpha: 0.5),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding ?? 4.0,
          horizontal: horizontalPadding ?? 6,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
