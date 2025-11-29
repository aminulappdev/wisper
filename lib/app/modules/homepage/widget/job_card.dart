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
  final String? postId;
  final String? ownerName;
  final String? ownerImage;
  final String? ownerDesignation;
  final String? jobTitle;
  final String? salary;
  final String? location;
  final String? jobType;
  final String? shiftType;
  final String? jobDescription;
  final String? date;
  const JobCard({
    super.key,
    this.postId,
    this.ownerName,
    this.ownerImage,
    this.ownerDesignation,
    this.jobTitle,
    this.salary,
    this.location,
    this.jobType,
    this.shiftType,
    this.jobDescription,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    var shift = shiftType == 'MONTHLY' ? 'mo' : 'onOff';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Get.to(
            () => JobDetailsScreen(jobId: postId!),
            transition: Transition.rightToLeft,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                radius: 21.r,
                backgroundImage: NetworkImage(ownerImage ?? ''),
              ),
              widthBox8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ownerName ?? '',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(
                    ownerDesignation ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: LightThemeColors.themeGreyColor,
                    ),
                  ),
                  Text(
                    jobTitle ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: LightThemeColors.blueColor,
                    ),
                  ),
                  Text(
                    '\$${salary ?? ''}/$shift',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),

                  Row(
                    children: [
                      CrashSafeImage(
                        Assets.images.location.keyName,
                        height: 12,
                      ),
                      widthBox10,
                      Text(
                        location ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: LightThemeColors.themeGreyColor,
                        ),
                      ),
                    ],
                  ),
                  heightBox10,
                  Row(
                    children: [
                      LabelData(
                        title: 'Part-time',
                        bgColor: jobType == 'PART_TIME'
                            ? LightThemeColors.blueColor
                            : null,
                      ),
                      widthBox10,
                      LabelData(
                        title: 'Full-time',
                        bgColor: jobType == 'FULL_TIME'
                            ? LightThemeColors.blueColor
                            : null,
                      ),
                      widthBox10,
                      LabelData(
                        title: 'Contract',
                        bgColor: jobType == 'CONTRACT'
                            ? LightThemeColors.blueColor
                            : null,
                      ),
                    ],
                  ),
                  heightBox10,
                  SizedBox(
                    width: 250.w,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      jobDescription ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xffD0D5DD),
                      ),
                    ),
                  ),
                  heightBox16,
                  Text(
                    date ?? '',
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
        heightBox24,
        StraightLiner(height: 0.4, color: Color(0xff454545)),
      ],
    );
  }
}
