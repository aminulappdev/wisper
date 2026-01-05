import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/modules/chat/widgets/chatting_field.dart';
import 'package:wisper/gen/assets.gen.dart';

class MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  // isSendEnabled RxBool
  final RxBool isSendEnabled = false.obs;

  MessageInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Card(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: ChattingFieldWidget(
                    controller: controller,
                    isSendEnabled: isSendEnabled,
                  ),
                ),
                const SizedBox(width: 6),
                Obx(() => CircleIconWidget(
                      imagePath: Assets.images.send.keyName,
                      radius: 20,
                      iconRadius: 24,
                      iconColor: isSendEnabled.value ? Colors.blue : Colors.grey,
                      // onTap cannot be null, use empty fn if disabled
                      onTap: isSendEnabled.value ? onSend : () {},
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
