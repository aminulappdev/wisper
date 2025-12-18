import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisper/app/modules/homepage/controller/all_role_controller.dart';
import 'package:wisper/app/modules/homepage/widget/role_card.dart';

class RoleSection extends StatefulWidget {
  const RoleSection({super.key});

  @override
  State<RoleSection> createState() => _RoleSectionState();
}

class _RoleSectionState extends State<RoleSection> {
  final AllRoleController allRoleController = Get.find<AllRoleController>();

  @override
  void initState() {
    allRoleController.getAllRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        if (allRoleController.inProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (allRoleController.allRoleData!.isEmpty) {
          return const Center(
            child: Text('No role found', style: TextStyle(fontSize: 12)),
          );
        } else {
          var data = allRoleController.allRoleData;
          return ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RoleCard(
                  title: data[index].person?.name ?? 'N/A',
                  post: data[index].count?.posts ?? 0,
                  recommendations:
                      data[index].count?.receivedRecommendations ?? 0,
                  messagesOnTap: () {},
                  addOnTap: () {},
                  role: data[index].person?.title ?? 'N/A',
                  id: data[index].id ?? 'N/A',
                ),
              );
            },
          );
        }
      }),
    );
  }
}
