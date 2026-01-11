
import 'package:flutter/material.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';

class DetailsCard extends StatelessWidget {
  final Color bgColor;
  final Color borderColor;
  final double? width;
  final double? borderWidth;
  final double borderRadius;
  final Widget child;
  const DetailsCard({
    super.key,
    this.bgColor = LightThemeColors.detailsCardBackgroundColor2,
    this.borderColor = LightThemeColors.borderColor,
    this.width,
    this.borderRadius = 10,
    required this.child, this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,

      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth ?? 1.5),
      ),
      child: child,
    );
  }
}