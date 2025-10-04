import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPopupMenu extends StatelessWidget {
  final GlobalKey targetKey;
  final List<Widget> options; // Changed from List<String> to List<Widget>
  final Map<String, VoidCallback> optionActions;
  final double? menuWidth;
  final double? menuHeight;

  const CustomPopupMenu({
    super.key,
    required this.targetKey,
    required this.options,
    required this.optionActions,
    this.menuWidth,
    this.menuHeight,
  });

  void showMenuAtPosition(BuildContext context) {
    // Check if the key has a valid context
    if (targetKey.currentContext == null) {
      debugPrint('Error: GlobalKey has no associated widget');
      return;
    }

    // Get the position of the target widget using the GlobalKey
    final RenderBox? button =
        targetKey.currentContext!.findRenderObject() as RenderBox?;
    if (button == null) {
      debugPrint('Error: Unable to find RenderBox for the target widget');
      return;
    }
    final Offset buttonPosition = button.localToGlobal(Offset.zero);
    final Size buttonSize = button.size;

    // Ensure the menu stays within screen bounds
    final screenWidth = MediaQuery.of(context).size.width;
    final menuWidthValue = menuWidth?.w ?? 150.w;
    final leftPosition = (buttonPosition.dx - menuWidthValue).clamp(
      0.0,
      screenWidth - menuWidthValue,
    );

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        leftPosition, // Position menu to the left of the target widget
        buttonPosition.dy +
            buttonSize.height +
            8.h, // Below the widget with slight offset
        buttonPosition.dx,
        0,
      ),
      items: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        return PopupMenuItem<String>(
          value: index.toString(), // Use index as a string identifier
          height: menuHeight != null
              ? (menuHeight ?? 48.h / options.length).clamp(40.h, 60.h)
              : 48.h, // Constrain height per item
          child: SizedBox(
            width: menuWidthValue, // Apply custom width
            child: option, // Use the widget directly
          ),
          onTap: () {
            // Execute the action associated with the index
            final action = optionActions[index.toString()];
            if (action != null) {
              action();
            }
          },
        );
      }).toList(),
      
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r), side: const BorderSide(color: Color(0xff292727), width: 1)),
      color: Colors.black,
      elevation: 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    // This widget doesn't render anything itself; it provides the showMenuAtPosition method
    return const SizedBox.shrink();
  }
}