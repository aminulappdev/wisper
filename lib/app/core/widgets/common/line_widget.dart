import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StraightLiner extends StatelessWidget {
  final double? height;
  final Color? color;
  const StraightLiner({super.key, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color ?? Color(0xff454545),
      ),
      height: height ?? 1.h,
      width: double.infinity,
    );
  }
}
