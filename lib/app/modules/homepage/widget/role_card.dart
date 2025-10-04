import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/gen/assets.gen.dart';

class RoleCard extends StatelessWidget {
  const RoleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundImage: AssetImage(Assets.images.image.keyName),
                ),
                widthBox8,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aminul Islam',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Flutter Developer',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xff717182),
                      ),
                    ),
                    heightBox4,
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              '5',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 8,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),

                            Text(
                              ' Post',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 8,
                                color: Color(0xff717182),
                              ),
                            ),
                          ],
                        ),
                        widthBox14,
                        Row(
                          children: [
                            Text(
                              '5',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 8,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),

                            Text(
                              ' Recommendation',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 8,
                                color: Color(0xff717182),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                CircleIconWidget(
                  imagePath: Assets.images.unselectedChat.keyName,
                  onTap: () {},
                  iconRadius: 18.r,
                ),
                widthBox8,
                SizedBox(
                  height: 30.h,
                  width: 60.w,
                  child: CustomElevatedButton(
                    borderRadius: 50,
                    textSize: 12.sp,
                    title: '+ Add',
                    onPress: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
        heightBox20,
        StraightLiner(height: 0.4, color: Color(0xff454545)),
      ],
    );
  }
}
