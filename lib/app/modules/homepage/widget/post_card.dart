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
  const PostCard({super.key, required this.trailing});

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
            radius: 20.r,
            backgroundImage: AssetImage(Assets.images.image.keyName),
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
                        'Aminul Islam',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Flutter Developer',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: LightThemeColors.themeGreyColor,
                        ),
                      ),
                    ],
                  ),
                  trailing
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
                      image: Assets.images.image02.keyName,
                      height: 168,
                      width: double.infinity,
                      borderRadius: 8,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'We are seeking a Senior Designer to lead the design of intuitive and user-centric mobile applications.',
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
                        '110 views',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: LightThemeColors.themeGreyColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '20 mins',
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
