import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/others/custom_size.dart';
import 'package:wisper/app/core/widgets/common/circle_icon.dart';


class CreateWidget extends StatelessWidget {
  final VoidCallback? ontap;
  final String imagePath;
  final Color bgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  const CreateWidget({
    super.key,
    required this.imagePath,
    required this.bgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Row(
        children: [
          CircleIconWidget(
            color: bgColor,
            iconColor: iconColor,
            radius: 21,
            iconRadius: 24,
            imagePath: imagePath,
            onTap: () {},
          ),
          widthBox10,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: LightThemeColors.themeGreyColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
