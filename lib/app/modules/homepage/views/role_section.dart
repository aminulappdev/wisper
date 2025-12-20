import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/modules/homepage/controller/add_request_controller.dart';
import 'package:wisper/app/modules/homepage/controller/all_role_controller.dart';
import 'package:wisper/app/modules/homepage/widget/role_card.dart';

class RoleSection extends StatefulWidget {
  const RoleSection({super.key, this.searchQuery});
  final String? searchQuery;

  @override
  State<RoleSection> createState() => _RoleSectionState();
}

class _RoleSectionState extends State<RoleSection> {
  final AllRoleController allRoleController = Get.find<AllRoleController>();
  final AddRequestController addRequestController = Get.put(
    AddRequestController(),
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      allRoleController.getAllRole(widget.searchQuery);
    });

    super.initState();
  }

  void addRequest(String? receiverId) {
    showLoadingOverLay(
      asyncFunction: () async => await performAddRequest(context, receiverId),
      msg: 'Please wait...',
    );
  }

  Future<void> performAddRequest(
    BuildContext context,
    String? receiverId,
  ) async {
    final bool isSuccess = await addRequestController.addRequest(
      receiverId: receiverId,
    );

    if (isSuccess) {
      showSnackBarMessage(context, 'Request sent successfully', false);
    } else {
      showSnackBarMessage(context, addRequestController.errorMessage, true);
    }
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
                  addOnTap: () {
                    addRequest(data[index].id);
                  },
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
