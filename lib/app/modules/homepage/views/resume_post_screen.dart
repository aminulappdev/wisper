import 'dart:io';
import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/details_card.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/gen/assets.gen.dart';
import 'package:file_picker/file_picker.dart';

class ResumePostScreen extends StatefulWidget {
  const ResumePostScreen({super.key});

  @override
  State<ResumePostScreen> createState() => _ResumePostScreenState();
}

class _ResumePostScreenState extends State<ResumePostScreen> {
  final List<File> _selectedFiles = [];
  final FilePickerHelper _filePickerHelper = FilePickerHelper();

  void _addFile(File file) {
    setState(() {
      _selectedFiles.add(file);
    });
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightBox40,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Text(
                      'Resume',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                      width: 66,
                      child: CustomElevatedButton(
                        title: 'Post',
                        textSize: 12,
                        borderRadius: 50,
                        onPress: () {},
                      ),
                    ),
                  ],
                ),
                heightBox16,
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      backgroundImage: AssetImage(Assets.images.image.keyName),
                    ),
                    widthBox8,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aminul Islam',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Flutter Developer',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: LightThemeColors.themeGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                heightBox20,
                SizedBox(
                  height: 150.h,
                  child: CustomTextField(
                    maxLines: 5,
                    hintText: 'Share your thoughts',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xff8C8C8C),
                    ),
                  ),
                ),
                heightBox10,
                StraightLiner(height: 0.5),
                heightBox10,
                GestureDetector(
                  onTap: () {
                    _filePickerHelper.showAlertDialog(context, _addFile);
                  },
                  child: Row(
                    children: [
                      CrashSafeImage(
                        Assets.images.gallery02.keyName,
                        height: 24.h,
                      ),
                      widthBox10,
                      Text(
                        'Add Resume',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: LightThemeColors.blueColor,
                        ),
                      ),
                    ],
                  ),
                ),
                heightBox10,
                if (_selectedFiles.isNotEmpty)
                  ListView.separated(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _selectedFiles.length,
                    separatorBuilder: (context, index) => heightBox10,
                    itemBuilder: (context, index) {
                      return DetailsCard(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    CrashSafeImage(
                                      Assets.images.pdf.keyName,
                                      height: 20.h,
                                    ),
                                    widthBox10,
                                    Text(
                                      _selectedFiles[index].path.split('/').last,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _removeFile(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FilePickerHelper {
  // Function to pick files from the device
  Future<void> pickFiles(
    BuildContext context,
    Function(File) onFilePicked,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf'], // Restrict to PDF files
      );
      if (result != null && result.files.isNotEmpty) {
        for (var file in result.files) {
          if (file.path != null) {
            onFilePicked(File(file.path!));
          }
        }
      }
      if (Navigator.canPop(context)) Navigator.pop(context);
    } catch (e) {
      debugPrint("Error picking files: $e");
      if (Navigator.canPop(context)) Navigator.pop(context);
    }
  }

  // Function to show the file picker dialog
  Future<void> showAlertDialog(
    BuildContext context,
    Function(File) onFilePicked,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SizedBox(
            height: 100.h,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      pickFiles(context, onFilePicked);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.description, size: 30.sp),
                        SizedBox(width: 10),
                        Text(
                          'Choose Resume',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  heightBox12,
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: const Color.fromARGB(255, 77, 76, 76),
                  ),
                  heightBox12,
                  InkWell(
                    onTap: () {
                      if (Navigator.canPop(context)) Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}