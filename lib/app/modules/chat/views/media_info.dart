import 'package:flutter/material.dart';
import 'package:wisper/app/core/widgets/image_container_widget.dart';
import 'package:wisper/gen/assets.gen.dart';

class MediaInfo extends StatelessWidget {
  const MediaInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.all(0),
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return ImageContainer(
            image: Assets.images.image.keyName,
            height: 164,
            width: 177,
            borderRadius: 10,
          );
        },
      ),
    );
  }
}
