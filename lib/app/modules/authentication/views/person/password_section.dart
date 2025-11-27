
import 'package:flutter/material.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/utils/validator_service.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/label.dart';

class PasswordSection extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const PasswordSection({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(label: 'Password'),
        heightBox10,
        CustomTextField(
          controller: passwordController,
          suffixIcon: Icons.remove_red_eye_outlined,
          hintText: '********',
          obscureText: true,
          keyboardType: TextInputType.text,
          validator: (value) =>
              ValidatorService.validatePassword(passwordController.text),
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
          validator: (value) => ValidatorService.validateConfirmPassword(
            value,
            passwordController.text,
          ),
        ),
      ],
    );
  }
}
