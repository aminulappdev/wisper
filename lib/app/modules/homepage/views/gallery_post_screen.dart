// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/utils/validator_service.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_dialoge.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/image_picker.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/homepage/controller/create_post_controller.dart';
import 'package:wisper/app/modules/homepage/controller/feed_post_controller.dart';
import 'package:wisper/gen/assets.gen.dart';

class GalleryPostScreen extends StatefulWidget {
  const GalleryPostScreen({super.key});

  @override
  State<GalleryPostScreen> createState() => _GalleryPostScreenState();
}

class _GalleryPostScreenState extends State<GalleryPostScreen> {
  final TextEditingController _captionCtrl = TextEditingController();
  final CreatePostController createPostController = CreatePostController();
  final formKey = GlobalKey<FormState>();
  final List<File> _selectedImages = [];
  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();

  // Privacy state
  String _selectedPrivacy = 'Everyone'; // Default

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

  void createPost() {
    showLoadingOverLay(
      asyncFunction: () async => await performCreatePost(context),
      msg: 'Please wait...',
    );
  }

  Future<void> performCreatePost(BuildContext context) async {
    final bool isSuccess = await createPostController.createPost(
      description: _captionCtrl.text.trim(),
      images: _selectedImages,
      privacy: _selectedPrivacy,
    );

    if (isSuccess) {
      final AllFeedPostController allFeedPostController =
          Get.find<AllFeedPostController>();
      await allFeedPostController.getAllPost();
      Navigator.pop(context);
      showSnackBarMessage(context, "Post created successfully!", false);
    } else {
      showSnackBarMessage(context, createPostController.errorMessage, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // তোমার অ্যাপের ডার্ক থিম
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heightBox40,

                  // Header: Cancel - Media - Post
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Media',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 32.h,
                        width: 66.w,
                        child: CustomElevatedButton(
                          title: 'Post',
                          textSize: 12,
                          borderRadius: 50,
                          onPress: () {
                            if (formKey.currentState!.validate()) {
                              createPost();
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  heightBox16,

                  // User info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18.r,
                        backgroundImage: AssetImage(
                          Assets.images.image.keyName,
                        ),
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
                              color: LightThemeColors.themeGreyColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  heightBox20,

                  // Caption field
                  SizedBox(
                    height: 150.h,
                    child: CustomTextField(
                      controller: _captionCtrl,
                      maxLines: 5,
                      hintText: 'Share your thoughts',
                      validator: ValidatorService.validateSimpleField,
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xff8C8C8C),
                      ),
                    ),
                  ),

                  heightBox10,
                  StraightLiner(height: 0.5),
                  heightBox10,

                  // Privacy Selector (Everyone can view)
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.r),
                          ),
                        ),
                        builder: (ctx) => _privacyBottomSheet(),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.public,
                          color: LightThemeColors.blueColor,
                          size: 24.sp,
                        ),
                        widthBox10,
                        Text(
                          _selectedPrivacy == 'Everyone'
                              ? 'Everyone can view'
                              : 'Only me',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: LightThemeColors.blueColor,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: LightThemeColors.blueColor,
                        ),
                      ],
                    ),
                  ),

                  heightBox20,

                  // Add Gallery
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

                  // Selected images preview
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
                                  decoration: const BoxDecoration(
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

                  heightBox100, // যাতে কীবোর্ড উঠলে বাটন ঢাকা না পড়ে
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Privacy Bottom Sheet – White background + Grey handle
  Widget _privacyBottomSheet() {
    final List<Map<String, dynamic>> privacyOptions = [
      {'title': 'Everyone can view', 'value': 'EVERYONE', 'icon': Icons.public},
      {'title': 'Only me', 'value': 'FOLLOWERS', 'icon': Icons.lock_outline},
    ];

    return SafeArea(
      child: Container(
        color: Colors.black,
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: const Color(0xff8C8C8C),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            heightBox20,
            Text(
              'Who can see this post?',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: LightThemeColors.blueColor,
              ),
            ),
            heightBox20,
            ...privacyOptions.map((option) {
              return ListTile(
                leading: Icon(
                  option['icon'],
                  color: LightThemeColors.blueColor,
                ),
                title: Text(
                  option['title'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: LightThemeColors.blueColor,
                  ),
                ),
                trailing: _selectedPrivacy == option['value']
                    ? Icon(Icons.check, color: LightThemeColors.blueColor)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedPrivacy = option['value'];
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
