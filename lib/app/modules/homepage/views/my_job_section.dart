import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/modules/homepage/controller/my_job_controller.dart';
import 'package:wisper/app/modules/homepage/widget/job_card.dart';

class MyJobSection extends StatefulWidget {
  const MyJobSection({super.key});

  @override
  State<MyJobSection> createState() => _MyJobSectionState();
}

class _MyJobSectionState extends State<MyJobSection> {
  final MyFeedJobController controller = Get.find<MyFeedJobController>();

  @override
  void initState() {
    super.initState();
    controller.getJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.inProgress) {
        return const Center(child: CircularProgressIndicator());
      } else {
        print('Length: ${controller.allJobData.length}');

        return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: controller.allJobData.length,

            itemBuilder: (context, index) {
              var date = controller.allJobData[index].createdAt;
              final DateFormatter formattedTime = DateFormatter(date!);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: JobCard(
                  postId: controller.allJobData[index].id,
                  ownerImage:
                      controller.allJobData[index].author!.business?.image ??
                      '',
                  ownerName:
                      controller.allJobData[index].author!.business?.name ?? '',
                  ownerDesignation:
                      controller.allJobData[index].author!.business?.industry ??
                      '',
                  jobTitle: controller.allJobData[index].title ?? '',
                  salary: controller.allJobData[index].salary.toString(),
                  location: controller.allJobData[index].location ?? '',
                  jobType: controller.allJobData[index].type ?? '',
                  jobDescription:
                      controller.allJobData[index].description ?? '',
                  shiftType:
                      controller.allJobData[index].compensationType ?? '',
                  date: formattedTime.getRelativeTimeFormat(),
                ),
              );
            },
          ),
        );
      }
    });
  }
}
