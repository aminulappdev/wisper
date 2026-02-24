import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/modules/profile/model/recommendation_model.dart';

class Recommendation extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  final List<Giver> images;
  final bool? isEmpty;

  const Recommendation({
    super.key,
    required this.onTap,
    required this.count,
    required this.images,
    this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    // সর্বোচ্চ ৩টা ইমেজ দেখাবে
    final displayImages = images.take(3).toList();
    final hasImages = displayImages.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          height:
              30.h, // স্ট্যাকের জন্য ফিক্সড হাইট দিলাম যাতে লেআউট স্থির থাকে
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ইমেজগুলো দেখানো
              if (hasImages)
                ...displayImages.asMap().entries.map((entry) {
                  int index = entry.key;
                  Giver giver = entry.value;

                  return Positioned(
                    left: index * 15.0,
                    child: CircleAvatar(
                      radius: 10.r,
                      backgroundImage: NetworkImage(
                        giver.person != null
                            ? giver.person!.image ?? giver.business?.image ?? ''
                            : '',
                      ),

                      backgroundColor: Colors.grey.shade200,
                    ),
                  );
                }).toList(),

              Positioned(
                left: hasImages ? (displayImages.length * 15.0 + 10) : 0,
                top: 0.h,
                child: Text(
                  '$count recommendations',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xff7F8694),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
