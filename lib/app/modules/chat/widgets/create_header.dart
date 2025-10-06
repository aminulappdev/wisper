import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';

class CreateHeader extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color iconColor;
  final String imagePath;
  final VoidCallback onTap;
  final String trailinlgText;
  const CreateHeader({
    super.key,
    required this.title,
    required this.bgColor,
    required this.iconColor,
    required this.imagePath,
    required this.onTap,
    required this.trailinlgText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff667185),
            ),
          ),
        ),
        Row(
          children: [
            CircleIconWidget(
              color: bgColor,
              iconColor: iconColor,
              radius: 21,
              iconRadius: 22,
              imagePath: imagePath,
              onTap: () {},
            ),
            widthBox4,
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            trailinlgText,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff2799EA),
            ),
          ),
        ),
      ],
    );
  }
}
