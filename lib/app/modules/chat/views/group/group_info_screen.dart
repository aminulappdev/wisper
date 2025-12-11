import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/chat/controller/all_connection_controller.dart';
import 'package:wisper/app/modules/chat/controller/all_group_member_controller.dart';
import 'package:wisper/app/modules/chat/controller/group_info_controller.dart';
import 'package:wisper/app/modules/chat/views/doc_info.dart';
import 'package:wisper/app/modules/chat/views/link_info.dart';
import 'package:wisper/app/modules/chat/views/media_info.dart';
import 'package:wisper/app/modules/chat/widgets/location_info.dart';
import 'package:wisper/app/modules/chat/widgets/select_option_widget.dart';
import 'package:wisper/app/modules/profile/widget/info_card.dart';
import 'package:wisper/gen/assets.gen.dart';

class GroupInfoScreen extends StatefulWidget {
  const GroupInfoScreen({super.key, this.groupId});
  final String? groupId;

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  final GroupInfoController groupInfoController = Get.put(
    GroupInfoController(),
  );

  final GroupMembersController groupMembersController =
      Get.find<GroupMembersController>();

  final AllConnectionController allConnectionController =
      Get.find<AllConnectionController>();

  @override
  void initState() {
    groupInfoController.getGroupInfo(widget.groupId);
    groupMembersController.getGroupMembers(widget.groupId);
    allConnectionController.getAllConnection('ACCEPTED');
    super.initState();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (groupInfoController.inProgress) {
          return const Center(child: CircularProgressIndicator());
        } else {
          DateFormatter dateFormatter = DateFormatter(
            groupInfoController.groupInfoData!.createdAt!,
          );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                heightBox30,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleIconWidget(
                      color: const Color(0xff353434),
                      iconColor: const Color.fromARGB(255, 255, 255, 255),
                      iconRadius: 15,
                      radius: 14,
                      imagePath: Assets.images.arrowBack.keyName,
                      onTap: () => Navigator.pop(context),
                    ),
                    Text(
                      'Group Info',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 35.h, width: 35.h),
                  ],
                ),
                heightBox10,
                InfoCard(
                  imagePath: Assets.images.userGroup.keyName,
                  editOnTap: () {},
                  showMember: _showMemberInfo,
                  title: groupInfoController.groupInfoData?.name ?? '',
                  memberInfo: 'Group • 3 members',

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 31.h,
                        width: 116.w,
                        child: CustomElevatedButton(
                          textSize: 12,
                          title: 'Share Profile',
                          onPress: () {},
                          borderRadius: 50,
                        ),
                      ),
                      widthBox10,
                      SizedBox(
                        height: 31.h,
                        width: 116.w,
                        child: CustomElevatedButton(
                          textSize: 12,
                          title: 'Add Members',
                          onPress: _showConnectionInfo,
                          borderRadius: 50,
                        ),
                      ),
                    ],
                  ),
                ),
                heightBox20,
                LocationInfo(date: dateFormatter.getFullDateFormat()),
                heightBox20,
                StraightLiner(height: 0.4, color: const Color(0xff454545)),
                heightBox10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                      child: SelectOptionWidget(
                        currentIndex: 0,
                        selectedIndex: selectedIndex,
                        title: 'Media',
                        lineColor: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    widthBox50,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                      child: SelectOptionWidget(
                        currentIndex: 1,
                        selectedIndex: selectedIndex,
                        title: 'Links',
                        lineColor: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    widthBox50,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 2;
                        });
                      },
                      child: SelectOptionWidget(
                        currentIndex: 2,
                        selectedIndex: selectedIndex,
                        title: 'Docs',
                        lineColor: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
                const StraightLiner(height: 0.4, color: Color(0xff454545)),
                heightBox10,

                if (selectedIndex == 0) const MediaInfo(),
                if (selectedIndex == 1) const LinkInfo(),
                if (selectedIndex == 2)
                  DocInfo(
                    title: 'job_description.pdf',
                    isDownloaded: false,
                    onTap: () {},
                  ),
              ],
            ),
          );
        }
      }),
    );
  }

  void _showMemberInfo() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          height: 240.h,
          child: Obx(() {
            if (groupInfoController.inProgress) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: groupMembersController.groupMemnersData!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 20,
                    ),
                    child: Row(
                      children: [
                        widthBox10,
                        CircleAvatar(
                          radius: 18.r,
                          backgroundImage: AssetImage(
                            Assets.images.image.keyName,
                          ),
                        ),
                        widthBox10,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              groupMembersController
                                      .groupMemnersData![index]
                                      .auth!
                                      .person
                                      ?.name ??
                                  '',
                            ),
                            heightBox4,
                            Text(
                              groupMembersController
                                          .groupMemnersData![index]
                                          .role ==
                                      'ADMIN'
                                  ? 'Admin'
                                  : 'Member',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }),
        );
      },
    );
  }

  void _showConnectionInfo() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          height: 240.h,
          child: Obx(() {
            if (allConnectionController.inProgress) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: allConnectionController.allConnectionData!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18.r,
                              backgroundImage: AssetImage(
                                Assets.images.image.keyName,
                              ),
                            ),
                            widthBox10,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  allConnectionController
                                          .allConnectionData![index]
                                          .partner!
                                          .person
                                          ?.name ??
                                      '',
                                ),
                                heightBox4,
                                Text(
                                  allConnectionController
                                          .allConnectionData![index]
                                          .partner!
                                          .person
                                          ?.title ??
                                      '',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 100.w,
                          height: 30.h,
                          child: CustomElevatedButton(
                            title: 'Add Member',
                            textSize: 10.sp,
                            onPress: () {},
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }),
        );
      },
    );
  }
}
