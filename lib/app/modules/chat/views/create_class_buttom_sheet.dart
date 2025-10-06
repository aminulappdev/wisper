import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/label.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/chat/widgets/create_header.dart';
import 'package:wisper/app/modules/chat/widgets/member_widget.dart';
import 'package:wisper/app/modules/chat/widgets/toggle_option.dart';
import 'package:wisper/gen/assets.gen.dart';

class CreateClassButtomSheet extends StatelessWidget {
  const CreateClassButtomSheet({super.key, required this.contactList});

  final List<Widget> contactList;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.of(context).size.height *
            0.9, // Max 90% of screen height
      ),
      child: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CreateHeader(
                  bgColor: const Color(0xff102B19),
                  iconColor: const Color(0xff11AE46),
                  title: 'Create Class',
                  imagePath: Assets.images.education.keyName,
                  onTap: () {
                    // Handle class creation logic here
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  trailinlgText: 'Create',
                ),
                heightBox10,
                const StraightLiner(height: 0.5),
                heightBox10,
                const Label(label: 'Class Name'),
                heightBox10,
                CustomTextField(
                  hintText: 'Enter class name',
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter class name';
                    }
                    return null;
                  },
                ),
                heightBox10,
                const Label(label: 'Description'),
                heightBox10,
                CustomTextField(
                  hintText: 'Write description',
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                heightBox16,
                ToggleOption(
                  title: 'Private Group',
                  subtitle: 'Only invited members can join',
                  onToggle: (bool value) {},
                ),
                heightBox10,
                ToggleOption(
                  title: 'Allow Member Invites',
                  subtitle: 'Let members invite others',
                  onToggle: (bool value) {},
                ),
                heightBox10,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Members (${contactList.length})',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    heightBox10,
                    SizedBox(
                      height: 36,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        scrollDirection: Axis.horizontal,
                        itemCount: contactList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: MemberWidget(
                              imagePath: Assets.images.image.keyName,
                              name: 'Aminul Islam',
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}