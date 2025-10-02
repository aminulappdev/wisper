import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/label.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/authentication/views/otp_verification_screen.dart';
import 'package:wisper/app/modules/authentication/views/sign_in_screen.dart';
import 'package:wisper/gen/assets.gen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isPasswordPage = false;
  bool showConfirmButton = false;
  bool showPreviousButton = false;
  bool showFinishedButton = false;
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Add listeners to update showConfirmButton
    _firstNameController.addListener(_checkFields);
    _lastNameController.addListener(_checkFields);
    _emailController.addListener(_checkFields);
    _phoneController.addListener(_checkFields);
  }

  void _checkFields() {
    setState(() {
      showConfirmButton =
          _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _goToPasswordPage() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isPasswordPage = true;
        showPreviousButton = true;
        showFinishedButton = true;
        showConfirmButton = false;
      });
    }
  }

  void _goToInformationPage() {
    setState(() {
      isPasswordPage = false;
      showPreviousButton = false;
      showFinishedButton = false;
      showConfirmButton =
          _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty;
    });
  }

  void _finishSignUp() {
    if (_formKey.currentState!.validate()) {
      Get.to(()=> const OtpVerificationScreen());
      // // Handle signup logic here (e.g., API call)
      // print('Sign-up completed with:');
      // print('First Name: ${_firstNameController.text}');
      // print('Last Name: ${_lastNameController.text}');
      // print('Email: ${_emailController.text}');
      // print('Phone: ${_phoneController.text}');
      // print('Password: ${_passwordController.text}');

      // Navigate to next screen or show success message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 0.0.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightBox50,
              isPasswordPage
                  ? GestureDetector(
                      onTap: _goToInformationPage,
                      child: Row(
                        children: [
                          CircleIconWidget(
                            color: LightThemeColors.blueColor,
                            iconColor: Colors.white,
                            imagePath: Assets.images.arrowBack.keyName,
                            onTap: () {},
                          ),
                          widthBox8,
                          Text(
                            'Previous',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: LightThemeColors.blueColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : CircleIconWidget(
                      imagePath: Assets.images.arrowBack.keyName,
                      onTap: () {},
                    ),
              heightBox16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (isPasswordPage)
                    GestureDetector(
                      onTap: _finishSignUp,
                      child: Text(
                        'finished',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: LightThemeColors.blueColor,
                        ),
                      ),
                    )
                  else if (showConfirmButton)
                    GestureDetector(
                      onTap: _goToPasswordPage,
                      child: Text(
                        'continue',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: LightThemeColors.blueColor,
                        ),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        Get.to(const SignInScreen());
                      },
                      child: Text(
                        'sign in',
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
              Row(
                children: [
                  Expanded(
                    child: StraightLiner(
                      height: 3,
                      color: isPasswordPage ? Colors.grey : Colors.white,
                    ),
                  ),
                  widthBox10,
                  Expanded(
                    child: StraightLiner(
                      height: 3,
                      color: isPasswordPage ? Colors.white : Colors.grey,
                    ),
                  ),
                ],
              ),
              heightBox30,
              Form(
                key: _formKey,
                child: isPasswordPage
                    ? PasswordSection(
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                      )
                    : InformationSection(
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                      ),
              ),
              heightBox100,
              FooterSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class InformationSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const InformationSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter first name';
            }
            return null;
          },
        ),
        heightBox12,
        Label(label: 'Last Name'),
        heightBox10,
        CustomTextField(
          controller: lastNameController,
          hintText: 'Enter last name',
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter last name';
            }
            return null;
          },
        ),
        heightBox12,
        Label(label: 'Email'),
        heightBox10,
        CustomTextField(
          controller: emailController,
          hintText: 'email@gmail.com',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        heightBox12,
        Label(label: 'Phone Number'),
        heightBox10,
        CustomTextField(
          controller: phoneController,
          hintText: 'Enter phone number',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter phone number';
            }
            return null;
          },
        ),
      ],
    );
  }
}

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
      ],
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Sign Up With",
              style: TextStyle(color: const Color(0xff8C8C8C), fontSize: 16.sp),
            ),
            heightBox10,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CrashSafeImage(Assets.images.gmail.keyName, height: 30.h),
                widthBox14,
                CrashSafeImage(Assets.images.facebook.keyName, height: 30.h),
              ],
            ),
          ],
        ),
        heightBox16,
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
      ],
    );
  }
}
