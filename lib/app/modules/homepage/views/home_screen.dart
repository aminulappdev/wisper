import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/homepage/views/job_section.dart';
import 'package:wisper/app/modules/homepage/views/post_section.dart';
import 'package:wisper/app/modules/homepage/views/role_section.dart';
import 'package:wisper/gen/assets.gen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Posts',
                        style: TextStyle(
                          fontFamily: "Segoe UI",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: selectedIndex == 0
                              ? Colors.white
                              : Color(0xff93A4B0),
                        ),
                      ),
                      heightBox4,
                      Container(
                        height: 2.h,
                        width: 40.w,
                        color: selectedIndex == 0
                            ? Colors.blue
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ),
                widthBox40,
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Jobs',
                        style: TextStyle(
                          fontFamily: "Segoe UI",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: selectedIndex == 1
                              ? Colors.white
                              : Color(0xff93A4B0),
                        ),
                      ),
                      heightBox4,
                      Container(
                        height: 2.h,
                        width: 40.w,
                        color: selectedIndex == 1
                            ? Colors.blue
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ),
                widthBox40,
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Roles',
                        style: TextStyle(
                          fontFamily: "Segoe UI",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: selectedIndex == 2
                              ? Colors.white
                              : Color(0xff93A4B0),
                        ),
                      ),
                      heightBox4,
                      Container(
                        height: 2.h,
                        width: 40.w,
                        color: selectedIndex == 2
                            ? Colors.blue
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            StraightLiner(height: 0.4, color: Color(0xff454545)),

            heightBox14,
            selectedIndex == 0
                ? PostSection(
                    trailing: Text(
                      'Sponsor',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xff717182),
                      ),
                    ),
                  )
                : Container(),
            selectedIndex == 1 ? JobSection() : Container(),
            selectedIndex == 2 ? RoleSection() : Container(),
          ],
        ),
      ),
    );
  }
}
