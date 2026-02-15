import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';

class TransactionSection extends StatelessWidget {
  const TransactionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( 
              'Transaction history',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp),
            ),

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hiba Saleh',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),

                            Text(
                              'Oct 19, 05:45 AM',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: LightThemeColors.themeGreyColor,
                              ),
                            ),
                          ],
                        ),

                        Text(
                          '\$15.00',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: LightThemeColors.themeGreyColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
