// ignore_for_file: use_build_context_synchronously

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
import 'package:wisper/app/modules/authentication/widget/auth_header.dart';
import 'package:wisper/app/modules/profile/controller/buisness/buisness_controller.dart';
import 'package:wisper/app/modules/profile/controller/buisness/edit_buisness_profile_controller.dart';
import 'package:wisper/app/modules/profile/controller/person/profile_controller.dart';

class EditBusinessProfileScreen extends StatefulWidget {
  const EditBusinessProfileScreen({super.key});

  @override
  State<EditBusinessProfileScreen> createState() =>
      _EditBusinessProfileScreenState();
}

class _EditBusinessProfileScreenState extends State<EditBusinessProfileScreen> {
  final BusinessController profileController = Get.find<BusinessController>();
  final EditBusinessProfileController editProfileController =
      EditBusinessProfileController();
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  String? _selectedTitle;

  @override
  void initState() {
    super.initState();

    final user = profileController.buisnessData!.auth?.business;
    _nameCtrl.text = user?.name ?? '';
    _emailCtrl.text = user?.email ?? '';
    _phoneCtrl.text = user?.phone ?? '';
    _addressCtrl.text = user?.address ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _submitProfile() {
    if (_formKey.currentState!.validate()) {
      showLoadingOverLay(
        asyncFunction: () async => await _performEditProfile(),
        msg: 'Updating profile...',
      );
    }
  }

  Future<void> _performEditProfile() async {
    final bool isSuccess = await editProfileController.editProfile(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
    );

    if (isSuccess) {
      final BusinessController profileController =
          Get.find<BusinessController>();
      profileController.getMyProfile();
      Navigator.pop(context);
      showSnackBarMessage(context, 'Profile updated successfully', false);
    } else {
      showSnackBarMessage(context, editProfileController.errorMessage, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightBox60,
              AuthHeader(title: 'Edit Profile Details'),
              heightBox30,

              const Label(label: 'Full Name'),
              heightBox10,
              CustomTextField(
                controller: _nameCtrl,
                hintText: 'Enter full name',
                keyboardType: TextInputType.name,
                validator: ValidatorService.validateSimpleField,
              ),

              heightBox20,
              const Label(label: 'Email'),
              heightBox10,
              CustomTextField(
                controller: _emailCtrl,
                hintText: 'example@gmail.com',
                keyboardType: TextInputType.emailAddress,
                enabled: false,
              ),

              heightBox20,
              const Label(label: 'Phone Number'),
              heightBox10,
              CustomTextField(
                controller: _phoneCtrl,
                hintText: 'Enter phone number',
                keyboardType: TextInputType.phone,
                validator: ValidatorService.validateSimpleField,
              ),

              heightBox20,
              const Label(label: 'Address'),
              heightBox10,
              CustomTextField(
                controller: _addressCtrl,
                hintText: 'Enter address',
                keyboardType: TextInputType.text,
                validator: ValidatorService.validateSimpleField,
              ),

              heightBox50,
              Center(
                child: CustomElevatedButton(
                  height: 56.h,
                  title: 'Submit',
                  onPress: _submitProfile,
                  color: Colors.blue,
                ),
              ),
              heightBox50,
            ],
          ),
        ),
      ),
    );
  }
}
