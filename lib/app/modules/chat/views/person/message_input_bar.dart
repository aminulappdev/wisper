// MessageInputBar.dart (unchanged)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/modules/chat/widgets/chatting_field.dart';
import 'package:wisper/gen/assets.gen.dart';

class MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInputBar({
    super.key,
    required this.controller, 
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Added to prevent system UI overflow
      top: false,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
          elevation: 2,
          color: Colors.black,
          child: IntrinsicHeight(
            // Key change: Allows dynamic height
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.end, // Aligns items to bottom
                children: [
                  Expanded(child: ChattingFieldWidget(controller: controller)),
                  SizedBox(width: 8.w), // Small spacing
                  CircleIconWidget(
                    imagePath: Assets.images.send.keyName,
                    onTap: onSend,
                    radius: 18,
                    iconRadius: 24,
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
