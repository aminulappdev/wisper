import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/label.dart';
import 'package:wisper/app/modules/authentication/views/otp_verification_screen.dart';
import 'package:wisper/app/modules/authentication/views/sign_in_screen.dart';
import 'package:wisper/gen/assets.gen.dart';

class RecruiterSignUpScreen extends StatefulWidget {
  const RecruiterSignUpScreen({super.key});

  @override
  State<RecruiterSignUpScreen> createState() => _RecruiterSignUpScreenState();
}

class _RecruiterSignUpScreenState extends State<RecruiterSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 0.0.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightBox60,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(const SignInScreen()),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: LightThemeColors.blueColor,
                      ),
                    ),
                  ),
                ],
              ),
              heightBox30,
              Label(label: 'Bussiness Name'),
              heightBox10,
              CustomTextField(
                hintText: 'Bussiness Name',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an name';
                  }
                  return null;
                },
              ),
              heightBox16,
              Label(label: 'Email'),
              heightBox10,
              CustomTextField(
                hintText: 'email@gmail.com',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              
              heightBox16,
              Label(label: 'Password'),
              heightBox10,
              CustomTextField(
                suffixIcon: Icons.remove_red_eye_outlined,
                hintText: '********',
                obscureText: true, // Enable password hiding
                keyboardType: TextInputType.text, // Fixed for password
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              
              
              heightBox80,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Sign Up With",
                    style: TextStyle(
                      color: const Color(0xff8C8C8C),
                      fontSize: 16.sp,
                    ),
                  ),
                  heightBox10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CrashSafeImage(Assets.images.gmail.keyName, height: 30.h),
                      widthBox14,
                      CrashSafeImage(
                        Assets.images.facebook.keyName,
                        height: 30.h,
                      ),
                    ],
                  ),
                ],
              ),

              heightBox100,
              heightBox50,

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'By signing up, I agree to the Wispa  ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xffAEAEAE),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: 'Terms and Conditions',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 14.sp,
                        color: Color(0xffAEAEAE),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: ' and ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xffAEAEAE),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 14.sp,
                        color: Color(0xffAEAEAE),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              heightBox10,
              CustomElevatedButton(height: 56, title: 'Sign Up', onPress: () {
                Get.to(const OtpVerificationScreen());
              }),
            ],
          ),
        ),
      ),
    );
  }
}
