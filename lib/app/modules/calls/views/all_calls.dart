import 'package:flutter/material.dart';

class AllCalls extends StatelessWidget {
  const AllCalls({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.upcoming_outlined, color: Colors.white, size: 50),
            Text(
              'This feature is coming soon!',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
      // child: ListView.builder(
      //   padding: EdgeInsets.all(0),
      //   itemCount: 10,
      //   itemBuilder: (context, index) {
      //     return Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 6),
      //       child: CallListTile(
      //         imagePath: Assets.images.image.keyName,
      //         name: 'Aminul Islam',
      //         time: '11:30 AM',
      //         callType: 'Outgoing',
      //         callTypeColor: LightThemeColors.themeGreyColor,
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
