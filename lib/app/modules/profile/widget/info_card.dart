import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/gen/assets.gen.dart';

class InfoCard extends StatelessWidget {
  final bool? isEditImage;
  final String imagePath;
  final VoidCallback editOnTap;
  final String title;
  final String memberInfo;
  final Widget child;
  final bool isTrailing;
  final VoidCallback? trailingOnTap; 
  final GlobalKey? trailingKey; 
  final VoidCallback? showMember;
  final bool? isBack;
  
  const InfoCard({
    super.key,
    required this.imagePath,
    required this.editOnTap,
    required this.title,
    required this.memberInfo,
    required this.child,
    this.isTrailing = true,
    this.trailingOnTap,
    this.trailingKey,
    this.showMember,
    this.isEditImage = true,
    this.isBack = false,
  });

  // Helper to safely determine the correct ImageProvider and whether it's default
  ({ImageProvider provider, bool isDefault}) _getImageInfo(String path, String defaultAsset) {
    if (path.isEmpty) {
      return (provider: AssetImage(defaultAsset), isDefault: true);
    }
 
    // Local file path
    if (path.startsWith('/') ||
        path.contains('/storage/') ||
        path.contains('/data/')) { 
      final file = File(path);
      if (file.existsSync()) {
        return (provider: FileImage(file), isDefault: false);
      }
    }

    // Network URL
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return (provider: NetworkImage(path), isDefault: false);
    }

    // Fallback to default asset
    return (provider: AssetImage(defaultAsset), isDefault: true);
  }

  @override
  Widget build(BuildContext context) {
    final String defaultAsset = Assets.images.person.keyName;
    final imageInfo = _getImageInfo(imagePath, defaultAsset);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: const Color(0xff121212),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.h),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isBack == true
                  ? CircleIconWidget(
                      radius: 14,
                      iconRadius: 14,
                      imagePath: Assets.images.arrowBack.keyName,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  : Container(),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundColor: Colors.grey.shade800,
                        child: Padding(
                          // যদি ডিফল্ট অ্যাসেট হয়, তাহলে padding যোগ করা হবে
                          padding: EdgeInsets.all(imageInfo.isDefault ? 12.0.r : 0.0),
                          child: CircleAvatar(
                            radius: 40.r,
                            backgroundImage: imageInfo.provider,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                      if (isEditImage == true)
                        Positioned(
                          bottom: 0, 
                          right: 0,
                          child: CircleIconWidget(
                            color: const Color(0xff3C90CB),
                            iconColor: Colors.white,
                            iconRadius: 10,
                            radius: 10,
                            imagePath: Assets.images.edit.keyName,
                            onTap: editOnTap,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: 200.w,
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: showMember ?? () {},
                    child: SizedBox(
                      width: 200.w,
                      child: Center(
                        child: Text(
                          memberInfo,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: LightThemeColors.themeGreyColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  child,
                ],
              ),
              isTrailing == true
                  ? CircleIconWidget(
                      key: trailingKey,
                      radius: 14,
                      iconRadius: 18,
                      imagePath: Assets.images.moreHor.keyName,
                      onTap: trailingOnTap ?? () {},
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}