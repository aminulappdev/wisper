import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_text_filed.dart';
import 'package:wisper/app/core/widgets/label.dart';
import 'package:wisper/app/modules/homepage/controller/create_job_controller.dart';
import 'package:wisper/app/modules/homepage/controller/edit_job_controller.dart';
import 'package:wisper/app/modules/homepage/controller/my_job_controller.dart';
import 'package:wisper/app/modules/homepage/model/feed_job_model.dart';

class EditJobPostScreen extends StatefulWidget {
  final FeedJobItemModel job;
  const EditJobPostScreen({super.key, required this.job});

  @override
  State<EditJobPostScreen> createState() => _EditJobPostScreenState();
}

class _EditJobPostScreenState extends State<EditJobPostScreen> {
  late final TextEditingController titleC;
  late final TextEditingController descC;
  late final TextEditingController salaryC;
  late final TextEditingController locationC;
  late final TextEditingController industryC; // ← এখানে TextField

  final reqC = TextEditingController();
  final resC = TextEditingController();

  late String jobType;
  late String expLevel;
  late String compType;
  late String qualification;
  late String applyMethod;
  late String industry;

  late List<String> requirements;
  late List<String> responsibilities;

  @override
  void initState() {
    super.initState();

    titleC = TextEditingController(text: widget.job.title ?? '');
    descC = TextEditingController(text: widget.job.description ?? '');
    salaryC = TextEditingController(text: widget.job.salary?.toString() ?? '');
    locationC = TextEditingController(text: widget.job.location ?? '');

    // Industry → TextField দিয়ে নেওয়া হলো (Edtech, Fintech যাই আসুক)
    industryC = TextEditingController(
      text: widget.job.author?.business?.industry ?? '',
    );
    industry = industryC.text.isEmpty ? 'Other' : industryC.text;

    jobType = widget.job.type ?? 'FULL_TIME';
    expLevel = widget.job.experienceLevel ?? 'MID_LEVEL';
    compType = widget.job.compensationType ?? 'MONTHLY';
    qualification = widget.job.qualification ?? 'BSC';
    applyMethod = widget.job.applicationType ?? 'CHAT';

    requirements = List.from(widget.job.requirements);
    responsibilities = List.from(widget.job.responsibilities);
  }

  @override
  void dispose() {
    titleC.dispose();
    descC.dispose();
    salaryC.dispose();
    locationC.dispose();
    industryC.dispose();
    reqC.dispose();
    resC.dispose();
    super.dispose();
  }

  void _save() {
    if (titleC.text.trim().isEmpty || descC.text.trim().isEmpty) {
      showSnackBarMessage(context, "Title & Description required!", true);
      return;
    }

    showLoadingOverLay(asyncFunction: _updateJob, msg: "Updating job...");
  }

  Future<void> _updateJob() async {
    final success = await EditJobController().editJob(
      jobId: widget.job.id,
      title: titleC.text.trim(),
      description: descC.text.trim(),
      type: jobType,
      experienceLevel: expLevel,
      compensationType: compType,
      salary: double.tryParse(salaryC.text) ?? 0,
      location: locationC.text.trim().isEmpty
          ? "Remote"
          : locationC.text.trim(),
      qualification: qualification,
      industry: industryC.text.trim().isEmpty ? "Other" : industryC.text.trim(),
      requirements: requirements,
      responsibilities: responsibilities,
      applicationType: applyMethod,
    );

    if (!mounted) return;

    if (success) {
      final MyFeedJobController controller = Get.find<MyFeedJobController>();

      controller.page = 0;
      controller.lastPage = null;
      controller.allJobData.clear();
      controller.getJobs();
      Navigator.pop(context);
      showSnackBarMessage(context, "Job updated successfully!", false);
    } else {
      showSnackBarMessage(context, "Failed to update job", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heightBox40,

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                CustomElevatedButton(
                  title: "Update",
                  onPress: _save,
                  height: 40,
                  width: 100,
                ),
              ],
            ),

            heightBox20,
            const Text(
              "Edit Job Post",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            heightBox30,

            // Job Title
            const Label(label: "Job Title"), heightBox6,
            CustomTextField(
              controller: titleC,
              hintText: "e.g. Senior Flutter Developer",
            ),
            heightBox16,

            // Description
            const Label(label: "Description"), heightBox6,
            SizedBox(
              height: 130.h,
              child: CustomTextField(
                controller: descC,
                maxLines: 10,
                hintText: "Describe the role...",
              ),
            ),
            heightBox16,

            // Job Type
            const Label(label: "Job Type"), heightBox6,
            _dropdown(
              jobType,
              ["FULL_TIME", "PART_TIME", "CONTRACT"],
              ["Full Time", "Part Time", "Contract"],
              (v) => setState(() => jobType = v),
            ),
            heightBox16,

            // Experience Level
            const Label(label: "Experience Level"), heightBox6,
            _dropdown(
              expLevel,
              ["ENTRY_LEVEL", "JUNIOR", "MID_LEVEL", "SENIOR"],
              ["Entry", "Junior", "Mid", "Senior"],
              (v) => setState(() => expLevel = v),
            ),
            heightBox16,

            // Compensation Type
            const Label(label: "Compensation Type"), heightBox6,
            _dropdown(
              compType,
              ["MONTHLY", "ONE_OFF"],
              ["Monthly Salary", "One-time Payment"],
              (v) => setState(() => compType = v),
            ),
            heightBox16,

            // Salary
            const Label(label: "Salary (USD)"), heightBox6,
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: salaryC,
                    hintText: "1800",
                    keyboardType: TextInputType.number,
                  ),
                ),
                widthBox10,
                Text(
                  compType == "MONTHLY" ? "/ month" : "total",
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                ),
              ],
            ),
            heightBox16,

            // Location
            const Label(label: "Location"), heightBox6,
            CustomTextField(
              controller: locationC,
              hintText: "e.g. Dhaka, Remote, Hybrid",
            ),
            heightBox16,

            // Industry → এখন TextField (কোনো error আসবে না!)
            const Label(label: "Industry"), heightBox6,
            CustomTextField(
              controller: industryC,
              hintText: "e.g. Edtech, Fintech, Healthtech",
              onChanged: (v) => industry = v,
            ),
            heightBox16,

            // Qualification
            const Label(label: "Minimum Qualification"), heightBox6,
            _dropdown(
              qualification,
              ["BSC", "HND", "OND", "PHD"],
              ["BSc", "HND", "OND", "PhD"],
              (v) => setState(() => qualification = v),
            ),
            heightBox16,

            // Application Method
            const Label(label: "Application Method"), heightBox6,
            _dropdown(
              applyMethod,
              ["CHAT", "EMAIL", "EXTERNAL"],
              ["Via Wisper Chat", "Email", "External Link"],
              (v) => setState(() => applyMethod = v),
            ),
            heightBox20,

            // Requirements
            const Label(label: "Requirements"), heightBox8,
            ...requirements
                .map(
                  (e) => _item(e, () => setState(() => requirements.remove(e))),
                )
                .toList(),
            _addField(reqC, () => _add("req")),
            heightBox20,

            // Responsibilities
            const Label(label: "Responsibilities"), heightBox8,
            ...responsibilities
                .map(
                  (e) => _item(
                    e,
                    () => setState(() => responsibilities.remove(e)),
                  ),
                )
                .toList(),
            _addField(resC, () => _add("res")),
            heightBox100,
          ],
        ),
      ),
    );
  }

  // Simple Dropdown
  Widget _dropdown(
    String value,
    List<String> values,
    List<String> labels,
    Function(String) onChange,
  ) {
    return CustomTextField(
      hintText: "Select",
      value: value,
      onChanged: (v) => onChange(v!),
      items: List.generate(
        values.length,
        (i) => DropdownMenuItem(value: values[i], child: Text(labels[i])),
      ),
    );
  }

  // Add new item
  void _add(String type) {
    final text = (type == "req" ? reqC.text : resC.text).trim();
    if (text.isEmpty) return;
    setState(() {
      if (type == "req")
        requirements.add(text);
      else
        responsibilities.add(text);
    });
    (type == "req" ? reqC : resC).clear();
  }

  // List Item
  Widget _item(String text, VoidCallback onDelete) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          widthBox10,
          Expanded(child: Text(text)),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.close, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }

  // Add Field
  Widget _addField(TextEditingController c, VoidCallback onAdd) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(controller: c, hintText: "Add item"),
        ),
        widthBox10,
        IconButton(
          onPressed: onAdd,
          icon: const Icon(Icons.add_circle, color: Colors.blue),
        ),
      ],
    );
  }
}
