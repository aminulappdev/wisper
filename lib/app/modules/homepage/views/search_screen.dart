import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/chat/controller/all_connection_controller.dart';
import 'package:wisper/app/modules/chat/widgets/select_option_widget.dart';
import 'package:wisper/app/modules/homepage/controller/feed_job_controller.dart';
import 'package:wisper/app/modules/homepage/views/job_section.dart';
import 'package:wisper/app/modules/homepage/views/role_section.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  final AllFeedJobController allFeedJobController = Get.put(
    AllFeedJobController(),
  );
  final AllConnectionController allConnectionController = Get.put(
    AllConnectionController(),
  );
  int selectedIndex = 0;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            heightBox30,
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromARGB(255, 179, 177, 177),
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    hintText: 'Search',
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {}); // ei line add korle ki hobe?
                    },
                  ),
                ),
              ],
            ),
            heightBox20,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: SelectOptionWidget(
                    currentIndex: 0,
                    selectedIndex: selectedIndex,
                    title: 'Jobs',
                    lineColor: LightThemeColors.blueColor,
                  ),
                ),
                SizedBox(width: 20.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: SelectOptionWidget(
                    currentIndex: 1,
                    selectedIndex: selectedIndex,
                    title: 'Roles',
                    lineColor: LightThemeColors.blueColor,
                  ),
                ),
              ],
            ),
            const StraightLiner(height: 0.4, color: Color(0xff454545)),
            SizedBox(height: 10.h),
            if (selectedIndex == 0)
              Expanded(child: JobSection(searchQuery: searchController.text)),
            if (selectedIndex == 1)
              Expanded(child: RoleSection(searchQuery: searchController.text)),
          ],
        ),
      ),
    );
  }
}
