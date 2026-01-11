import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/common/circle_icon.dart';
import 'package:wisper/app/modules/chat/controller/all_chats_data_controller.dart';
import 'package:wisper/app/modules/chat/views/doc_info.dart';
import 'package:wisper/gen/assets.gen.dart';

class DocInfoSection extends StatefulWidget {
  final String chatId;
  const DocInfoSection({super.key, required this.chatId});

  @override
  State<DocInfoSection> createState() => _DocInfoSectionState();
}

class _DocInfoSectionState extends State<DocInfoSection> {
  final AllChatsDataController controller = Get.put(AllChatsDataController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async { 
      controller.getDoc(widget.chatId, 'DOC');
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // File open করার মেইন ফাংশন (open_filex দিয়ে)
  Future<void> _openResumeFile(dynamic resume) async {
    if (resume == null || resume == '') {
      showSnackBarMessage(context, "No file attached", true);
      return;
    }

    String url = resume;
    String fileName =
        resume ??
        'resume_${resume ?? DateTime.now().millisecondsSinceEpoch}';

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


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        if (controller.inProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.chatsData!.isEmpty) {
          return const Center(child: Text('No media found'));
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: controller.chatsData!.length,

            itemBuilder: (context, index) {
              return DocInfo(
                isMyResume: false,
                onDelete: () {},
                title: controller.chatsData![index].file ?? '',
                isDownloaded: true,
                onTap: () {
                  _openResumeFile(controller.chatsData![index].file);
                },
              );
            },
          );
        }
      }),
    );
  }
}
