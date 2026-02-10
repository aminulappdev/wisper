import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ImageContainer extends StatelessWidget {
  final List<String>? images;
  final double height;
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
    final List<String> validImages =
        images?.where((url) => url.isNotEmpty).toList() ?? [];

    if (validImages.isEmpty) return const SizedBox.shrink();

    final int displayCount = validImages.length.clamp(1, 4);

    return GestureDetector(
      onTap: () {
        // সব ছবি পাঠিয়ে দিচ্ছি → index 0 থেকে শুরু হবে
        Get.to(() => FullScreenImageViewer(
              imageUrls: validImages,
              initialIndex: 0,
            ));
      },
      child: Container(
        height: height.h,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius.r),
          child: _buildImageLayout(displayCount, validImages),
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
      // 4 images → grid
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


class FullScreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.4),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "${_currentIndex + 1} / ${widget.imageUrls.length}",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrls[index],
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                ),
              );
            },
          ),

          // Optional: left / right arrow (ছোট স্ক্রিনে সুবিধা হয়)
          if (widget.imageUrls.length > 1) ...[
            Positioned(
              left: 8.w,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
                  onPressed: _currentIndex > 0
                      ? () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                      : null,
                ),
              ),
            ),
            Positioned(
              right: 8.w,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                  onPressed: _currentIndex < widget.imageUrls.length - 1
                      ? () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                      : null,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}