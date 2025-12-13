import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChattingFieldWidget extends StatefulWidget {
  final TextEditingController controller;

  const ChattingFieldWidget({
    super.key,
    required this.controller, // required করো
  });

  @override
  State<ChattingFieldWidget> createState() => _ChattingFieldWidgetState();
}

class _ChattingFieldWidgetState extends State<ChattingFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: TextFormField(
        controller: widget.controller, // এখানে পাস করা controller ব্যবহার করো
        decoration: InputDecoration(
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
          ), // optional: ভালো লাগার জন্য
        ),
        style: TextStyle(
          color: Colors.white,
        ), // optional: black background-এ visible হওয়ার জন্য
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ChattingFieldWidget extends StatefulWidget {
//   final TextEditingController controller;

//   const ChattingFieldWidget({super.key, required this.controller});

//   @override
//   State<ChattingFieldWidget> createState() => _ChattingFieldWidgetState();
// }

// class _ChattingFieldWidgetState extends State<ChattingFieldWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 4.w),
//       child: TextFormField(
//         controller: widget.controller,
//         keyboardType: TextInputType.multiline,
//         minLines: 1, // শুরুতে এক লাইন
//         maxLines: 5, // সর্বোচ্চ ৫ লাইন পর্যন্ত বাড়বে (তুমি চাইলে বাড়াতে পারো)
//         textInputAction: TextInputAction.newline, // এন্টার চাপলে নতুন লাইন যাবে
//         style: TextStyle(color: Colors.white, fontSize: 16.sp),
//         decoration: InputDecoration(
//           hintText: 'Type here...',
//           hintStyle: TextStyle(color: Colors.grey.shade600),
//           filled: true,
//           fillColor: Colors.black,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(50.r),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: 20.w,
//             vertical: 15.h,
//           ),
//         ),
//         // এন্টার চাপলে মেসেজ সেন্ড না হয়ে নতুন লাইন যাওয়ার জন্য
//         onFieldSubmitted: (_) {
//           // কিছুই করবো না → এন্টার শুধু লাইন ব্রেক করবে
//         },
//       ),
//     );
//   }
// }
