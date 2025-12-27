import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/Get.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/utils/file_picker.dart';
import 'package:wisper/app/core/utils/image_picker.dart';

import 'package:wisper/app/modules/chat/controller/image_decode_controller.dart';
import 'package:wisper/app/modules/chat/views/person/attach_buttom.dart';

class ChattingFieldWidget extends StatefulWidget {
  final TextEditingController controller;

  const ChattingFieldWidget({super.key, required this.controller});

  @override
  State<ChattingFieldWidget> createState() => _ChattingFieldWidgetState();
}

class _ChattingFieldWidgetState extends State<ChattingFieldWidget> {
  final FileDecodeController fileDecodeController =
      Get.find<FileDecodeController>();

  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();
  final AttachmentPickerHelper _attachmentPickerHelper =
      AttachmentPickerHelper();

  File? _selectedFile; // একবারে একটা ফাইল

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onImagePicked(File image) async {
    setState(() => _selectedFile = image);
    await fileDecodeController.imageDecode(image: image);
  }

  void _onVideoPicked(File video) async {
    setState(() => _selectedFile = video);
    await fileDecodeController.videoDecode(image: video);
  }

  void _onDocumentsPicked(List<File> documents) async {
    if (documents.isEmpty) return;
    setState(() => _selectedFile = documents.first);
    await fileDecodeController.fileDecode(image: documents.first);
  }

  void _clearAllAttachments() {
    setState(() => _selectedFile = null);
    fileDecodeController.clearAll();
  }

  void _showAttachmentBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AttachmentBottomSheet(
        onImageSelected: () {
          _imagePickerHelper.showAlertDialog(context, _onImagePicked);
        },
        onVideoSelected: () {
          _attachmentPickerHelper.pickVideo(context, _onVideoPicked);
        },
        onFileSelected: () {
          _attachmentPickerHelper.pickDocument(context, _onDocumentsPicked);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() {
          if (fileDecodeController.inProgress) {
            return Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
              child: Container(
                height: 100.h,
                width: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
            );
          }

          if (fileDecodeController.imageUrl.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
              child: Stack(
                children: [
                  Container(
                    height: 100.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      image: DecorationImage(
                        image: NetworkImage(fileDecodeController.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: _clearAllAttachments,
                      padding: EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        }),

        heightBox8,

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            minLines: 1,
            maxLines: 5,
            decoration: InputDecoration(
              prefixIcon: InkWell(
                onTap: fileDecodeController.inProgress
                    ? null
                    : _showAttachmentBottomSheet,
                child: Icon(
                  Icons.attach_file,
                  color: fileDecodeController.inProgress
                      ? Colors.grey.shade800
                      : Colors.grey.shade600,
                ),
              ),
              hintText: 'Type here...',
              hintStyle: TextStyle(color: Colors.grey.shade600),
              filled: true,
              fillColor: Colors.black,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 15.h,
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
