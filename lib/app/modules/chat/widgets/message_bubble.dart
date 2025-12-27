import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/utils/video_player.dart';

class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMe;
  final String fileUrl; // imageUrl এর বদলে fileUrl
  final String fileType; // নতুন
  final String senderName;
  final String? senderImage;
  final String time;
  final bool isGroupChat;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.fileUrl,
    required this.fileType,
    required this.senderName, 
    this.senderImage,
    required this.time,
    this.isGroupChat = false,
  });

  // Helper: file name extract
  String _getFileName() {
    if (fileUrl.isEmpty) return '';
    return Uri.tryParse(fileUrl)?.pathSegments.last ?? 'file';
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 16.r,
              backgroundImage: senderImage != null && senderImage!.isNotEmpty
                  ? NetworkImage(senderImage!)
                  : null,
              child: senderImage == null || senderImage!.isEmpty
                  ? Text(
                      senderName.isNotEmpty ? senderName[0].toUpperCase() : '?',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          if (!isMe) widthBox8 else widthBox10,

          SizedBox(
            width: 270.w,
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isMe
                          ? [const Color(0xff2799EA), const Color(0xff2799EA)]
                          : [const Color(0xffF3F3F5), const Color(0xffF3F3F5)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: isMe
                          ? Radius.circular(16.r)
                          : Radius.circular(0),
                      bottomRight: isMe
                          ? Radius.circular(0)
                          : Radius.circular(16.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // File Attachment Handling
                      if (fileUrl.isNotEmpty) ...[
                        if (fileType == 'IMAGE')
                          GestureDetector(
                            onTap: () {
                              // Optional: full screen image viewer
                              // Get.to(() => FullScreenImage(url: fileUrl));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                fileUrl,
                                height: 200.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 200.h,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else if (fileType == 'VIDEO')
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                () => VideoPlayerScreen(videoUrl: fileUrl),
                              );
                            },
                            child: Container(
                              height: 200.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Optional: blurred preview if you have thumbnail
                                  // Otherwise just black background
                                  const Icon(
                                    Icons.play_circle_filled,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      child: Text(
                                        'Video',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else // Other files (pdf, doc, etc.)
                          GestureDetector(
                            onTap: () async {
                              if (await canLaunchUrl(Uri.parse(fileUrl))) {
                                await launchUrl(
                                  Uri.parse(fileUrl),
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.description,
                                    size: 26.r,
                                    color: isMe
                                        ? Colors.white
                                        : Colors.grey[700],
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      _getFileName(),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: isMe
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    Icons.download,
                                    size: 24.r,
                                    color: isMe ? Colors.white70 : Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(height: 8.h),
                      ],

                      // Text Message
                      if (message['text'].toString().isNotEmpty)
                        Text(
                          message['text'].toString(),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                    ],
                  ),
                ),

                // Time + seen tick
                Row(
                  mainAxisAlignment: isMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: isMe ? Colors.white70 : Colors.grey,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 8),
                      Icon(
                        message['seen'] == true
                            ? Icons.check_circle
                            : Icons.check,
                        size: 16,
                        color: message['seen'] == true
                            ? Colors.cyan
                            : Colors.white70,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
