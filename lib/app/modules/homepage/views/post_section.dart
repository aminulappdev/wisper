import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/core/widgets/shimmer/gallery_post_shimmer.dart';
import 'package:wisper/app/modules/homepage/controller/feed_post_controller.dart';
import 'package:wisper/app/modules/homepage/views/comment_screen.dart';
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
    // প্রথমবার ডেটা লোড করা

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // Expanded Obx এর বাইরে → সমস্যা সমাধান!
      child: Obx(() {
        // লোডিং স্টেট
        if (controller.inProgress) {
          return const Center(child: PostShimmerEffectWidget());
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
                isPerson: post.author?.person != null,
                onTapComment: () {
                  Get.to(CommentScreen(postId: post.id ?? ''));
                },
                isComment: false,
                ownerId: post.author?.id ?? '',
                trailing: const Text(
                  'Sponsor',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: LightThemeColors.themeGreyColor,
                  ),
                ),
                ownerName: post.author?.person != null
                    ? post.author?.person?.name ?? 'Unknown User'
                    : post.author?.business?.name ?? 'Unknown Business',
                ownerImage: post.author?.person != null
                    ? post.author?.person?.image ?? ''
                    : post.author?.business?.image ?? '',
                ownerProfession: post.author?.person != null
                    ? post.author?.person?.title ?? 'Professional'
                    : post.author?.business?.name ?? 'Business',
                postImage: post.images.isNotEmpty ? post.images : [],
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
