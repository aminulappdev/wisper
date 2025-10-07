
import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/gen/assets.gen.dart';

class ReviewCard extends StatelessWidget {
  final String image;
  final String name;
  final String designation;
  final String review;
  final String rating;
  final String date;
  const ReviewCard({
    super.key,
    required this.image,
    required this.name,
    required this.designation,
    required this.review,
    required this.rating,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450.h,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff121212),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 21.r,
                      backgroundImage: AssetImage(image),
                    ),
                    widthBox10,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            widthBox5,
                            CrashSafeImage(
                              Assets.images.star.keyName,
                              height: 16,
                            ),
                          ],
                        ),

                        Text(
                          designation,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff717182),
                          ),
                        ),
                        heightBox4,
                        SizedBox(
                          width: 250.w,
                          child: Text(
                            review,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        heightBox8,
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff717182),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
