import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/image_container_widget.dart';
import 'package:wisper/app/modules/profile/views/others_profile_screen.dart';
import 'package:wisper/gen/assets.gen.dart';

class PostCard extends StatelessWidget {
  final Widget trailing;
  final String? ownerName;
  final String? ownerImage;
  final String? ownerProfession;
  final String? postImage;
  final String? postDescription;
  final String? postTime;
  final String? views;
  const PostCard({
    super.key,
    required this.trailing,
    this.ownerName,
    this.ownerImage,
    this.ownerProfession,
    this.postImage,
    this.postDescription,
    this.postTime,
    this.views,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => const OthersProfileScreen());
          },
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            radius: 20.r,
            backgroundImage: NetworkImage(ownerImage ?? ''),
          ),
        ),
        widthBox8,
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ownerName ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        ownerProfession ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: LightThemeColors.themeGreyColor,
                        ),
                      ),
                    ],
                  ),
                  trailing,
                ],
              ),
              heightBox10,
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade400, width: 0.4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageContainer(
                      image: postImage ?? '',
                      height: 168,
                      width: double.infinity,
                      borderRadius: 8,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        postDescription ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              heightBox8,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CrashSafeImage(
                        Assets.images.visibility.keyName,
                        height: 12,
                      ),
                      widthBox4,
                      Text(
                        '$views views',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: LightThemeColors.themeGreyColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    postTime ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: LightThemeColors.themeGreyColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
