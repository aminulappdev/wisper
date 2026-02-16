import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/modules/settings/model/wallet_model.dart';

class TransactionSection extends StatelessWidget {
  final List<TransectionItemModel>? allTransectionModel;
  const TransactionSection({super.key, this.allTransectionModel});

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
                itemCount: allTransectionModel?.length ?? 0,
                itemBuilder: (context, index) {
                  var item = allTransectionModel?[index];
                  DateFormatter dateFormatter = DateFormatter( item?.date ?? DateTime.now());
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item!.auth?.person != null
                                  ? item.auth!.person!.name ?? 'N/A'
                                  : item.auth?.business != null
                                  ? item.auth!.business!.name ?? 'N/A'
                                  : 'N/A',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),

                            Text(
                              dateFormatter.getShortDateFormat(),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: LightThemeColors.themeGreyColor,
                              ),
                            ),
                          ],
                        ),

                        Text(
                          '\$${item.amount}',
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
