// ignore_for_file: must_be_immutable

import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wisper/app/core/others/custom_size.dart';
import 'package:wisper/app/core/widgets/common/circle_icon.dart';

import 'package:wisper/gen/assets.gen.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  String? subtitle;
  AuthHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleIconWidget(
          iconRadius: 18,
          imagePath: Assets.images.arrowBack.keyName, 
          onTap: () {
            Get.back();
          },
        ),
        heightBox12,
        Text(
          title,
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800),
        ),
        subtitle == null ? const SizedBox() : heightBox8,
        subtitle == null
            ? const SizedBox()
            : Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFD1D1D1),
                ),
              ),
      ],
    );
  }
}
