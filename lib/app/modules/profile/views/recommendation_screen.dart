import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/modules/profile/views/create_review.dart';
import 'package:wisper/app/modules/profile/widget/reviewCard.dart';
import 'package:wisper/gen/assets.gen.dart';

class RcommendationButtomSheet extends StatefulWidget {
  const RcommendationButtomSheet({super.key});

  @override
  State<RcommendationButtomSheet> createState() => _RcommendationButtomSheetState();
}

class _RcommendationButtomSheetState extends State<RcommendationButtomSheet> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Container(
        color: Color(0xff0D0D0D),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Recommendation',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                heightBox10,
                ReviewCard(
                  image: Assets.images.image.keyName,
                  name: 'Aminul Islam',
                  designation: 'Senior Product Manager at Meta',
                  review: '"Wade is an exceptional software engineer withgreat attention to detail and strong problem-solving skills."',
                  rating: '5',
                  date: '1 min ago',
                ),
                heightBox10,
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showCreatePost();
                    },
                    child: SizedBox(
                      width: 210,
                      height: 24,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          color: Color(0xff3DBCF7).withValues(alpha: 0.20),
                        ),
                        child: Center(
                          child: Text(
                            '+ Add Recommendation',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff2799EA),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCreatePost() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow dynamic height with keyboard
      backgroundColor: Colors.transparent, // Ensure no default background interference
      builder: (BuildContext context) {
        return CreateReviewSheet();
      },
    );
  }
}