
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/others/custom_size.dart';
import 'package:wisper/app/core/widgets/common/circle_icon.dart';

class Option extends StatelessWidget {
  final VoidCallback onTap;
  final String imagePath;
  final String title;
  final Color? iconColor;
  const Option({
    super.key,
    required this.onTap,
    required this.imagePath,
    required this.title,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleIconWidget(
          imagePath: imagePath,
          onTap: onTap,
          iconColor: iconColor,
          iconRadius: 22,
          radius: 20,
        ),
        heightBox4,
        Text(title, style: TextStyle(fontSize: 12.sp)),
      ],
    );
  }
}