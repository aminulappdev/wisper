import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/modules/chat/views/doc_info.dart';
import 'package:wisper/app/modules/homepage/controller/delete_reusme_controller.dart';
import 'package:wisper/app/modules/profile/controller/person/profile_controller.dart';
import 'package:wisper/gen/assets.gen.dart';
import '../controller/my_resume_controller.dart';

class MyResumeSection extends StatefulWidget {
  final String userId;
  const MyResumeSection({super.key, required this.userId});

  @override
  State<MyResumeSection> createState() => _MyResumeSectionState(); 
}

class _MyResumeSectionState extends State<MyResumeSection> {
  late final MyResumeController controller;
  final DeleteResumeController deleteResumeController =
      DeleteResumeController();


  @override
  void initState() {
    super.initState();

    /// ✅ controller only once
    controller = Get.find<MyResumeController>();
 
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllResume(widget.userId);
    });
  }

  void deleteResume(String resumeId) {
    showLoadingOverLay(
      asyncFunction: () async => await performDeleteResume(context, resumeId),
      msg: 'Please wait...',
    );
  }

  Future<void> performDeleteResume(
    BuildContext context,
    String resumeId,
  ) async {
    final bool isSuccess = await deleteResumeController.deleteResume(
      resumeId: resumeId,
    );

    if (isSuccess) {
      final MyResumeController myResumeController =
          Get.find<MyResumeController>();

      await myResumeController.getAllResume(
        StorageUtil.getData(StorageUtil.userId),
      );
      Get.back();
      showSnackBarMessage(context, "Post deleted successfully!", false);
    } else {
      showSnackBarMessage(context, deleteResumeController.errorMessage, true);
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ================= LOADING =================
      if (controller.inProgress) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }

      final resumes = controller.myResumeData;

      // ================= EMPTY =================
      if (resumes == null || resumes.isEmpty) {
        return const SizedBox(
          height: 200,
          child: Center(
            child: Text(
              'No resumes yet',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        );
      }

      // ================= LIST =================
      /// 🔥 Expanded ensures bounded height
      return Expanded(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: resumes.length,
          itemBuilder: (context, index) {
            final resume = resumes[index];

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
              child: DocInfo(
                isMyResume:
                    widget.userId ==
                    StorageUtil.getData(StorageUtil.userId),
                onDelete: () {
                  _showDeletePost(resume.id!);
                },
                title: resume.name ?? '',
                isDownloaded: true,
                onTap: () {
                  controller.downloadResume(resume);
                },
              ),
            );
          },
        ),
      );
    });
  }

  void _showDeletePost(String resumeId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (context) {
        return Container(
          height: 250.h,
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleIconWidget(
                imagePath: Assets.images.delete.keyName,
                onTap: () {},
                iconRadius: 22.r,
                radius: 24.r,
                color: const Color(0xff312609),
                iconColor: const Color(0xffDC8B44),
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
                  color: const Color(0xff9FA3AA),
                ),
              ),
              heightBox12,
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      color: const Color.fromARGB(255, 15, 15, 15),
                      borderColor: const Color(0xff262629),
                      title: 'Discard',
                      onPress: () => Get.back(),
                    ),
                  ),
                  widthBox12,
                  Expanded(
                    child: CustomElevatedButton(
                      color: const Color(0xffE62047),
                      title: 'Delete',
                      onPress: () => deleteResume(resumeId),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
