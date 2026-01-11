import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/others/custom_size.dart';
import 'package:wisper/app/modules/calls/views/add_call_screen.dart';
import 'package:wisper/app/modules/calls/widget/call_feature.dart';
import 'package:wisper/gen/assets.gen.dart';

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen({super.key});

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff155DFC), Color(0xff193CB8), Color(0xff1C398E)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            heightBox60,
            CircleAvatar(
              radius: 56,
              backgroundColor: Colors.white.withValues(alpha: 0.20),
              child: Container(
                height: 105,
                width: 105,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.20),
                    width: 5,
                  ),
                ),
                child: Center(
                  child: Text(
                    'AB',
                    style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
            heightBox14,
            Text(
              'Aminul Islam',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            heightBox8,
            Text(
              '00:05',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.80),
              ),
            ),
            heightBox8,
            Text(
              'voice call',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
            heightBox40,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CallFeature(
                  onTap: () {
                    _showAddGroupCall();
                  },
                  imagePath: Assets.images.userAdd.keyName,
                  title: 'Add Call',
                ),
                widthBox20,
                CallFeature(
                  onTap: () {},
                  imagePath: Assets.images.unselectedChat.keyName,
                  title: 'Message',
                ),
              ],
            ),
            heightBox200,
            heightBox50,

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CallFeature(
                  onTap: () {},
                  imagePath: Assets.images.userAdd.keyName,
                  title: 'Speaker',
                ),
                widthBox20,
                CallFeature(
                  onTap: () {},
                  imagePath: Assets.images.mic.keyName,
                  title: 'Mute',
                ),
                widthBox20,
                CallFeature(
                  color: Colors.red,
                  onTap: () {},
                  imagePath: Assets.images.callOff.keyName,
                  title: 'End Call',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGroupCall() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddCallScreen();
      },
    );
  }
}
