import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/gen/assets.gen.dart';

class InfoCard extends StatelessWidget {
  final String imagePath;
  final VoidCallback editOnTap;
  final String title;
  final String memberInfo;
  final Widget child;
  final bool isTrailing;
  final VoidCallback? trailingOnTap;
  final GlobalKey? trailingKey; // Add GlobalKey parameter

  const InfoCard({
    super.key,
    required this.imagePath,
    required this.editOnTap,
    required this.title,
    required this.memberInfo,
    required this.child,
    this.isTrailing = false,
    this.trailingOnTap,
    this.trailingKey, // Include trailingKey in constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: const Color(0xff121212),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80.h, width: 20.w),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleIconWidget(
                        color: const Color(0xff051B33),
                        iconColor: const Color(0xff1F7DE9),
                        iconRadius: 40,
                        radius: 38,
                        imagePath: imagePath,
                        onTap: () {},
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleIconWidget(
                          color: const Color(0xff3C90CB),
                          iconColor: const Color.fromARGB(255, 255, 255, 255),
                          iconRadius: 10,
                          radius: 10,
                          imagePath: Assets.images.edit.keyName,
                          onTap: editOnTap,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    memberInfo,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color:  LightThemeColors.themeGreyColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  child,
                ],
              ),
              CircleIconWidget(
                key: trailingKey, // Assign the GlobalKey here
                radius: 14,
                iconRadius: 18,
                imagePath: Assets.images.moreHor.keyName,
                onTap: trailingOnTap ?? () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
