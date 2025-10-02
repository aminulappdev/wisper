import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/label.dart';
import 'package:wisper/app/modules/authentication/views/otp_verification_screen.dart';
import 'package:wisper/app/modules/authentication/widget/auth_header.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 0.0.w),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              heightBox60,
              AuthHeader(
                title: 'Forget Password',
                subtitle:
                    'Please enter your email address to reset your password',
              ),
              heightBox30,
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
              heightBox50,

              Expanded(child: heightBox10),
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
