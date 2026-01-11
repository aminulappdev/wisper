// lib/app/core/widgets/image_container_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/widgets/common/photo_viewer.dart'; // তোমার FullScreenImageViewer

class ImageContainer extends StatelessWidget {
  final List<String>? images; // এখন লিস্ট
  final double height;        // পুরো কন্টেইনারের উচ্চতা (সাধারণত 168-200)
  final double width;
  final double borderRadius;

  const ImageContainer({
    super.key,
    this.images,
    required this.height,
    required this.width,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> validImages = images?.where((url) => url.isNotEmpty).toList() ?? [];

    if (validImages.isEmpty) return const SizedBox.shrink();

    final int imageCount = validImages.length.clamp(1, 4); // সর্বোচ্চ ৪টা

    return GestureDetector(
      onTap: () {
        // প্রথম ইমেজে ট্যাপ করলে ফুলস্ক্রিন ওপেন, তুমি চাইলে সবগুলোর গ্যালারি ও করতে পারো
        Get.to(() => FullScreenImageViewer(imageUrl: validImages[0]));
      },
      child: Container(
        height: height.h,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius.r),
          child: _buildImageLayout(imageCount, validImages),
        ),
      ),
    );
  }

  Widget _buildImageLayout(int count, List<String> images) {
    if (count == 1) {
      return _singleImage(images[0]);
    } else if (count == 2) {
      return Row(
        children: [
          Expanded(child: _singleImage(images[0])),
          SizedBox(width: 4.w),
          Expanded(child: _singleImage(images[1])),
        ],
      );
    } else if (count == 3) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: _singleImage(images[0]),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _singleImage(images[1])),
                SizedBox(height: 4.h),
                Expanded(child: _singleImage(images[2])),
              ],
            ),
          ),
        ],
      );
    } else {
      // 4 images
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4.w,
          crossAxisSpacing: 4.w,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return _singleImage(images[index]);
        },
      );
    }
  }

  Widget _singleImage(String url) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(borderRadius.r),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}