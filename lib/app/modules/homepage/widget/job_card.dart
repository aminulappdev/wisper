import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/label_data.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/homepage/views/job_details_screen.dart';

import 'package:wisper/gen/assets.gen.dart';

class JobCard extends StatelessWidget {
  const JobCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
           onTap: () => Get.to(() => const JobDetailsScreen()),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 21.r,
                backgroundImage: AssetImage(Assets.images.icon01.keyName),
              ),
              widthBox8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aminul Islam',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
                    'Senior UI/UX Designer',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: LightThemeColors.blueColor,
                    ),
                  ),
                  Text(
                    'N240,000/mo',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
          
                  Row(
                    children: [
                      CrashSafeImage(Assets.images.location.keyName, height: 12),
                      widthBox10,
                      Text(
                        'Lagos, Nigeria',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: Color(0xff717182),
                        ),
                      ),
                    ],
                  ),
                  heightBox10,
                  Row(
                    children: [
                      LabelData(title: 'Part-time'),
                      widthBox10,
                      LabelData(title: 'Remote'),
                      widthBox10,
                      LabelData(title: 'Contract'),
                    ],
                  ),
                  heightBox10,
                  SizedBox(
                    width: 250.w,
                    child: Text(
                      'We are seeking a Senior UI/UX Designer to lead',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xffD0D5DD),
                      ),
                    ),
                  ),
                  heightBox16,
                  Text(
                    '1 min ago',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xff717182),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        heightBox24,
        StraightLiner(height: 0.4, color: Color(0xff454545)),
      ],
    );
  }
}
