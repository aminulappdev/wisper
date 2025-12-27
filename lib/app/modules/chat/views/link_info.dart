import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisper/app/modules/chat/controller/all_chats_data_controller.dart';
import 'package:wisper/app/modules/chat/views/doc_info.dart';

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
                onTap: () {},
              );
            },
          );
        }
      }),
    );
  }
}
