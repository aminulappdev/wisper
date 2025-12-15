import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/modules/chat/widgets/chatting_field.dart';
import 'package:wisper/gen/assets.gen.dart';

class MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttachment;

  const MessageInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onAttachment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        color: Colors.black,
        child: Container(
          height: 70.h,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(child: ChattingFieldWidget(controller: controller)),
              CircleIconWidget(
                imagePath: Assets.images.attatchment.keyName,
                onTap: onAttachment,
                radius: 18,
                iconRadius: 24,
              ),
              widthBox8,
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
    );
  }
}