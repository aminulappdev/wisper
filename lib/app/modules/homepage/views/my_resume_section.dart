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
import 'package:wisper/gen/assets.gen.dart';
import '../controller/my_resume_controller.dart';

// প্রয়োজনীয় ইম্পোর্টস – open_filex ব্যবহার করা হয়েছে
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:open_filex/open_filex.dart'; // ← এখানে open_filex
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
    controller = Get.find<MyResumeController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllResume(widget.userId);
    });
  }

  // File open করার মেইন ফাংশন (open_filex দিয়ে)
  Future<void> _openResumeFile(dynamic resume) async {
    if (resume.file == null || resume.file!.isEmpty) {
      showSnackBarMessage(context, "No file attached", true);
      return;
    }

    String url = resume.file!;
    String fileName =
        resume.name ??
        'resume_${resume.id ?? DateTime.now().millisecondsSinceEpoch}';

    // URL থেকে extension বের করা
    String extension = '';
    if (url.contains('.')) {
      extension = url.split('.').last.split('?').first.toLowerCase();
    }

    // PDF হলে → in-app viewer (Syncfusion)
    if (extension == 'pdf') {
      Get.to(
        () => Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleIconWidget(
                iconRadius: 18.r,
                imagePath: Assets.images.cross.keyName,
                onTap: () {
                  Get.back();
                },
              ),
            ),
            title: Text(fileName),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          backgroundColor: Colors.black,
          body: SfPdfViewer.network(
            url,
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              Get.back();
              showSnackBarMessage(
                context,
                "Failed to load PDF: ${details.description}",
                true,
              );
            },
          ),
        ),
      );
      return;
    }

    try {
      // fileName-এ extension যোগ করা
      if (extension.isNotEmpty && !fileName.endsWith('.$extension')) {
        fileName += '.$extension';
      }

      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/$fileName';

      // Download
      await Dio().download(url, filePath);

      Get.back(); // loading hide

      // open_filex দিয়ে open করা
      final OpenResult result = await OpenFilex.open(filePath);

      switch (result.type) {
        case ResultType.done:
          // Successfully opened
          break;
        case ResultType.fileNotFound:
          showSnackBarMessage(context, 'File not found', true);
          break;
        case ResultType.noAppToOpen:
          showSnackBarMessage(context, 'No app found to open this file', true);
          break;
        case ResultType.permissionDenied:
          showSnackBarMessage(context, 'Permission denied', true);
          break;
        case ResultType.error:
        default:
          showSnackBarMessage(context, 'Error: ${result.message}', true);
          break;
      }
    } catch (e) {
      Get.back();
      showSnackBarMessage(context, 'Error opening file: $e', true);
    }
  }

  // Delete resume functions
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
      await controller.getAllResume(StorageUtil.getData(StorageUtil.userId));
      Get.back();
      showSnackBarMessage(context, "Resume deleted successfully!", false);
    } else {
      showSnackBarMessage(context, deleteResumeController.errorMessage, true);
    }
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.inProgress) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }

      final resumes = controller.myResumeData;

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
                    widget.userId == StorageUtil.getData(StorageUtil.userId),
                onDelete: () {
                  if (resume.id != null) {
                    _showDeletePost(resume.id!);
                  }
                },
                title: resume.name ?? 'Untitled Resume',
                isDownloaded: true,
                onTap: () {
                  _openResumeFile(resume); 
                },
              ),
            );
          },
        ),
      );
    });
  }
}
