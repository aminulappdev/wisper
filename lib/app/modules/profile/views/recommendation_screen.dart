import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/modules/profile/model/recommendation_model.dart';
import 'package:wisper/app/modules/profile/views/create_review.dart';
import 'package:wisper/app/modules/profile/widget/reviewCard.dart';

class RcommendationButtomSheet extends StatefulWidget {
  final String? recieverId;
  final List<RecommendationItemModel> recommendationItemModel;
  final bool isCreateReview;
  const RcommendationButtomSheet({
    super.key,
    required this.recommendationItemModel,
    this.isCreateReview = true,
    this.recieverId,
  });

  @override
  State<RcommendationButtomSheet> createState() =>
      _RcommendationButtomSheetState();
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
              Expanded(
                // Use Expanded to give ListView a bounded height
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: widget.recommendationItemModel.length,

                  itemBuilder: (context, index) {
                    return ReviewCard(
                      image:
                          widget
                              .recommendationItemModel[index]
                              .giver!
                              .person!
                              .image ??
                          '',
                      name:
                          widget
                              .recommendationItemModel[index]
                              .giver!
                              .person
                              ?.name ??
                          '',
                      review: widget.recommendationItemModel[index].text ?? '',
                      rating: widget.recommendationItemModel[index].rating
                          .toString(),
                    );
                  },
                ),
              ),
              heightBox10,
              widget.isCreateReview == false ||
                      StorageUtil.getData(StorageUtil.userRole) != 'PERSON'
                  ? Container()
                  : Center(
                      child: GestureDetector(
                        onTap: () {
                          _showCreatePost();
                        },
                        child: SizedBox(
                          width: 210,
                          height: 30,
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
    );
  }

  void _showCreatePost() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CreateReviewSheet(recieverId: widget.recieverId ?? '');
      },
    );
  }
}
