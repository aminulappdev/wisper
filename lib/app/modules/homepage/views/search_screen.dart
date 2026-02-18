import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/others/custom_size.dart';
import 'package:wisper/app/core/widgets/common/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/common/line_widget.dart';
import 'package:wisper/app/modules/chat/controller/all_connection_controller.dart';
import 'package:wisper/app/modules/chat/widgets/select_option_widget.dart';
import 'package:wisper/app/modules/job/controller/feed_job_controller.dart';
import 'package:wisper/app/modules/job/views/job_section.dart';
import 'package:wisper/app/modules/homepage/views/role_section.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final AllFeedJobController jobController = Get.find<AllFeedJobController>();
  // final AllConnectionController allConnectionController = Get.put(AllConnectionController());

  int selectedIndex = 0;

  String? selectedLocationType; // null = Any, 'REMOTE', 'ON_SITE', 'HYBRID'

  String _previousSearch = '';
  String? _previousLocation;

  @override
  void initState() {
    super.initState();
    // Optional: load initial jobs when screen opens
    _fetchJobsIfNeeded();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _fetchJobsIfNeeded() {
    final currentSearch = searchController.text.trim();
    final currentLocation = selectedLocationType;

    if (currentSearch != _previousSearch ||
        currentLocation != _previousLocation) {
      jobController.resetPagination();
      jobController.getJobs(
        searchQuery: currentSearch.isEmpty ? null : currentSearch,
        locationType: currentLocation,
      );
      _previousSearch = currentSearch;
      _previousLocation = currentLocation;
    }
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
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromARGB(255, 179, 177, 177),
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    hintText: 'Search jobs...',
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {});
                      _fetchJobsIfNeeded();
                    },
                  ),
                ),
              ],
            ),

            heightBox12,

            // Location filter ── only for Jobs tab
            if (selectedIndex == 0)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 44.h,
                  width: MediaQuery.of(context).size.width * 0.79,
                  child: CustomTextField(
                    hintText: 'Location type',
                    value: selectedLocationType,

                    items: const [
                      DropdownMenuItem(
                        value: null,
                        child: Text('Any location'),
                      ),
                      DropdownMenuItem(value: 'REMOTE', child: Text('Remote')),
                      DropdownMenuItem(
                        value: 'ON_SITE',
                        child: Text('On-site'),
                      ),
                      DropdownMenuItem(value: 'HYBRID', child: Text('Hybrid')),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLocationType = newValue;
                      });
                      _fetchJobsIfNeeded();
                    },
                  ),
                ),
              ),

            if (selectedIndex == 0) heightBox20,

            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => setState(() => selectedIndex = 0),
                  child: SelectOptionWidget(
                    currentIndex: 0,
                    selectedIndex: selectedIndex,
                    title: 'Jobs',
                    lineColor: LightThemeColors.blueColor,
                  ),
                ),
                SizedBox(width: 24.w),
                GestureDetector(
                  onTap: () => setState(() => selectedIndex = 1),
                  child: SelectOptionWidget(
                    currentIndex: 1,
                    selectedIndex: selectedIndex,
                    title: 'Roles',
                    lineColor: LightThemeColors.blueColor,
                  ),
                ),
              ],
            ),

            const StraightLiner(height: 0.5, color: Color(0xff454545)),
            SizedBox(height: 12.h),

            Expanded(
              child: selectedIndex == 0
                  ? JobSection(
                      searchQuery: searchController.text.trim(),
                      jobType: selectedLocationType,
                    )
                  : RoleSection(searchQuery: searchController.text.trim()),
            ),
          ],
        ),
      ),
    );
  }
}
