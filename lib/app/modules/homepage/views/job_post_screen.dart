import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/label.dart';

class JobPostScreen extends StatefulWidget {
  const JobPostScreen({super.key});

  @override
  State<JobPostScreen> createState() => _JobPostScreenState();
}

class _JobPostScreenState extends State<JobPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightBox40,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400, 
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 32,
                      width: 66,
                      child: CustomElevatedButton(
                        title: 'Post',
                        textSize: 12,
                        borderRadius: 50,
                        onPress: () {},
                      ),
                    ),
                  ],
                ),
                heightBox16,
                Text(
                  'Post a job',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                heightBox12,
                Label(label: 'Job Title'),
                heightBox4,
                CustomTextField(hintText: 'Enter job title'),
                heightBox12,
                Label(label: 'Description'),
                heightBox4,
                SizedBox(
                  height: 150.h,
                  child: CustomTextField(
                    maxLines: 5,
                    hintText: 'Share your thoughts',
                    hintStyle: TextStyle(
                      fontSize: 16.sp,
                      color: Color(0xff8C8C8C),
                    ),
                  ),
                ),
                heightBox12,
                Label(label: 'Job Type'),
                heightBox4,
                CustomTextField(
                  hintText: 'Select job type',
                  items: [
                    DropdownMenuItem(
                      value: '3 Days 10 USD',
                      child: Text('3 Days 10 USD'),
                    ),
                    DropdownMenuItem(
                      value: '7 Days 50 USD',
                      child: Text('7 Days 50 USD'),
                    ),
                    DropdownMenuItem(
                      value: '10 Days 100 USD',
                      child: Text('10 Days 100 USD'),
                    ),
                    DropdownMenuItem(
                      value: '15 Days 200 USD',
                      child: Text('15 Days 200 USD'),
                    ),
                  ],
                ),

                heightBox12,
                Label(label: 'Experience Level'),
                heightBox4,
                CustomTextField(
                  hintText: 'Select skill level required',
                  items: [
                    DropdownMenuItem(
                      value: '3 Days 10 USD',
                      child: Text('3 Days 10 USD'),
                    ),
                    DropdownMenuItem(
                      value: '7 Days 50 USD',
                      child: Text('7 Days 50 USD'),
                    ),
                    DropdownMenuItem(
                      value: '10 Days 100 USD',
                      child: Text('10 Days 100 USD'),
                    ),
                    DropdownMenuItem(
                      value: '15 Days 200 USD',
                      child: Text('15 Days 200 USD'),
                    ),
                  ],
                ),
                heightBox12,
                Label(label: 'Compensation type'),
                heightBox4,
                CustomTextField(
                  hintText: 'Select compensation type',
                  items: [
                    DropdownMenuItem(
                      value: '3 Days 10 USD',
                      child: Text('3 Days 10 USD'),
                    ),
                    DropdownMenuItem(
                      value: '7 Days 50 USD',
                      child: Text('7 Days 50 USD'),
                    ),
                    DropdownMenuItem(
                      value: '10 Days 100 USD',
                      child: Text('10 Days 100 USD'),
                    ),
                    DropdownMenuItem(
                      value: '15 Days 200 USD',
                      child: Text('15 Days 200 USD'),
                    ),
                  ],
                ),
                heightBox12,
                Label(label: 'Set Price'),
                heightBox4,
                Row(
                  children: [
                    SizedBox(
                      width: 110.w,
                      child: CustomTextField(hintText: '100'),
                    ),
                    widthBox10,
                    Text(
                      '/ hour',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff8C8C8C),
                      ),
                    ),
                  ],
                ),
                heightBox12,
                Label(label: 'Location'),
                heightBox4,
                CustomTextField(
                  hintText: 'Select location',
                  items: [
                    DropdownMenuItem(
                      value: '3 Days 10 USD',
                      child: Text('3 Days 10 USD'),
                    ),
                    DropdownMenuItem(
                      value: '7 Days 50 USD',
                      child: Text('7 Days 50 USD'),
                    ),
                    DropdownMenuItem(
                      value: '10 Days 100 USD',
                      child: Text('10 Days 100 USD'),
                    ),
                    DropdownMenuItem(
                      value: '15 Days 200 USD',
                      child: Text('15 Days 200 USD'),
                    ),
                  ],
                ),
                heightBox12,
                Label(label: 'Educational Qualification'),
                heightBox4,
                CustomTextField(
                  hintText: 'Select educational qualification',
                  items: [
                    DropdownMenuItem(
                      value: '3 Days 10 USD',
                      child: Text('3 Days 10 USD'),
                    ),
                    DropdownMenuItem(
                      value: '7 Days 50 USD',
                      child: Text('7 Days 50 USD'),
                    ),
                    DropdownMenuItem(
                      value: '10 Days 100 USD',
                      child: Text('10 Days 100 USD'),
                    ),
                    DropdownMenuItem(
                      value: '15 Days 200 USD',
                      child: Text('15 Days 200 USD'),
                    ),
                  ],
                ),

                heightBox12,
                Label(label: 'How do you want candidates to apply?'),
                heightBox4,
                CustomTextField(
                  hintText: 'Select below',
                  items: [
                    DropdownMenuItem(
                      value: '3 Days 10 USD',
                      child: Text('3 Days 10 USD'),
                    ),
                    DropdownMenuItem(
                      value: '7 Days 50 USD',
                      child: Text('7 Days 50 USD'),
                    ),
                    DropdownMenuItem(
                      value: '10 Days 100 USD',
                      child: Text('10 Days 100 USD'),
                    ),
                    DropdownMenuItem(
                      value: '15 Days 200 USD',
                      child: Text('15 Days 200 USD'),
                    ),
                  ],
                ),

                Label(label: 'Enter application URL'),
                heightBox4,
                CustomTextField(hintText: 'Enter URL'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
