import 'package:flutter/material.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/utils/validator_service.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/label.dart';

class InformationSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController titleController;

  const InformationSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.titleController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(label: 'First Name'),
        heightBox10,
        CustomTextField(
          controller: firstNameController,
          hintText: 'Enter first name',
          keyboardType: TextInputType.name,
          validator: ValidatorService.validateSimpleField,
        ),
        heightBox12,
        Label(label: 'Last Name'),
        heightBox10,
        CustomTextField(
          controller: lastNameController,
          hintText: 'Enter last name',
          keyboardType: TextInputType.name,
          validator: ValidatorService.validateSimpleField,
        ),
        heightBox12,
        Label(label: 'Email'),
        heightBox10,
        CustomTextField(
          controller: emailController,
          hintText: 'email@gmail.com',
          keyboardType: TextInputType.emailAddress,
          validator: (value) =>
              ValidatorService.validateEmailAddress(emailController.text),
        ),
        heightBox12,
        Label(label: 'Phone Number'),
        heightBox10,
        CustomTextField(
          controller: phoneController,
          hintText: 'Enter phone number',
          keyboardType: TextInputType.phone,
          validator: ValidatorService.validateSimpleField,
        ),
        heightBox12,
        Label(label: 'Job Type'),
        heightBox10,
        CustomTextField(
          controller: titleController,
          hintText: 'Enter your designation',
          keyboardType: TextInputType.text,
          validator: ValidatorService.validateSimpleField,
        ),
      ],
    );
  }
}
