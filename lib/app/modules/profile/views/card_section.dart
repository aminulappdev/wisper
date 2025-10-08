
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';

class CardSection extends StatelessWidget {
  const CardSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add New Card',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
            ),
          ),
    
          Text(
            'Please enter your new card details to add your card in wallet',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              color: Color(0xffD1D1D1),
            ),
          ),
          heightBox16,
          CustomTextField(hintText: 'Card Number'),
          heightBox16,
          CustomTextField(hintText: 'Expiration Date'),
          heightBox16,
          CustomTextField(hintText: 'Security Code'),
          heightBox16,
          CustomTextField(hintText: 'Card Holder Name'),
    
          heightBox100,
          heightBox50,
          CustomElevatedButton(title: 'Add Card', onPress: () {}),
        ],
      ),
    );
  }
}
