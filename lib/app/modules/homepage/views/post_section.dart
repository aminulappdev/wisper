import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisper/app/modules/homepage/controller/feed_post_controller.dart';
import 'package:wisper/app/modules/homepage/widget/post_card.dart';

class PostSection extends StatefulWidget {
  final Widget trailing;
  const PostSection({super.key, required this.trailing});

  @override
  State<PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  final AllFeedPostController controller = Get.find<AllFeedPostController>();

  @override
  void initState() {
    super.initState();
    controller.getAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.inProgress) {
        return const Center(child: CircularProgressIndicator());
      } else {
        print('Length: ${controller.allPostData.length}');
        return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: controller.allPostData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: PostCard(trailing: widget.trailing),
              );
            },
          ),
        );
      }
    });
  }
}
