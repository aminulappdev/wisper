// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_button.dart'
    show CustomElevatedButton;
import 'package:wisper/app/core/widgets/custom_popup.dart';
import 'package:wisper/app/modules/homepage/controller/delete_job_controller.dart';
import 'package:wisper/app/modules/homepage/controller/feed_job_controller.dart';
import 'package:wisper/app/modules/homepage/controller/my_job_controller.dart';
import 'package:wisper/app/modules/homepage/views/edit_job_post_screen.dart';
import 'package:wisper/app/modules/homepage/widget/job_card.dart';
import 'package:wisper/gen/assets.gen.dart';

class MyJobSection extends StatefulWidget {
  const MyJobSection({super.key});

  @override
  State<MyJobSection> createState() => _MyJobSectionState();
}

class _MyJobSectionState extends State<MyJobSection> {
  final MyFeedJobController controller = Get.find<MyFeedJobController>();
  final DeleteJobController deletePostController = DeleteJobController();

  @override
  void initState() {
    super.initState();
    final userId = StorageUtil.getData(StorageUtil.userAuthId);
    if (userId != null) {
      controller.getJobs(authorId: userId);
    }
  }

  void deletePost(String jobId) {
    showLoadingOverLay(
      asyncFunction: () async => await performDeletePost(context, jobId),
      msg: 'Please wait...',
    );
  }

  Future<void> performDeletePost(BuildContext context, String postId) async {
    final bool isSuccess = await deletePostController.deletePost(jobId: postId);

    if (isSuccess) {
      final MyFeedJobController myFeedJobController =
          Get.find<MyFeedJobController>();
      final AllFeedJobController allFeedJobController =
          Get.find<AllFeedJobController>();

      allFeedJobController.resetPagination();
      myFeedJobController.resetPagination();
      await myFeedJobController.getJobs();
      await allFeedJobController.getJobs();

      Get.back();
      showSnackBarMessage(context, "Job deleted successfully!", false);
    } else {
      showSnackBarMessage(context, deletePostController.errorMessage, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            // Loading State
            if (controller.inProgress) {
              return const Center(child: CircularProgressIndicator());
            }

            // Empty State
            if (controller.allJobData.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.work_off, size: 64.sp, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text(
                      'No jobs posted yet',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Your posted jobs will appear here',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            // Data State - List of Jobs
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: controller.allJobData.length,
              itemBuilder: (context, index) {
                final job = controller.allJobData[index];
                final date = job.createdAt;
                final formattedTime = date != null
                    ? DateFormatter(date).getRelativeTimeFormat()
                    : 'Just now';

                // Create a unique GlobalKey for each job card's more button
                final GlobalKey suffixButtonKey = GlobalKey();

                // Create popup menu instance (once per item)
                final customPopupMenu = CustomPopupMenu(
                  targetKey: suffixButtonKey,
                  options: [
                    Text(
                      'Edit Job',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Delete Job',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                  optionActions: {
                    '0': () => Get.to(() => EditJobPostScreen(job: job)),
                    '1': () {
                      _showDeletePost(job.id ?? '');
                    },
                  },
                  menuWidth: 180.w,
                  menuHeight: 48.h,
                );

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: JobCard(
                    showAction: true,
                    // Pass the key and tap handler
                    suffixIconKey: suffixButtonKey,
                    ontap: () {
                      // This will work because the key is attached to the button
                      customPopupMenu.showMenuAtPosition(context);
                    },
                    postId: job.id ?? '',
                    ownerImage: job.author?.business?.image ?? '',
                    ownerName: job.author?.business?.name ?? 'Unknown Company',
                    ownerDesignation: job.author?.business?.industry ?? '',
                    jobTitle: job.title ?? 'No Title',
                    salary: job.salary?.toString() ?? 'Negotiable',
                    location: job.location ?? 'Remote',
                    jobType: job.type ?? 'Full Time',
                    jobDescription: job.description ?? '',
                    shiftType: job.compensationType ?? 'Hourly',
                    date: formattedTime,
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  void _showDeletePost(String postId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleIconWidget(
                  imagePath: Assets.images.delete.keyName,
                  onTap: () {},
                  iconRadius: 22,
                  radius: 24,
                  color: Color(0xff312609),
                  iconColor: Color(0xffDC8B44),
                ),
                heightBox20,
                Text(
                  'Delete?',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                heightBox8,
                Text(
                  'Are you sure you want to delete?',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff9FA3AA),
                  ),
                ),
                heightBox12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        color: Color.fromARGB(255, 15, 15, 15),
                        borderColor: Color(0xff262629),
                        title: 'Discard',
                        onPress: () {
                          Get.back();
                        },
                      ),
                    ),
                    widthBox12,
                    Expanded(
                      child: CustomElevatedButton(
                        color: Color(0xffE62047),
                        title: 'Delete',
                        onPress: () {
                          deletePost(postId);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
