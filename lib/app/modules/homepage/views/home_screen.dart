import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/homepage/views/post_section.dart'
    show PostSection;
import 'package:wisper/app/modules/homepage/widget/post_card.dart';
import 'package:wisper/gen/assets.gen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            heightBox40,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Explore',
                  style: TextStyle(
                    fontFamily: "Segoe UI",
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Row(
                  children: [
                    CircleIconWidget(
                      imagePath: Assets.images.search.keyName,
                      onTap: () {},
                      iconRadius: 18.r,
                    ),
                    widthBox8,
                    CircleIconWidget(
                      imagePath: Assets.images.moreHor.keyName,
                      onTap: () {},
                      iconRadius: 18.r,
                    ),
                  ],
                ),
              ],
            ),

            heightBox12,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'Posts',
                      style: TextStyle(
                        fontFamily: "Segoe UI",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    heightBox4,
                    Container(height: 2.h, width: 40.w, color: Colors.blue),
                  ],
                ),
                widthBox40,
                Column(
                  children: [
                    Text(
                      'Jobs',
                      style: TextStyle(
                        fontFamily: "Segoe UI",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    heightBox4,
                    Container(height: 2.h, width: 40.w, color: Colors.blue),
                  ],
                ),
                widthBox40,
                Column(
                  children: [
                    Text(
                      'Roles',
                      style: TextStyle(
                        fontFamily: "Segoe UI",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    heightBox4,
                    Container(height: 2.h, width: 40.w, color: Colors.blue),
                  ],
                ),
              ],
            ),
            StraightLiner(height: 0.4, color: Color(0xff454545)),

            heightBox14,
            // PostSection(),
            Row(
              children: [
                CrashSafeImage(
                  Assets.images.icon01.keyName,
                  height: 42.h,width: 42.h,),
                widthBox8,
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
                        color: Color(0xff717182),
                      ),
                    ),
                    Text(
                      'Aminul Islam',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: LightThemeColors.blueColor
                      ),
                    ),
                    Text(
                      'Aminul Islam',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        
                      ),
                    ),

                    Row(
                      children: [
                        CrashSafeImage(
                          Assets.images.location.keyName,height: 12,),
                          widthBox10,
                        Text(
                          'Flutter Developer',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: Color(0xff717182),
                          ),
                        ),
                      ],
                    ),

                  ])
              ],
            )
          ],
        ),
      ),
    );
  }
}
