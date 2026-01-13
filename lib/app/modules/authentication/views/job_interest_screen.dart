import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/others/custom_size.dart';
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/common/custom_text_filed.dart';
import 'package:wisper/app/modules/authentication/controller/sign_up_controller.dart';
import 'package:wisper/app/modules/authentication/views/otp_verification_screen.dart';

// Single selected interest only
String? selectedInterest;

class JobInterestScreen extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? bussinessName;
  final String? email;
  final String? phone;
  final String? password;
  final String? title;
  const JobInterestScreen({
    super.key,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.password,
    this.title,
    this.bussinessName,
  });

  @override
  State<JobInterestScreen> createState() => _JobInterestScreenState();
}

class _JobInterestScreenState extends State<JobInterestScreen> {
  final SignUpController signUpController = Get.put(SignUpController());

  final List<String> jobInterests = [
    'AgriTech',
    'Agriculture and Agribusiness',
    'Banking and Financial Services',
    'Beauty and Personal Care',
    'Building Materials Production',
    'Cosmetic Products',
    'Diagnostic Services',
    'Digital Media and Entertainment',
    'Edtech',
    'Electronics and Appliances Retail',
    'E-Learning and Online Education',
    'Energy and Power',
    'Event Planning and Management',
    'Fashion and Accessories Retail',
    'Fintech',
  ];

  void _finishSignUp() {
    showLoadingOverLay(
      asyncFunction: () async => await widget.title == null
          ? signUpWithRecruiter(context)
          : signUpWithPerson(context),
      msg: 'Please wait...',
    );
  }

  Future<void> signUpWithPerson(BuildContext context) async {
    final bool isSuccess = await signUpController.signUp(
      firstName: widget.firstName,
      lastName: widget.lastName,
      email: widget.email,
      phone: widget.phone,
      password: widget.password,
      confirmPassword: widget.password,
      title: widget.title,
      industry: selectedInterest ?? '', // single string
    );

    if (isSuccess) {
      showSnackBarMessage(context, 'Successfully done');
      Get.to(() => OtpVerificationScreen(email: widget.email ?? ''));
    } else {
      showSnackBarMessage(context, signUpController.errorMessage, true);
    }
  }

  Future<void> signUpWithRecruiter(BuildContext context) async {
    final bool isSuccess = await signUpController.signUp(
      firstName: widget.firstName,
      lastName: widget.lastName,
      bussinessName: widget.bussinessName,
      email: widget.email,
      phone: widget.phone,
      password: widget.password,
      confirmPassword: widget.password,
      title: widget.title,
      industry: selectedInterest ?? '',
    );

    if (isSuccess) {
      showSnackBarMessage(context, 'Successfully done');
      Get.to(() => OtpVerificationScreen(email: widget.email ?? ''));
    } else {
      showSnackBarMessage(context, signUpController.errorMessage, true);
    }
  }
  
  @override
  dispose() {
    selectedInterest = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 0.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              heightBox60,
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _finishSignUp,
                  child: Text(
                    'finished',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: LightThemeColors.blueColor,
                    ),
                  ),
                ),
              ),
              Text(
                'Which position are you interested in?', // changed question slightly for single
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800),
              ),
              heightBox12,
              CustomTextField(
                controller: TextEditingController(),
                hintText: 'Search job title',
                validator: (value) => null,
              ),
              heightBox12,
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedInterest == jobInterests[index]) {
                          selectedInterest = null; // deselect if tapped again
                        } else {
                          selectedInterest = jobInterests[index]; // select this one only
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        jobInterests[index],
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: selectedInterest == jobInterests[index]
                              ? Colors.blue // or LightThemeColors.blueColor
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  itemCount: jobInterests.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}