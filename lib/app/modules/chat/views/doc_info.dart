import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/details_card.dart';
import 'package:wisper/gen/assets.gen.dart';

class DocInfo extends StatelessWidget {
  final String title;
  final bool isDownloaded;
  final VoidCallback onTap;
  const DocInfo({
    super.key,
    required this.title,
    required this.isDownloaded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DetailsCard(
      bgColor: Colors.transparent,
      borderWidth: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CrashSafeImage(
                  Assets.images.pdf.keyName,
                  height: 24,
                  width: 24,
                ),
                widthBox10,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                    Text(
                      'PDF Document',
                      style: TextStyle(color: Colors.white, fontSize: 10.sp),
                    ),
                  ],
                ),
              ],
            ),
            isDownloaded
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: onTap,
                      child: CrashSafeImage(
                        Assets.images.download.keyName,
                        height: 18,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
