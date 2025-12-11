import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/modules/chat/views/create_group_class_screen.dart';
import 'package:wisper/gen/assets.gen.dart';

class ChatListHeader extends StatelessWidget {
  const ChatListHeader({super.key});

  @override 
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      'Chats',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                CircleIconWidget(

                  radius: 18,
                  iconRadius: 15,
                  color: Color(0xffFFFFFF).withValues(alpha: 0.05),
                  imagePath: Assets.images.plus.path,
                  iconColor: Colors.white,
                  onTap: () {
                    Get.to(()=> CreateGroupClassScreen());
                  },
                ),
              ],
            ),
            heightBox16,
            CustomTextField(
              prefixIcon: Icons.search_outlined,
              pprefixIconColor: Color(0xff7A7A7A),
              hintText: 'Search',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
