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
import 'package:wisper/app/modules/authentication/controller/change_password_controller.dart';
import 'package:wisper/app/modules/authentication/views/update_password_success_screen.dart';
import 'package:wisper/app/modules/authentication/widget/auth_header.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  ChangePasswordController changePasswordController = Get.put(
    ChangePasswordController(),
  );

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  void changePassword() {
    showLoadingOverLay(
      asyncFunction: () async => await performChangePassword(context),
      msg: 'Please wait...',
    );
  }

  Future<void> performChangePassword(BuildContext context) async {
    final bool isSuccess = await changePasswordController.changePassword(
      oldPassword: oldPasswordController.text,
      newPassword: passwordController.text,
    );

    if (isSuccess) {
      Get.to(() => PasswordUpdateSuccessScreen());
    } else {
      showSnackBarMessage(context, changePasswordController.errorMessage, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 0.0.w),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                heightBox60,
                AuthHeader(title: 'Change Password'),
                heightBox20,
                Label(label: 'Old Password'),
                heightBox10,
                CustomTextField(
                  controller: oldPasswordController,
                  suffixIcon: Icons.remove_red_eye_outlined,
                  hintText: '********',
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  validator: (value) => ValidatorService.validatePassword(
                    oldPasswordController.text,
                  ),
                ),
                heightBox12,
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

                heightBox200,
                heightBox100,
                Center(
                  child: CustomElevatedButton(
                    height: 56,
                    title: 'Submit',
                    onPress: () {
                      if (formKey.currentState!.validate()) {
                        changePassword();
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
    );
  }
}
