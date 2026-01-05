// ignore_for_file: must_be_immutable

import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/gen/assets.gen.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  bool? isBack;
  String? subtitle;
  AuthHeader({ 
    super.key,
    required this.title,
    this.subtitle,
    this.isBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isBack! == false
            ? heightBox4
            : CircleIconWidget(
                iconRadius: 14.r,
                imagePath: Assets.images.arrowBack.keyName,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
        isBack! == false ? heightBox4 : heightBox12,
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
