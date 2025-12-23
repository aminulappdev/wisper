import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/details_card.dart';
import 'package:wisper/app/core/widgets/label_data.dart';
import 'package:wisper/app/modules/homepage/controller/favorite_job_controller.dart';
import 'package:wisper/app/modules/homepage/controller/single_job_controller.dart';
import 'package:wisper/app/modules/homepage/widget/feature_list.dart';
import 'package:wisper/app/modules/profile/views/others_business_screen.dart';
import 'package:wisper/gen/assets.gen.dart';

class JobDetailsScreen extends StatefulWidget {
  final String jobId;
  const JobDetailsScreen({super.key, required this.jobId});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final SingleJobController singleJobController = Get.put(
    SingleJobController(),
  );

  final FavoriteController favoriteController = FavoriteController();

  @override
  void initState() {
    super.initState();
    singleJobController.getSingleJob(widget.jobId);
  }

  void favorite() {
    showLoadingOverLay(
      asyncFunction: () async => await perforfavorite(context),
      msg: 'Please wait...',
    );
  }

  Future<void> perforfavorite(BuildContext context) async {
    final bool isSuccess = await favoriteController.favorite(
      jobId: widget.jobId,
    );

    if (isSuccess) {
      final SingleJobController singleJobController =
          Get.find<SingleJobController>();
      await singleJobController.getSingleJob(widget.jobId);
    } else {
      showSnackBarMessage(context, favoriteController.errorMessage, true);
    }
  }

  bool isDescriptionExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
        child: Obx(() {
          if (singleJobController.inProgress) {
            return const Center(child: CircularProgressIndicator());
          } else {
            var job = singleJobController.singleJobData;
            bool isFavorite = job?.isFavorite ?? false;
            var shift = job?.compensationType == 'MONTHLY' ? 'mo' : 'onOff';
            var experience = (job?.experienceLevel == 'SENIOR'
                ? 'Senior'
                : job?.experienceLevel == 'MID_LEVEL'
                ? 'Mid Level'
                : job?.experienceLevel == 'JUNIOR'
                ? 'Junior'
                : 'Entry Level');
            return SingleChildScrollView(
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
                      GestureDetector(
                        onTap: () {
                          favorite();
                        },
                        child: CircleAvatar(
                          backgroundColor: LightThemeColors.circleIconColor,
                          radius: 16.r,
                          child: isFavorite
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 20.r,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                  size: 20.r,
                                ),
                        ),
                      ),
                    ],
                  ),
                  heightBox10,
                  GestureDetector(
                    onTap: () {
                      Get.to(OthersBusinessScreen(userId: job.author!.id!));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundImage: job!.author?.business?.image != null
                              ? NetworkImage(job.author!.business!.image!)
                              : AssetImage(Assets.images.icon01.keyName),
                        ),
                        widthBox8,
                        Text(
                          job.author?.business?.name ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffD1D1D1),
                          ),
                        ),
                      ],
                    ),
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
                            title: job.type == 'FULL_TIME'
                                ? 'Full Time'
                                : 'Part Time',
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
                                    experience,
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
                            '\$ ${job.salary.toString()}/$shift',
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
                                    job.location ?? '',
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
                                    job.qualification ?? '',
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
                            job.description ?? '',
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
                          for (var requirement in job.requirements)
                            FeatureList(
                              iconPath: Assets.images.mark02.keyName,
                              title: requirement,
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
                          for (var re in job.responsibilities)
                            FeatureList(
                              iconPath: Assets.images.mark02.keyName,
                              title: re,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
