import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/get_storage.dart';
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
    controller.getAllPost(); // প্রথমবার লোড
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.inProgress) {
        return const SizedBox(
          height: 500,
          child: Center(child: CircularProgressIndicator(color: Colors.white)),
        );
      }

      // লিস্ট খালি কিনা চেক
      if (controller.allPostData.isEmpty) {
        return const SizedBox(
          height: 500,
          child: Center(
            child: Text(
              'No posts yet',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        );
      }

      return Expanded(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: controller.allPostData.length,
          itemBuilder: (context, index) {
            final post = controller.allPostData[index];
            final formattedTime = DateFormatter(
              post.createdAt!,
            ).getRelativeTimeFormat();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: PostCard(
                trailing: const Text(
                  'Sponsor',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: LightThemeColors.themeGreyColor,
                  ),
                ),
                ownerName: StorageUtil.getData(StorageUtil.userRole) == 'PERSON'
                    ? post.author?.person?.name ?? 'Unknown User'
                    : post.author?.business?.name ?? 'Unknown Business',
                ownerImage:
                    StorageUtil.getData(StorageUtil.userRole) == 'PERSON'
                    ? post.author?.person?.image ?? ''
                    : post.author?.business?.image ?? '',
                ownerProfession:
                    StorageUtil.getData(StorageUtil.userRole) == 'PERSON'
                    ? post.author?.person?.title ?? 'Professional'
                    : post.author?.business?.name ?? 'Business',
                // null safety + safe access
                postImage: post.images.isNotEmpty ? post.images.first : null,
                postDescription: post.caption ?? '',
                postTime: formattedTime,
                views: post.views.toString(),
              ),
            );
          },
        ),
      );
    });
  }
}
