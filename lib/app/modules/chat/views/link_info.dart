import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/details_card.dart';
import 'package:wisper/gen/assets.gen.dart';

class LinkInfo extends StatelessWidget {
  const LinkInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: 10,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: DetailsCard(
            bgColor: Colors.transparent,
            borderWidth: 0.5,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CrashSafeImage(
                    Assets.images.browse.keyName,
                    height: 16,
                    width: 16,
                    color: Colors.white,
                  ),
                  widthBox10,
                  Text(
                    'https://randomstuff.fun/xy9p7a',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
