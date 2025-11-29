// my_post_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_popup.dart';
import 'package:wisper/app/modules/homepage/controller/my_post_controller.dart';
import 'package:wisper/app/modules/homepage/views/edit_gallery_post.dart';
import 'package:wisper/app/modules/homepage/widget/post_card.dart';
import 'package:wisper/app/modules/profile/views/boost_screen.dart';

class MyPostSection extends StatefulWidget {
  const MyPostSection({super.key});

  @override
  State<MyPostSection> createState() => _MyPostSectionState();
}

class _MyPostSectionState extends State<MyPostSection> {
  final MyFeedPostController controller = Get.find<MyFeedPostController>();

  @override
  // Corrected: was missing in your previous code
  void initState() {
    super.initState();
    controller.getAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Loading state
      if (controller.inProgress) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }

      // Empty state
      if (controller.allPostData.isEmpty) {
        return const Center(
          child: Text(
            'No posts yet',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        );
      }

      // Main list
      return Expanded(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: controller.allPostData.length,
          itemBuilder: (context, index) {
            final post = controller.allPostData[index];
            final DateFormatter formattedTime = DateFormatter(post.createdAt!);

            final GlobalKey suffixButtonKey = GlobalKey();

            final CustomPopupMenu customPopupMenu = CustomPopupMenu(
              targetKey: suffixButtonKey,
              options: [
                Text(
                  'Edit Post',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Delete Post',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                  ),
                ),
                // আরো অপশন চাইলে এখানে যোগ করো
              ],
              optionActions: {
                '0': () => Get.to(
                  () => EditGalleryPostScreen(feedPostItemModel: post),
                ),
                '1': () {
                  // Delete post logic here
                  Get.snackbar('Delete', 'Delete post tapped');
                },
              },
              menuWidth: 180.w,
              menuHeight: 48.h,
            );

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
              child: PostCard(
                // More options button with unique key
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Boost Post Button
                    SizedBox(
                      height: 36.h,
                      width: 90.w,
                      child: CustomElevatedButton(
                        title: 'Boost Post',
                        textSize: 12,
                        borderRadius: 50,
                        onPress: () => Get.to(() => const BoostScreen()),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Three dot menu
                    GestureDetector(
                      key: suffixButtonKey, // প্রতিটি পোস্টে আলাদা কী
                      onTap: () {
                        customPopupMenu.showMenuAtPosition(context);
                      },
                      child: const Icon(
                        Icons.more_vert_rounded,
                        color: Color(0xff8C8C8C),
                        size: 24,
                      ),
                    ),
                  ],
                ),

                // Post data
                ownerName: post.author?.person?.name ?? 'Unknown User',
                ownerImage: post.author?.person?.image ?? '',
                ownerProfession: post.author?.person?.title ?? 'Professional',
                postImage: post.images.isNotEmpty ? post.images.first : '',
                postDescription: post.caption ?? '',
                postTime: formattedTime.getRelativeTimeFormat(),
                views: post.views?.toString() ?? '0',
              ),
            );
          },
        ),
      );
    });
  }
}
