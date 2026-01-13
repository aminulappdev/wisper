// Updated ChattingFieldWidget.dart (gap fully removed, no extra space even on scroll)
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/utils/file_picker.dart';
import 'package:wisper/app/core/utils/image_picker.dart';
import 'package:wisper/app/core/widgets/common/circle_icon.dart';
import 'package:wisper/app/modules/chat/controller/image_decode_controller.dart';
import 'package:wisper/app/modules/chat/views/person/attach_buttom.dart';
import 'package:wisper/gen/assets.gen.dart';

class ChattingFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final RxBool isSendEnabled;

  const ChattingFieldWidget({
    super.key,
    required this.controller,
    required this.isSendEnabled,
  });

  @override
  State<ChattingFieldWidget> createState() => _ChattingFieldWidgetState();
}

class _ChattingFieldWidgetState extends State<ChattingFieldWidget> {
  final FileDecodeController fileDecodeController =
      Get.find<FileDecodeController>();

  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();
  final AttachmentPickerHelper _attachmentPickerHelper =
      AttachmentPickerHelper();

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    widget.controller.addListener(_updateSendButton);
    ever(fileDecodeController.imageUrlRx, (_) => _updateSendButton());
  }

  void _updateSendButton() {
    widget.isSendEnabled.value =
        widget.controller.text.trim().isNotEmpty ||
        fileDecodeController.imageUrl.isNotEmpty;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateSendButton);
    _focusNode.dispose();
    super.dispose();
  }

  void _onImagePicked(File image) async {
    await fileDecodeController.imageDecode(image: image);
  }

  void _onVideoPicked(File video) async {
    await fileDecodeController.videoDecode(image: video);
  }

  void _onDocumentsPicked(List<File> documents) async {
    if (documents.isEmpty) return;
    await fileDecodeController.fileDecode(image: documents.first);
  }

  void _clearAllAttachments() {
    fileDecodeController.clearAll();
    _updateSendButton();
  }

  void _showAttachmentBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AttachmentBottomSheet(
        onImageSelected: () =>
            _imagePickerHelper.showAlertDialog(context, _onImagePicked),
        onVideoSelected: () =>
            _attachmentPickerHelper.pickVideo(context, _onVideoPicked),
        onFileSelected: () =>
            _attachmentPickerHelper.pickDocument(context, _onDocumentsPicked),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Plus button
        CircleIconWidget(
          imagePath: Assets.images.plus.keyName,
          radius: 18,
          iconRadius: 15,
          onTap: _showAttachmentBottomSheet,
        ),
        const SizedBox(width: 8),

        // Input + preview (stacked tightly)
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Text input (always at bottom)
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Type here...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      filled: true,
                      fillColor: Colors.grey.shade800,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),

              // Attachment preview (positioned above input, only if exists)
              Positioned(
                left: 0,
                bottom: MediaQuery.of(context).size.height * 0.06 - 4, // Overlap slightly to avoid gap
                child: Obx(() {
                  if (fileDecodeController.inProgress) {
                    return Container(
                      height: 90,
                      width: 90,
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade800,
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (fileDecodeController.imageUrl.isNotEmpty) {
                    String fileType;
                    if (fileDecodeController.imageUrl.contains('mp4')) {
                      fileType = 'video';
                    } else if (fileDecodeController.imageUrl.contains('pdf')) {
                      fileType = 'doc';
                    } else {
                      fileType = 'image';
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Stack(
                          children: [
                            Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: fileType == 'image'
                                    ? DecorationImage(
                                        image: NetworkImage(
                                          fileDecodeController.imageUrl,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: fileType == 'video'
                                  ? const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        child: Icon(Icons.play_arrow,
                                            color: Colors.white, size: 40),
                                      ),
                                    )
                                  : fileType == 'doc'
                                      ? const Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            child: Icon(Icons.picture_as_pdf),
                                          ),
                                        )
                                      : null,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: CircleIconWidget(
                                imagePath: Assets.images.cross.keyName,
                                radius: 14,
                                iconRadius: 13,
                                onTap: _clearAllAttachments,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}