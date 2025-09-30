import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';

class CircleIconWidget extends StatelessWidget {
  final String imagePath;
  final double radius;
  final double iconRadius;
  final Color color;
  final VoidCallback onTap;
  final Color? iconColor;
  const CircleIconWidget({
    super.key,
    required this.imagePath,
    this.radius = 17,
    this.color = LightThemeColors.circleIconColor,
    required this.onTap,
    this.iconRadius = 12.5,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: color,
        radius: radius,
        child: CrashSafeImage(
          imagePath,
          height: iconRadius,
          width: iconRadius,
          color: iconColor,
        ),
      ),
    );
  }
}
