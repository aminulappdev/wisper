
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';

class CallFeature extends StatelessWidget {
  final String? imagePath;
  final String? title;
  final VoidCallback? onTap;
  final Color? color;
  const CallFeature({
    super.key,
    this.imagePath,
    this.title,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleIconWidget(
          radius: 28,
          iconRadius: 20,
          color: color ?? Colors.white.withValues(alpha: 0.20),
          imagePath: imagePath!,
          onTap: onTap!,
        ),
        heightBox8,
        Text(
          title!,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
