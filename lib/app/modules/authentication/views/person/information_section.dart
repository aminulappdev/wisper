// information_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/others/custom_size.dart';
import 'package:wisper/app/core/utils/validator_service.dart';
import 'package:wisper/app/core/widgets/common/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/common/label.dart';

class InformationSection extends StatefulWidget {
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
  State<InformationSection> createState() => _InformationSectionState();
}

class _InformationSectionState extends State<InformationSection> {
  // তোমার EditProfile-এর মতোই একই লিস্ট
  final List<String> _jobTitles = [
    'Flutter Developer',
    'Graphic Designer',
    'UI/UX Designer',
    'Backend Developer',
    'Frontend Developer',
    'Full Stack Developer',
    'Product Manager',
    'Project Manager',
    'Data Scientist',
    'DevOps Engineer',
    'QA Engineer',
    'Mobile Developer',
    'Other',
  ];

  String? _selectedTitle;

  @override
  void initState() {
    super.initState();
    _selectedTitle = widget.titleController.text.isNotEmpty
        ? widget.titleController.text
        : null;

    if (_selectedTitle == null || !_jobTitles.contains(_selectedTitle)) {
      _selectedTitle = _jobTitles.first;
    }
    widget.titleController.text = _selectedTitle!;
  }

  void _showJobTitleBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => Container(
         color: Colors.black,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              heightBox20,
              Text(
                'Select Job Title',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: LightThemeColors.blueColor),
              ),
              heightBox10,
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _jobTitles.length,
                  itemBuilder: (context, index) {
                    final title = _jobTitles[index];
                    return ListTile(
                      title: Text(title, style: TextStyle(color: Colors.white),),
                      trailing: _selectedTitle == title
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context).primaryColor,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedTitle = title;
                          widget.titleController.text = title; // কন্ট্রোলার আপডেট
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label(label: 'First Name'), 
        heightBox10,
        CustomTextField(
          controller: widget.firstNameController,
          hintText: 'Enter first name',
          keyboardType: TextInputType.name,
          validator: ValidatorService.validateSimpleField,
        ),
        heightBox12,

        const Label(label: 'Last Name'),
        heightBox10,
        CustomTextField(
          controller: widget.lastNameController,
          hintText: 'Enter last name',
          keyboardType: TextInputType.name,
          validator: ValidatorService.validateSimpleField,
        ),
        heightBox12,

        const Label(label: 'Email'),
        heightBox10,
        CustomTextField(
          controller: widget.emailController,
          hintText: 'email@gmail.com',
          keyboardType: TextInputType.emailAddress,
          validator: (_) => ValidatorService.validateEmailAddress(
            widget.emailController.text,
          ),
        ),
        heightBox12,

        const Label(label: 'Phone Number'),
        heightBox10,
        CustomTextField(
          controller: widget.phoneController,
          hintText: 'Enter phone number',
          keyboardType: TextInputType.phone,
          validator: ValidatorService.validateSimpleField,
        ),
        heightBox12,

        const Label(label: 'Job Title'), // আগে ছিল Job Type
        heightBox10,
        CustomTextField(
          controller: widget.titleController,
          readOnly: true, // টাইপ করা যাবে না
          hintText: 'Select your designation',
          suffixIcon: Icons.keyboard_arrow_down_rounded,
          onTap: _showJobTitleBottomSheet,
          validator: (_) {
            if (_selectedTitle == null || _selectedTitle!.isEmpty) {
              return 'Please select a job title';
            }
            return null;
          },
        ),
      ],
    );
  }
}
