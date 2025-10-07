import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/label.dart';
import 'package:wisper/app/modules/authentication/views/otp_verification_screen.dart';
import 'package:wisper/app/modules/authentication/widget/auth_header.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 0.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              heightBox60,
              AuthHeader(title: 'Edit Profile Details'),
              heightBox30,

              Label(label: 'Full Name'),
              heightBox10,
              CustomTextField(
                hintText: 'Enter full name',
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter  name';
                  }
                  return null;
                },
              ),
              heightBox10,
              Label(label: 'Email'),
              heightBox10,
              CustomTextField(
                hintText: 'example@gmail.com',
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              heightBox10,
              Label(label: 'Phone Number'),
              heightBox10,
              CustomTextField(
                hintText: 'Enter phone number',
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number';
                  }
                  return null;
                },
              ),
              heightBox10,
              Label(label: 'Job Title'),
              heightBox10,
              CustomTextField(
                hintText: 'Select job title',
                items: [
                  DropdownMenuItem(
                    value: 'Flutter Developer',
                    child: Text('Flutter Developer'),
                  ),
                  DropdownMenuItem(
                    value: 'Graphic Designer',
                    child: Text('Graphic Designer'),
                  ),
                  DropdownMenuItem(
                    value: 'UI/UX Designer',
                    child: Text('UI/UX Designer'),
                  ),
                ],
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              heightBox100,
              heightBox50,

              Center(
                child: CustomElevatedButton(
                  height: 56,
                  title: 'Submit',
                  onPress: () {
                    Get.to(() => OtpVerificationScreen(isResetpassword: true));
                  },
                  color: Colors.blue,
                ),
              ),
              heightBox20,
            ],
          ),
        ),
      ),
    );
  }
}
