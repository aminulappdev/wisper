import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/details_card.dart';
import 'package:wisper/app/core/widgets/label_data.dart';
import 'package:wisper/app/modules/homepage/widget/feature_list.dart';
import 'package:wisper/gen/assets.gen.dart';

class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({super.key});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool isDescriptionExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              heightBox40,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 60.w,
                    child: CustomElevatedButton(
                      title: 'Cancel',
                      onPress: () => Navigator.pop(context),
                      height: 28,
                      textSize: 10,
                      color: Color(0xff323232),
                      borderRadius: 50,
                      textColor: Colors.white,
                    ),
                  ),
                  CustomElevatedButton(
                    title: 'Apply for job',
                    width: 93,
                    height: 28,
                    textSize: 10,
                    color: LightThemeColors.blueColor,
                    borderRadius: 50,
                    textColor: Colors.white,
                  ),
                ],
              ),
              heightBox20,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Flutter Developer',
                    style: TextStyle(
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CircleIconWidget(
                    imagePath: Assets.images.heart.keyName,
                    onTap: () {},
                    color: Color(0xff292727),
                    iconRadius: 18,
                  ),
                ],
              ),
              heightBox10,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundImage: AssetImage(Assets.images.icon01.keyName),
                  ),
                  widthBox8,
                  Text(
                    'Aminul Islam',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffD1D1D1),
                    ),
                  ),
                ],
              ),
              heightBox20,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Job Type',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffD1D1D1),
                        ),
                      ),
                      heightBox8,
                      LabelData(
                        horizontalPadding: 20,
                        verticalPadding: 8,
                        title: 'Full Time',
                        bgColor: LightThemeColors.blueColor,
                      ),
                    ],
                  ),
                  widthBox40,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Experience Level',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffD1D1D1),
                        ),
                      ),
                      heightBox8,
                      DetailsCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 6,
                          ),
                          child: Row(
                            children: [
                              CrashSafeImage(
                                Assets.images.adds.keyName,
                                height: 16.h,
                                width: 16,
                                color: LightThemeColors.blueColor,
                              ),
                              widthBox4,
                              Text(
                                'Mid Level',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff8C8C8C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              heightBox10,
              Text(
                'Compensation',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffD1D1D1),
                ),
              ),
              heightBox10,
              DetailsCard(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salary',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff8C8C8C),
                        ),
                      ),
                      heightBox4,
                      Text(
                        'N240,000/mo',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              heightBox10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffD1D1D1),
                        ),
                      ),
                      heightBox8,
                      DetailsCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 6,
                          ),
                          child: Row(
                            children: [
                              CrashSafeImage(
                                Assets.images.location.keyName,
                                height: 16.h,
                                width: 16,
                                color: LightThemeColors.blueColor,
                              ),
                              widthBox4,
                              Text(
                                'Lagos, Nigeria',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff8C8C8C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Educational Qualifications',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffD1D1D1),
                        ),
                      ),
                      heightBox8,
                      DetailsCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 6,
                          ),
                          child: Row(
                            children: [
                              CrashSafeImage(
                                Assets.images.education.keyName,
                                height: 16.h,
                                width: 16,
                                color: LightThemeColors.blueColor,
                              ),
                              widthBox4,
                              Text(
                                'Bachelor\'s Degree',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff8C8C8C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              heightBox20,

              Text(
                'Description',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffD1D1D1),
                ),
              ),
              heightBox10,
              DetailsCard(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'We are seeking a Senior UI/UX Designer to lead the design of intuitive and user-centric mobile applications. The ideal candidate should have a strong background in mobile design principles and expernce working with cross-functional teams.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff8C8C8C),
                        ),
                        textAlign: TextAlign.justify,
                        maxLines: isDescriptionExpanded ? 4 : 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                      heightBox10,
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isDescriptionExpanded = !isDescriptionExpanded;
                          });
                        },
                        child: Text(
                          isDescriptionExpanded ? 'Read More' : 'Read Less',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: LightThemeColors.blueColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              heightBox20,
              Text(
                'Requirements',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffD1D1D1),
                ),
              ),
              heightBox10,
              DetailsCard(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      FeatureList(
                        iconPath: Assets.images.mark02.keyName,
                        title: 'We are seeking a Senior UI/UX Designer.',
                      ),
                      heightBox10,
                      FeatureList(
                        iconPath: Assets.images.mark02.keyName,
                        title: 'We are seeking a Senior UI/UX Designer.',
                      ),
                      heightBox10,
                      FeatureList(
                        iconPath: Assets.images.mark02.keyName,
                        title: 'We are seeking a Senior UI/UX Designer.',
                      ),
                    ],
                  ),
                ),
              ),
              heightBox20,
              Text(
                'Key Responsibilities',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffD1D1D1),
                ),
              ),
              heightBox10,
              DetailsCard(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      FeatureList(
                        iconPath: Assets.images.mark02.keyName,
                        title: 'We are seeking a Senior UI/UX Designer.',
                      ),
                      heightBox10,
                      FeatureList(
                        iconPath: Assets.images.mark02.keyName,
                        title: 'We are seeking a Senior UI/UX Designer.',
                      ),
                      heightBox10,
                      FeatureList(
                        iconPath: Assets.images.mark02.keyName,
                        title: 'We are seeking a Senior UI/UX Designer.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
