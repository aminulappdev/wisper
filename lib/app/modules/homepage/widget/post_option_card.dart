
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/details_card.dart';

class PostOptionCard extends StatelessWidget {
  final VoidCallback onTap;
  final String imagePath;
  final Color color;
  final String title;
  final String subtitle;
  const PostOptionCard({
    super.key,
    required this.onTap,
    required this.imagePath,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return DetailsCard(
      bgColor: Color(0xff121212),
      borderColor: Colors.transparent,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
          child: Row(
            children: [
              CircleIconWidget(
                color: color,
                imagePath: imagePath,
                iconRadius: 18,
                onTap: () {},
              ),
              widthBox8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff98A2B3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}