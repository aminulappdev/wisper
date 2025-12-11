import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/utils/validator_service.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/label.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/chat/controller/all_connection_controller.dart';
import 'package:wisper/app/modules/chat/controller/create_class_controller.dart';
import 'package:wisper/app/modules/chat/views/group/group_message_screen.dart';
import 'package:wisper/app/modules/chat/widgets/create_header.dart';
import 'package:wisper/app/modules/chat/widgets/toggle_option.dart';
import 'package:wisper/gen/assets.gen.dart';

class CreateClassButtomSheet extends StatefulWidget {
  final List<String> selectedMemberIds;

  const CreateClassButtomSheet({super.key, required this.selectedMemberIds});

  @override
  State<CreateClassButtomSheet> createState() => _CreateClassButtomSheetState();
}

class _CreateClassButtomSheetState extends State<CreateClassButtomSheet> {
  final CreateClassController createClassController = Get.put(
    CreateClassController(),
  );

  final TextEditingController _classNameC = TextEditingController();
  final TextEditingController _classDescriptionC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxBool _isPrivate = false.obs;
  final RxBool _allowInvitation = true.obs;

  final AllConnectionController allConnectionController =
      Get.find<AllConnectionController>();

  @override
  void dispose() {
    _classNameC.dispose();
    _classDescriptionC.dispose();
    super.dispose();
  }

  void createClass() {
    if (_classNameC.text.trim().isEmpty) {
      showSnackBarMessage(context, 'Please enter class name', true);
      return;
    }

    showLoadingOverLay(
      asyncFunction: () async => await performCreateClass(),
      msg: 'Please wait...',
    );
  }

  Future<void> performCreateClass() async {
    final bool isSuccess = await createClassController.createGroup(
      name: _classNameC.text.trim(),
      description: _classDescriptionC.text.trim(),
      members: widget.selectedMemberIds,
      isPrivate: _isPrivate.value,
      allowInvitation: _allowInvitation.value,
    );

    if (isSuccess && mounted) {
      Get.off(() => const GroupChatScreen());
    } else if (mounted) {
      showSnackBarMessage(context, createClassController.errorMessage, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
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
                      if (formKey.currentState!.validate()) {
                        createClass();
                      }
                    },
                    trailinlgText: 'Create',
                  ),
                  heightBox10,
                  const StraightLiner(height: 0.5),
                  heightBox10,
                  const Label(label: 'Class Name'),
                  heightBox10,
                  CustomTextField(
                    controller: _classNameC,
                    hintText: 'Enter class name',
                    keyboardType: TextInputType.name,
                    validator: ValidatorService.validateSimpleField,
                  ),
                  heightBox10,
                  const Label(label: 'Description'),
                  heightBox10,
                  CustomTextField(
                    controller: _classDescriptionC,
                    hintText: 'Write description',
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    validator: ValidatorService.validateSimpleField,
                  ),
                  heightBox16,
                  ToggleOption(
                    title: 'Private Class',
                    subtitle: 'Only invited members can join',
                    onToggle: (bool value) {
                      _isPrivate.value = value;
                    },
                  ),
                  heightBox10,
                  ToggleOption(
                    title: 'Allow Member Invites',
                    subtitle: 'Let members invite others',
                    onToggle: (bool value) {
                      _allowInvitation.value = value;
                    },
                  ),
                  heightBox10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Members (${widget.selectedMemberIds.length})',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
