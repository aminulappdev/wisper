// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:wisper/app/core/others/custom_size.dart';
// import 'package:wisper/app/core/widgets/common/circle_icon.dart';
// import 'package:wisper/app/core/widgets/common/details_card.dart';
// import 'package:wisper/app/modules/chat/controller/mute_info_controller.dart';
// import 'package:wisper/gen/assets.gen.dart';

// class MuteOptionsBottomSheet extends StatelessWidget {
//   final String chatId;
//   final GetMuteInfoController muteInfoController;
//   final void Function(String?) onMute; // callback to trigger mute

//   const MuteOptionsBottomSheet({
//     required this.chatId,
//     required this.muteInfoController,
//     required this.onMute,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final options = [
//       ('8 Hours', 'EIGHT_HOURS'),
//       ('1 Week', 'ONE_WEEK'),
//       ('Always', 'ALWAYS'),
//     ];

//     return Container(
//       height: MediaQuery.of(context).size.height * 0.32,
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const SizedBox(width: 10),
//               Text(
//                 'Mute notifications',
//                 style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white),
//               ),
//               CircleIconWidget(
//                 imagePath: Assets.images.cross.keyName,
//                 onTap: () => Navigator.pop(context),
//                 radius: 15,
//               ),
//             ],
//           ),
//           heightBox10,
//           DetailsCard(
//             bgColor: const Color(0xff181818),
//             borderColor: const Color(0xff181818),
//             child: const Padding(
//               padding: EdgeInsets.all(10),
//               child: Text(
//                 'Other members will not see that you muted this chat, and you will still be notified if you are mentioned.',
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//           heightBox12,
//           DetailsCard(
//             width: double.infinity,
//             bgColor: const Color(0xff181818),
//             borderColor: const Color(0xff181818),
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: Obx(() {
//                 if (muteInfoController.inProgress) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 final currentMuteFor = muteInfoController.muteInfoData?.muteFor;

//                 return Column(
//                   children: options.map((opt) {
//                     final label = opt.$1;
//                     final value = opt.$2;
//                     final isSelected = currentMuteFor == value;

//                     return GestureDetector(
//                       onTap: () {
//                         onMute(value); // call the mute function from parent
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 6),
//                         child: Row(
//                           children: [
//                             Text(
//                               label,
//                               style: TextStyle(fontSize: 16.sp),
//                             ),
//                             const Spacer(),
//                             if (isSelected)
//                               const Icon(Icons.check, color: Colors.white, size: 16),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }