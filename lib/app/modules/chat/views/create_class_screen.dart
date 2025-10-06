import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/chat/views/create_class_buttom_sheet.dart';
import 'package:wisper/app/modules/chat/widgets/add_icon_widget.dart';
import 'package:wisper/app/modules/chat/widgets/contact_widget.dart';
import 'package:wisper/app/modules/chat/widgets/create_header.dart';
import 'package:wisper/app/modules/chat/widgets/member_widget.dart';
import 'package:wisper/gen/assets.gen.dart';

class CreateClassScreen extends StatefulWidget {
  const CreateClassScreen({super.key});

  @override
  State<CreateClassScreen> createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends State<CreateClassScreen> {
  List<Widget> contactList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heightBox40,
            CreateHeader(
              bgColor: const Color(0xff102B19),
              iconColor: const Color(0xff11AE46),
              title: 'Create Class',
              imagePath: Assets.images.education.keyName,
              onTap: () {
                _showCreateClass();
              },
              trailinlgText: 'Next',
            ),
            heightBox16,
            const StraightLiner(height: 0.5),
            heightBox10,
            Text(
              'Add Members',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            heightBox12,
            SizedBox(height: 40, child: CustomTextField(hintText: 'Search')),
            heightBox10,
            contactList.isNotEmpty
                ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xff2A2D33),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: MemberWidget(
                                    imagePath: Assets.images.image.keyName,
                                    name: 'Aminul Islam',
                                    onTap: () {
                                      setState(() {
                                        contactList.removeAt(index);
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            heightBox10,
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: ContactWidget(
                      trailing: AddIconWidget(
                        onTap: () {
                          setState(() {
                            contactList.add(
                              MemberWidget(
                                imagePath: Assets.images.image.keyName,
                                name: 'Aminul Islam',
                                onTap: () {
                                  setState(() {
                                    contactList.removeAt(index);
                                  });
                                },
                              ),
                            );
                          });
                        },
                      ),
                      imagePath: Assets.images.image.keyName,
                      title: 'Aminul Islam',
                      subtitle: 'Flutter Developer',
                      onTap: () {},
                    ),
                  );
                },
                itemCount: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateClass() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow dynamic height
      builder: (BuildContext context) {
        return CreateClassButtomSheet(contactList: contactList);
      },
    );
  }
}
