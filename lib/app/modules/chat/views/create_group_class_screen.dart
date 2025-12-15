import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/chat/controller/all_connection_controller.dart';
import 'package:wisper/app/modules/chat/views/class/create_class_screen.dart';
import 'package:wisper/app/modules/chat/views/group/create_group_screen.dart';
import 'package:wisper/app/modules/chat/widgets/contact_widget.dart';
import 'package:wisper/app/modules/chat/widgets/create_widget.dart';
import 'package:wisper/gen/assets.gen.dart';

class CreateGroupClassScreen extends StatefulWidget {
  const CreateGroupClassScreen({super.key});

  @override
  State<CreateGroupClassScreen> createState() => _CreateGroupClassScreenState();
}

class _CreateGroupClassScreenState extends State<CreateGroupClassScreen> {
  final AllConnectionController allConnectionController =
      Get.find<AllConnectionController>();

  @override
  void initState() {
    allConnectionController.getAllConnection('ACCEPTED');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heightBox40,
            Align(
              alignment: Alignment.centerRight,
              child: CircleIconWidget(
                imagePath: Assets.images.cross.keyName,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            heightBox10,
            CreateWidget(
              ontap: () {
                Get.to(() => CreateGroupScreen());
              },
              imagePath: Assets.images.education.keyName,
              bgColor: Color(0xff102B19),
              iconColor: Color(0xff11AE46),
              title: 'Create New Group',
              subtitle: 'Start a group conversation',
            ),
            heightBox10,
            StraightLiner(height: 0.5),
            heightBox10,
            CreateWidget(
              ontap: () {
                Get.to(() => CreateClassScreen());
              },
              imagePath: Assets.images.userGroup.keyName,
              bgColor: Color(0xff1B1E25),
              iconColor: Color.fromARGB(255, 255, 255, 255),
              title: 'Create New Class',
              subtitle: 'Start a new educational class',
            ),
            heightBox30,

            Text(
              'Contacts on the Platform',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            heightBox12,
            SizedBox(height: 40, child: CustomTextField(hintText: 'Search')),
            heightBox10,
            Expanded(
              child: Obx(() {
                if (allConnectionController.inProgress) {
                  return const Center(child: CircularProgressIndicator());
                } else if (allConnectionController.allConnectionData!.isEmpty) {
                  return const Center(child: Text('No contacts found'));
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount:
                        allConnectionController.allConnectionData!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: ContactWidget(
                          imagePath: Assets.images.image.keyName,
                          title:
                              allConnectionController
                                  .allConnectionData![index]
                                  .partner!
                                  .person
                                  ?.name ??
                              '',
                          subtitle:
                              allConnectionController
                                  .allConnectionData![index]
                                  .partner!
                                  .person
                                  ?.title ??
                              '',
                          onTap: () {},
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
