import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/utils/video_player.dart';
import 'package:wisper/app/core/widgets/image_container_widget.dart';
import 'package:wisper/app/modules/chat/controller/all_chats_data_controller.dart';

class MediaInfo extends StatefulWidget {
  final String chatId;
  const MediaInfo({super.key, required this.chatId});

  @override
  State<MediaInfo> createState() => _MediaInfoState();
}

class _MediaInfoState extends State<MediaInfo> {
  final AllChatsDataController controller = Get.put(AllChatsDataController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.getMedia(widget.chatId);
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
          return GridView.builder(
            padding: EdgeInsets.all(0),
            itemCount: controller.chatsData!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              var fileType = controller.chatsData![index].fileType;
              return fileType == "VIDEO"
                  ? GestureDetector(
                      onTap: () {
                        Get.to(
                          () => VideoPlayerScreen(
                            videoUrl: controller.chatsData![index].file ?? '',
                          ),
                        );
                      },
                      child: Container(
                        height: 164,
                        width: 177,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.play_circle_filled,
                              size: 40,
                              color: Colors.white,
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  'Video',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ImageContainer(
                      images: controller.chatsData![index].file != null
                          ? [controller.chatsData![index].file!]
                          : [],
                      height: 164,
                      width: 177,
                      borderRadius: 10,
                    );
            },
          );
        }
      }),
    );
  }
}
