import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/modules/homepage/controller/feed_post_controller.dart';
import 'package:wisper/app/modules/homepage/widget/post_card.dart';

class PostSection extends StatefulWidget {
  const PostSection({super.key});

  @override
  State<PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  final AllFeedPostController controller = Get.find<AllFeedPostController>();

  @override
  void initState() {
    super.initState();
    controller.getAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.inProgress) {
        return const Center(child: CircularProgressIndicator());
      } else {
        print('Length: ${controller.allPostData.length}');
        return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: controller.allPostData.length,
            itemBuilder: (context, index) {
              final DateFormatter formattedTime = DateFormatter(
                controller.allPostData[index].createdAt!,
              );
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: PostCard(
                  trailing: Text(
                    'Sponsor',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: LightThemeColors.themeGreyColor,
                    ),
                  ),
                  ownerName:
                      controller.allPostData[index].author?.person?.name ?? '',
                  ownerImage:
                      controller.allPostData[index].author?.person?.image ?? '',
                  ownerProfession:
                      controller.allPostData[index].author?.person?.title ?? '',
                  postImage: controller.allPostData[index].images.first,
                  postDescription: controller.allPostData[index].caption ?? '',
                  postTime: formattedTime.getRelativeTimeFormat(),
                  views: controller.allPostData[index].views.toString(),
                ),
              );
            },
          ),
        );
      }
    });
  }
}
