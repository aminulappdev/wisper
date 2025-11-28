import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/utils/validator_service.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/label.dart';
import 'package:wisper/app/modules/authentication/controller/reset_password_controller.dart';
import 'package:wisper/app/modules/authentication/views/update_password_success_screen.dart';
import 'package:wisper/app/modules/authentication/widget/auth_header.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final ResetPasswordController resetPasswordController = Get.put(
    ResetPasswordController(),
  );

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  void resetPassword() {
    showLoadingOverLay(
      asyncFunction: () async => await perforResetPassword(context),
      msg: 'Please wait...',
    );
  }

  Future<void> perforResetPassword(BuildContext context) async {
    final bool isSuccess = await resetPasswordController.resetPassword(
      email: widget.email,
      password: passwordController.text,
    );

    if (isSuccess) {
      Get.offAll(() => PasswordUpdateSuccessScreen());
    } else {
      showSnackBarMessage(context, resetPasswordController.errorMessage, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 0.0.w),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
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
                    validator: (value) => ValidatorService.validatePassword(
                      passwordController.text,
                    ),
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
                    validator: (value) =>
                        ValidatorService.validateConfirmPassword(
                          value,
                          passwordController.text,
                        ),
                  ),
                  heightBox50,

                  Center(
                    child: CustomElevatedButton(
                      height: 56,
                      title: 'Submit',
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          resetPassword();
                        }
                      },
                      color: Colors.blue,
                    ),
                  ),
                  heightBox20,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
