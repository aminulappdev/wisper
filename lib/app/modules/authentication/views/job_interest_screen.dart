import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/modules/authentication/views/all_set_screen.dart';

// Global variable to store selected interests
List<String> selectedInterests = [];

class JobInterestScreen extends StatefulWidget {
  const JobInterestScreen({super.key});

  @override
  State<JobInterestScreen> createState() => _JobInterestScreenState();
}

class _JobInterestScreenState extends State<JobInterestScreen> {
  final List<String> jobInterests = [
    'AgriTech',
    'Agriculture and Agribusiness',
    'Banking and Financial Services',
    'Beauty and Personal Care',
    'Building Materials Production',
    'Cosmetic Products',
    'Diagnostic Services',
    'Digital Media and Entertainment',
    'Edtech',
    'Electronics and Appliances Retail',
    'E-Learning and Online Education',
    'Energy and Power',
    'Event Planning and Management',
    'Fashion and Accessories Retail',
    'Fintech',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 0.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              heightBox60,
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.to(const AllSetScreen()),
                  child: Text(
                    'finished',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: LightThemeColors.blueColor,
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 24.h),
              Text(
                'Which positions are you interested in?',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800),
              ),
              heightBox12,
              CustomTextField(
                controller: TextEditingController(),
                hintText: 'Search job title',
                validator: (value) {
                  return null;
                },
              ),
              heightBox12,
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedInterests.contains(jobInterests[index])) {
                          selectedInterests.remove(jobInterests[index]);
                        } else {
                          selectedInterests.add(jobInterests[index]);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        jobInterests[index],
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: selectedInterests.contains(jobInterests[index])
                              ? Colors.blue
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  itemCount: jobInterests.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
