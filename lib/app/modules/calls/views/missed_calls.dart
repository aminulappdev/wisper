
import 'package:flutter/material.dart';
import 'package:wisper/app/modules/calls/widget/call_list_Tile.dart';
import 'package:wisper/gen/assets.gen.dart';

class MissedCalls extends StatelessWidget {
  const MissedCalls({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: CallListTile(
              imagePath: Assets.images.image.keyName,
              name: 'Aminul Islam',
              time: '11:30 AM',
              callType: 'Missed Call',
              callTypeColor: Colors.red,
            ),
          );
        },
      ),
    );
  }
}
