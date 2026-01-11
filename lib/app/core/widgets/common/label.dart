import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Label extends StatelessWidget {
  final String label;

  const Label({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
    );
  }
}