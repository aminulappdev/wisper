// my_post_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_popup.dart';
import 'package:wisper/app/core/widgets/shimmer/gallery_post_shimmer.dart';
import 'package:wisper/app/modules/homepage/controller/delete_gallery_post_controlller.dart';
import 'package:wisper/app/modules/homepage/controller/feed_post_controller.dart';
import 'package:wisper/app/modules/homepage/controller/my_post_controller.dart';
import 'package:wisper/app/modules/homepage/views/edit_gallery_post.dart';
import 'package:wisper/app/modules/homepage/widget/post_card.dart';
import 'package:wisper/app/modules/profile/views/boost_screen.dart';
import 'package:wisper/gen/assets.gen.dart';

class MyPostSection extends StatefulWidget {
  const MyPostSection({super.key});

  @override
  State<MyPostSection> createState() => _MyPostSectionState();
}

class _MyPostSectionState extends State<MyPostSection> {
  final MyFeedPostController controller = Get.find<MyFeedPostController>();
  final DeletePostController deletePostController = DeletePostController();

  @override
  void initState() {
    super.initState();
    // যদি onInit()-এ না করা থাকে, তাহলে এখানে রাখতে পারো
    // কিন্তু ভালো প্র্যাকটিস: controller-এ onInit()-এ করা
    controller.getAllPost();
  }

  void deletePost(String postId) {
    showLoadingOverLay(
      asyncFunction: () async => await performDeletePost(context, postId),
      msg: 'Please wait...',
    );
  }

  Future<void> performDeletePost(BuildContext context, String postId) async {
    final bool isSuccess = await deletePostController.deletePost(
      postId: postId,
    );

    if (isSuccess) {
      final MyFeedPostController myFeedPostController =
          Get.find<MyFeedPostController>();
      final AllFeedPostController allFeedPostController =
          Get.find<AllFeedPostController>();

      allFeedPostController.resetPagination();
      myFeedPostController.resetPagination();
      await myFeedPostController.getAllPost();
      Get.back();
      showSnackBarMessage(context, "Post deleted successfully!", false);
    } else {
      showSnackBarMessage(context, deletePostController.errorMessage, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.inProgress) {
        return PostShimmerEffectWidget();
      }

      if (controller.allPostData.isEmpty) {
        return const Center(
          child: Text(
            'No posts yet',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        );
      }

      // ← এখানে Expanded সরিয়ে Flexible বা direct ListView দিলাম
      return ListView.builder(
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
            ],
            optionActions: {
              '0': () =>
                  Get.to(() => EditGalleryPostScreen(feedPostItemModel: post)),
              '1': () => _showDeletePost(post.id!),
            },
            menuWidth: 180.w,
            menuHeight: 48.h,
          );

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
            child: PostCard(
              onTapComment: () {},
              isComment: true,
              ownerId: post.author?.id ?? '',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 36.h,
                    width: 90.w,
                    child: CustomElevatedButton(
                      title: 'Boost Post',
                      textSize: 12,
                      borderRadius: 50,
                      onPress: () =>
                          Get.to(() => BoostScreen(feedPostItemModel: post)),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    key: suffixButtonKey,
                    onTap: () => customPopupMenu.showMenuAtPosition(context),
                    child: const Icon(
                      Icons.more_vert_rounded,
                      color: Color(0xff8C8C8C),
                      size: 24,
                    ),
                  ),
                ],
              ),
              ownerName: StorageUtil.getData(StorageUtil.userRole) == 'PERSON'
                  ? post.author?.person?.name ?? 'Unknown User'
                  : post.author?.business?.name ?? 'Unknown Business',
              ownerImage: StorageUtil.getData(StorageUtil.userRole) == 'PERSON'
                  ? post.author?.person?.image ?? ''
                  : post.author?.business?.image ?? '',
              ownerProfession:
                  StorageUtil.getData(StorageUtil.userRole) == 'PERSON'
                  ? post.author?.person?.title ?? 'Professional'
                  : post.author?.business?.name ?? 'Business',
              postImage: post.images.isNotEmpty ? post.images.first : null,
              postDescription: post.caption ?? '',
              postTime: formattedTime.getRelativeTimeFormat(),
              views: post.views?.toString() ?? '0',
            ),
          );
        },
      );
    });
  }

  void _showDeletePost(String postId) {
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
                      onPress: () => deletePost(postId),
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
}
