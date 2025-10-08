import 'dart:io';
import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/image_picker.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/gen/assets.gen.dart';

class GalleryPostScreen extends StatefulWidget {
  const GalleryPostScreen({super.key});

  @override
  State<GalleryPostScreen> createState() => _GalleryPostScreenState();
}

class _GalleryPostScreenState extends State<GalleryPostScreen> {
  final List<File> _selectedImages = [];
  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();

  void _addImage(File image) {
    setState(() {
      _selectedImages.add(image);
    });
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
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
                      'Media',
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
                    _imagePickerHelper.showAlertDialog(context, _addImage);
                  },
                  child: Row(
                    children: [
                      CrashSafeImage(
                        Assets.images.gallery02.keyName,
                        height: 24.h,
                      ),
                      widthBox10,
                      Text(
                        'Add Gallery',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: LightThemeColors.blueColor,
                        ),
                      ),
                    ],
                  ),
                ),
                heightBox20,
                if (_selectedImages.isNotEmpty)
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: List.generate(_selectedImages.length, (index) {
                      return Stack(
                        children: [
                          Container(
                            height: 100.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              image: DecorationImage(
                                image: FileImage(_selectedImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
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
                          ),
                        ],
                      );
                    }),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
