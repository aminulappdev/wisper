import 'package:flutter/material.dart';
import 'package:wisper/app/modules/homepage/widget/post_card.dart';

class PostSection extends StatelessWidget {
  final Widget trailing;
  const PostSection({super.key, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: PostCard(
              trailing: trailing,
            ),
          );
        },
      ),
    );
  }
}
