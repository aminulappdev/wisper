// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wisper/app/core/others/custom_size.dart';
class ImagePickerHelper {
  Future<void> pickImagesFromGallery(
    BuildContext context,
    Function(File) onImagePicked,
  ) async {
    try {
      final pickedImages = await ImagePicker().pickMultiImage();
      if (pickedImages.isNotEmpty) {
        for (var pickedImage in pickedImages) {
          onImagePicked(File(pickedImage.path));
        }
      }
      if (Navigator.canPop(context)) Navigator.pop(context); // Close dialog after selection
    } catch (e) {
      debugPrint("Error picking images: $e");
      if (Navigator.canPop(context)) Navigator.pop(context); // Close dialog on error
    }
  }

  Future<void> pickImageFromCamera(
    BuildContext context,
    Function(File) onImagePicked,
  ) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (pickedImage != null) {
        onImagePicked(File(pickedImage.path));
      }
      if (Navigator.canPop(context)) Navigator.pop(context); // Close dialog after selection
    } catch (e) {
      debugPrint("Error picking image: $e");
      if (Navigator.canPop(context)) Navigator.pop(context); // Close dialog on error
    }
  }

  Future<void> showAlertDialog(
    BuildContext context,
    Function(File) onImagePicked,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SizedBox(
            height: 150.h,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      pickImageFromCamera(context, onImagePicked);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt, size: 30.sp),
                        SizedBox(width: 10),
                        Text(
                          'Take a Photo',
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
                  InkWell(
                    onTap: () {
                      pickImagesFromGallery(context, onImagePicked);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image, size: 30.sp),
                        SizedBox(width: 10),
                        Text(
                          'Choose from Gallery',
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