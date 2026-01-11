
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/others/custom_size.dart';
import 'package:wisper/gen/assets.gen.dart';

class ConnectedMember extends StatelessWidget {
  const ConnectedMember({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 21.r,
          backgroundImage: AssetImage(Assets.images.image.path),
        ),
        heightBox4,
        Text(
          'Aminul',
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
