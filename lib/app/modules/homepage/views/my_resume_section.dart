import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/modules/chat/views/doc_info.dart';
import '../controller/my_resume_controller.dart';

class MyResumeSection extends StatefulWidget {
  final String userId;
  const MyResumeSection({super.key, required this.userId});

  @override
  State<MyResumeSection> createState() => _MyResumeSectionState();
}

class _MyResumeSectionState extends State<MyResumeSection> {
  late final MyResumeController controller;

  @override
  void initState() {
    super.initState();

    /// ✅ controller only once
    controller = Get.find<MyResumeController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllResume(widget.userId);
    });
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
}
