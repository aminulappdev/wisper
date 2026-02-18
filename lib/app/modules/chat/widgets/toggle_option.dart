import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/widgets/common/toogle_button.dart';

class ToggleOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isToggled;        // নতুন প্রপ
  final void Function(bool) onToggle; 

  const ToggleOption({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isToggled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: LightThemeColors.themeGreyColor,
              ),
            ),
          ],
        ),
        ToggleButton(
          isToggled: isToggled,
          onToggle: onToggle,
        ),
      ],
    );
  }
}