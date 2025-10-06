import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/details_card.dart';
import 'package:wisper/app/core/widgets/image_container_widget.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/chat/views/doc_info.dart';
import 'package:wisper/app/modules/chat/views/link_info.dart';
import 'package:wisper/app/modules/chat/views/media_info.dart';
import 'package:wisper/app/modules/chat/widgets/location_info.dart';
import 'package:wisper/app/modules/chat/widgets/select_option_widget.dart';
import 'package:wisper/gen/assets.gen.dart';

class GroupInfoScreen extends StatefulWidget {
  const GroupInfoScreen({super.key});

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            heightBox30,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleIconWidget(
                  color: const Color(0xff353434),
                  iconColor: const Color.fromARGB(255, 255, 255, 255),
                  iconRadius: 15,
                  radius: 14,
                  imagePath: Assets.images.arrowBack.keyName,
                  onTap: () => Navigator.pop(context),
                ),
                Text(
                  'Group Info',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 35.h, width: 35.h),
              ],
            ),
            heightBox10,
            Container(
              width: double.infinity,
              height: 280.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: const Color(0xff121212),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
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
                          imagePath: Assets.images.userGroup.keyName,
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
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    heightBox20,
                    Text(
                      'You created this group',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    heightBox8,
                    Text(
                      'Group • 3 members',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff717182),
                      ),
                    ),
                    heightBox10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 31.h,
                          width: 116.w,
                          child: CustomElevatedButton(
                            textSize: 12,
                            title: 'Share Class',
                            onPress: () {},
                            borderRadius: 50,
                          ),
                        ),
                        widthBox10,
                        SizedBox(
                          height: 31.h,
                          width: 116.w,
                          child: CustomElevatedButton(
                            color: Colors.black,
                            textSize: 12,
                            title: 'Add Member',
                            onPress: () {},
                            borderRadius: 50,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            heightBox20,
            const LocationInfo(),
            heightBox20,
            StraightLiner(height: 0.4, color: const Color(0xff454545)),
            heightBox10,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: SelectOptionWidget(
                    currentIndex: 0,
                    selectedIndex: selectedIndex,
                    title: 'Media',
                    lineColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                widthBox50,
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: SelectOptionWidget(
                    currentIndex: 1,
                    selectedIndex: selectedIndex,
                    title: 'Links',
                    lineColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                widthBox50,
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                  child: SelectOptionWidget(
                    currentIndex: 2,
                    selectedIndex: selectedIndex,
                    title: 'Docs',
                    lineColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
            const StraightLiner(height: 0.4, color: Color(0xff454545)),
            heightBox10,

            if (selectedIndex == 0) const MediaInfo(),
            if (selectedIndex == 1) const LinkInfo(),
            if (selectedIndex == 2) const DocInfo(),
          ],
        ),
      ),
    );
  }
}
