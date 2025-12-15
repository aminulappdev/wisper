
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';

class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMe;
  final String imageUrl;
  final String senderName;
  final String? senderImage;
  final String time;
  final bool isGroupChat; // Group হলে নাম উপরে দেখাবে

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.imageUrl,
    required this.senderName,
    this.senderImage,
    required this.time,
    this.isGroupChat = false,
  });

  @override
  Widget build(BuildContext context) {
    print('Sender Name: $senderName');
    print('Sender Image: $senderImage');
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // দুই চ্যাটেই receiver-এর avatar/first letter দেখাবে
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
                // // শুধু Group Chat-এ sender এর নাম বাবলের উপরে দেখাবে
                // if (!isMe && isGroupChat && senderName.isNotEmpty)
                //   Padding(
                //     padding: EdgeInsets.only(left: 8.w, bottom: 4.h),
                //     child: Text(
                //       senderName,
                //       style: TextStyle(
                //         fontSize: 12.sp,
                //         color: Colors.grey[600],
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //   ),

                // // মেসেজ বাবল
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
                      if (imageUrl.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.network(
                              imageUrl,
                              height: 160.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 160.h,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
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