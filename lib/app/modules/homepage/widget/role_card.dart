import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/profile/views/others_profile_screen.dart';
import 'package:wisper/gen/assets.gen.dart';

class RoleCard extends StatelessWidget {
  final String? title;
  final String? imagePath;
  final String? role;
  final int? post;
  final int? recommendations;
  final VoidCallback? addOnTap;
  final VoidCallback? messagesOnTap;

  final String? id;
  const RoleCard({
    super.key,
    this.id,
    this.title,
    this.imagePath,
    this.role,
    this.post,
    this.recommendations,
    this.addOnTap,
    this.messagesOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(() => OthersProfileScreen(userId: id ?? ''));
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundImage: AssetImage(Assets.images.image.keyName),
                  ),
                  widthBox8,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        role ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: LightThemeColors.themeGreyColor,
                        ),
                      ),
                      heightBox4,
                      Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                '$post',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 8,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),

                              Text(
                                ' Post',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 8,
                                  color: LightThemeColors.themeGreyColor,
                                ),
                              ),
                            ],
                          ),
                          widthBox14,
                          Row(
                            children: [
                              Text(
                                '$recommendations',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 8,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),

                              Text(
                                ' Recommendation',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 8,
                                  color: LightThemeColors.themeGreyColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                CircleIconWidget(
                  imagePath: Assets.images.unselectedChat.keyName,
                  onTap: () {
                    messagesOnTap!();
                  },
                  iconRadius: 18.r,
                ),
                widthBox8,
                SizedBox(
                  height: 30.h,
                  width: 60.w,
                  child: CustomElevatedButton(
                    borderRadius: 50,
                    textSize: 12.sp,
                    title: '+ Add',
                    onPress: addOnTap,
                  ),
                ),
              ],
            ),
          ],
        ),
        heightBox20,
        StraightLiner(height: 0.4, color: Color(0xff454545)),
      ],
    );
  }
}
