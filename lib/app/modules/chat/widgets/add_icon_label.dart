
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddIconLabel extends StatelessWidget {
  const AddIconLabel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      width: 48,
      decoration: BoxDecoration(
        color: Color(0xff3DBCF7).withValues(alpha: 0.20),
    
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          'Added',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xff2799EA),
          ),
        ),
      ),
    );
  }
}

