import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/modules/profile/controller/create_recommandation.dart';
import 'package:wisper/app/modules/profile/controller/person/profile_controller.dart';
import 'package:wisper/app/modules/profile/controller/recommendetion_controller.dart';
import 'package:wisper/gen/assets.gen.dart';

class CreateReviewSheet extends StatefulWidget {
  final String recieverId;
  const CreateReviewSheet({super.key, required this.recieverId});

  @override
  State<CreateReviewSheet> createState() => _CreateReviewSheetState();
}

class _CreateReviewSheetState extends State<CreateReviewSheet> {
  final TextEditingController _reviewController = TextEditingController();
  final ProfileController profileController = Get.find<ProfileController>();

  final CreateRecommendationController createRecommendationController =
      CreateRecommendationController();
  int _rating = 0; // Current rating (0-5)

  @override
  void initState() {
    profileController.getMyProfile();
    super.initState();
  }

  void addRecommendation() {
    showLoadingOverLay(
      asyncFunction: () async =>
          await performRecommendation(context, _reviewController.text),
      msg: 'Please wait...',
    );
  }

  Future<void> performRecommendation(BuildContext context, String text) async {
    final bool isSuccess = await createRecommendationController
        .addRecommendation(
          text: text,
          rating: _rating,
          recieverId: widget.recieverId,
        );

    if (isSuccess) {
      final AllRecommendationController allRecommendationController =
          Get.find<AllRecommendationController>();

      await allRecommendationController.getAllRecommendations(
        widget.recieverId,
      );
      Navigator.pop(context);
    } else {
      showSnackBarMessage(
        context,
        createRecommendationController.errorMessage,
        true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20.0,
        right: 20.0,
        top: 20.0,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Container(
          color: Color(0xff0D0D0D),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightBox10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 32.h,
                      width: 66.w,
                      child: CustomElevatedButton(
                        title: 'Post',
                        textSize: 12,
                        borderRadius: 50,
                        onPress: () {
                          // Handle post action
                          if (_rating == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please give a rating')),
                            );
                            return;
                          }
                          {
                            addRecommendation();
                          }
                          // Proceed with posting review
                        },
                      ),
                    ),
                  ],
                ),
                heightBox10,
                Obx(() {
                  if (profileController.inProgress) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 21.r,
                              backgroundImage: AssetImage(
                                Assets.images.image.keyName,
                              ),
                            ),
                            widthBox10,
                            Text(
                              profileController
                                      .profileData!
                                      .auth!
                                      .person
                                      ?.name ??
                                  '',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ],
                        ),
                        // Star rating widget
                        _buildStarRating(),
                      ],
                    );
                  }
                }),
                heightBox10,
                SizedBox(
                  height: 100.h,
                  child: CustomTextField(
                    controller: _reviewController,
                    maxLines: 5,
                    hintText: 'Write your review here',
                    hintStyle: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xff8C8C8C),
                    ),
                  ),
                ),
                heightBox10,

                // Optional: Show rating value
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = starIndex;
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Icon(
              starIndex <= _rating ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 22.h,
            ),
          ),
        );
      }),
    );
  }
}
