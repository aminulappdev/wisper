import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/modules/homepage/controller/others_post_controller.dart';
import 'package:wisper/app/modules/homepage/widget/post_card.dart';

class OthersPostSection extends StatefulWidget {
  final String? userId;
  const OthersPostSection({super.key, this.userId});

  @override
  State<OthersPostSection> createState() => _OthersPostSectionState();
}

class _OthersPostSectionState extends State<OthersPostSection> {
  final OthersFeedPostController controller = Get.put(
    OthersFeedPostController(),
  );

  @override
  void initState() {
    super.initState();
    // প্রথমবার ডেটা লোড করা
    print('User ID: ${widget.userId}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetPagination();
      print('User ID avobe callback: ${widget.userId}');
      controller.getAllPost(userId: widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // Expanded Obx এর বাইরে → সমস্যা সমাধান!
      child: Obx(() {
        // লোডিং স্টেট
        if (controller.inProgress) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        // খালি লিস্ট
        if (controller.allPostData.isEmpty) {
          return const Center(
            child: Text(
              'No posts yet',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          );
        }

        // মূল পোস্ট লিস্ট
        return ListView.builder(
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
                ownerId: post.author?.id ?? '',
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
                postImage: post.images.isNotEmpty ? post.images.first : null,
                postDescription: post.caption ?? '',
                postTime: formattedTime,
                views: post.views.toString(),
              ),
            );
          },
        );
      }),
    );
  }
}
