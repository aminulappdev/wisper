import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/details_card.dart';
import 'package:wisper/gen/assets.gen.dart';

class DocInfo extends StatelessWidget {
  const DocInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: 10,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: DetailsCard(
            bgColor: Colors.transparent,
            borderWidth: 0.5,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CrashSafeImage(
                    Assets.images.pdf.keyName,
                    height: 24,
                    width: 24,
                    color: Colors.white,
                  ),
                  widthBox10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'job_description.pdf',
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
            ),
          ),
        ),
      ),
    );
  }
}
