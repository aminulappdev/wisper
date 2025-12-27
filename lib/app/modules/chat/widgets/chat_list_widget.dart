import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/modules/chat/views/create_group_class_screen.dart';
import 'package:wisper/gen/assets.gen.dart';

class ChatListHeader extends StatelessWidget {
  final TextEditingController searchController; 
  final VoidCallback onSearchChanged;

  const ChatListHeader({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
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
                Text(
                  'Chats',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                CircleIconWidget(
                  radius: 18,
                  iconRadius: 15,
                  color: const Color(0xffFFFFFF).withValues(alpha: 0.05),
                  imagePath: Assets.images.plus.path,
                  iconColor: Colors.white,
                  onTap: () {
                    Get.to(() => const CreateGroupClassScreen());
                  },
                ),
              ],
            ),
            heightBox16,
            CustomTextField(
              controller: searchController, // controller যোগ করা হয়েছে
              prefixIcon: Icons.search_outlined,
              pprefixIconColor: const Color(0xff7A7A7A),
              hintText: 'Search',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 2,
              ),
              onChanged: (value) {
                onSearchChanged(); // প্রতিবার টেক্সট চেঞ্জ হলে কল করা হবে
              },
            ),
          ],
        ),
      ),
    );
  }
}