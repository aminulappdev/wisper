
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';

class MyInfoCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String job;
  const MyInfoCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 18.r, backgroundImage: AssetImage(imagePath)),
            widthBox8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),

                Text(
                  job,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff717182),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
          width: 60,

          child: CustomElevatedButton(
            textSize: 10,
            borderRadius: 50,
            title: 'Personal',
            onPress: () {},
          ),
        ),
      ],
    );
  }
}