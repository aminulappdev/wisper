import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/gen/assets.gen.dart';

class Recommendation extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const Recommendation({super.key, required this.onTap, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 10.r,
                backgroundImage: AssetImage(Assets.images.image.keyName),
              ),
              Positioned(
                left: 10,
                child: CircleAvatar(
                  radius: 10.r,
                  backgroundImage: AssetImage(Assets.images.image.keyName),
                ),
              ),
              Positioned(
                left: 20,
                child: CircleAvatar(
                  radius: 10.r,
                  backgroundImage: AssetImage(Assets.images.image.keyName),
                ),
              ),
              Positioned(
                left: 45,
                child: Text(
                  '$count recommendations',
                  style: TextStyle(fontSize: 13.sp, color: Color(0xff7F8694)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
