import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/label.dart';
import 'package:wisper/app/modules/authentication/views/update_password_success_screen.dart';
import 'package:wisper/app/modules/authentication/widget/auth_header.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
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
                title: 'Reset Password',
                subtitle:
                    'Please enter your email address to reset your password',
              ),
              heightBox30,
              Label(label: 'Password'),
              heightBox10,
              CustomTextField(
                controller: passwordController,
                suffixIcon: Icons.remove_red_eye_outlined,
                hintText: '********',
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              heightBox12,
              Label(label: 'Confirm Password'),
              heightBox10,
              CustomTextField(
                controller: confirmPasswordController,
                suffixIcon: Icons.remove_red_eye_outlined,
                hintText: '********',
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
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
                    Get.to(() => PasswordUpdateSuccessScreen());
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
