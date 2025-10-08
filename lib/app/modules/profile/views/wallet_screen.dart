import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/modules/profile/views/card_section.dart';
import 'package:wisper/app/modules/profile/views/transaction_section.dart';
import 'package:wisper/app/modules/profile/widget/wallet_option.dart';
import 'package:wisper/gen/assets.gen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int isSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150.h,
            width: double.infinity,
            decoration: BoxDecoration(color: LightThemeColors.blueColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 6,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total Balance',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '\$15.00',
                            style: TextStyle(
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 21.r,
                        backgroundImage: AssetImage(
                          Assets.images.image.keyName,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          heightBox20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              WalletOption(
                bgColor: isSelected == 0
                    ? LightThemeColors.blueColor
                    : Colors.transparent,
                borderColor: isSelected == 0
                    ? Colors.transparent
                    : Colors.white.withValues(alpha: 0.20),
                title: 'Deposit',

                onTap: () {
                  setState(() {
                    isSelected = 0;
                  });
                },
              ),
              WalletOption(
                bgColor: isSelected == 1
                    ? LightThemeColors.blueColor
                    : Colors.transparent,
                borderColor: isSelected == 1
                    ? Colors.transparent
                    : Colors.white.withValues(alpha: 0.20),
                title: 'Add',
                onTap: () {
                  setState(() {
                    isSelected = 1;
                  });
                },
              ),
              WalletOption(
                bgColor: isSelected == 2
                    ? LightThemeColors.blueColor
                    : Colors.transparent,
                borderColor: isSelected == 2
                    ? Colors.transparent
                    : Colors.white.withValues(alpha: 0.20),
                title: 'Withdraw',
                onTap: () {
                  setState(() {
                    isSelected = 2;
                  });
                },
              ),
            ],
          ),

          heightBox10,
          isSelected == 0 ? TransactionSection() : Container(),
          isSelected == 1 ? CardSection() : Container(),
          isSelected == 2 ? Container() : Container(),
        ],
      ),
    );
  }
}
