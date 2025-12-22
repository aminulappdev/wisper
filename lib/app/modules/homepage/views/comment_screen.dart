import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/modules/homepage/controller/comment_controller.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final CommentController commentController = Get.put(CommentController());
  final TextEditingController commentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    commentController.getAllComment(widget.postId);
  }

  void comment() {
    showLoadingOverLay(
      asyncFunction: () async => await performComment(context),
      msg: 'Please wait...',
    );
  }

  Future<void> performComment(BuildContext context) async {
    final bool isSuccess = await commentController.addComment(
      widget.postId,
      commentCtrl.text,
    );

    if (isSuccess) {
      commentController.getAllComment(widget.postId);
      commentCtrl.clear(); 
    } else {
      showSnackBarMessage(context, commentController.errorMessage, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Comments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            /// ✅ COMMENT LIST
            Expanded(
              child: Obx(() {
                if (commentController.inProgress) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (commentController.commentData == null ||
                    commentController.commentData!.isEmpty) {
                  return const Center(child: Text('No comment found'));
                }

                return ListView.builder(
                  itemCount: commentController.commentData!.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final comment = commentController.commentData![index];
                    return SizedBox(
                      height: 70.h,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            comment.author?.person?.image ?? '',
                          ),
                          radius: 20.r,
                        ),
                        title: Text(
                          comment.author?.person?.name ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          comment.text ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            /// ✅ COMMENT INPUT
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: commentCtrl,
                    hintText: 'Comment',
                  ),
                ),
                widthBox8,
                GestureDetector(
                  onTap: comment,
                  child: CircleAvatar(
                    radius: 28.r,
                    backgroundColor: const Color(0xff121212),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
