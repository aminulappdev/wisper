import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/gen/assets.gen.dart';

class CreateReviewSheet extends StatefulWidget {
  const CreateReviewSheet({super.key});

  @override
  State<CreateReviewSheet> createState() => _CreateReviewSheetState();
}

class _CreateReviewSheetState extends State<CreateReviewSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
        left: 20.0,
        right: 20.0,
        top: 20.0,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Container(
          color: Color(0xff0D0D0D),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightBox10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 32.h,
                      width: 66.w,
                      child: CustomElevatedButton(
                        title: 'Post',
                        textSize: 12,
                        borderRadius: 50,
                        onPress: () {},
                      ),
                    ),
                  ],
                ),
                heightBox10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 21.r,
                          backgroundImage: AssetImage(
                            Assets.images.image.keyName,
                          ),
                        ),
                        widthBox10,
                        Text('John Doe', style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),
                    CrashSafeImage(Assets.images.star.keyName, height: 20.h),
                  ],
                ),
                heightBox10,
                SizedBox(
                  height: 100.h,
                  child: CustomTextField(
                    maxLines: 5,
                    hintText: 'Write your review here',
                    hintStyle: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xff8C8C8C),
                    ),
                  ),
                ),
                heightBox10,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
