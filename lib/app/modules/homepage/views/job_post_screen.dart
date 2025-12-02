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
import 'package:wisper/app/modules/homepage/controller/my_job_controller.dart';

class JobPostScreen extends StatefulWidget {
  const JobPostScreen({super.key});
  @override
  State<JobPostScreen> createState() => _JobPostScreenState();
}

class _JobPostScreenState extends State<JobPostScreen> {
  final CreateJobController createJobController = CreateJobController();

  // Controllers
  final _titleC = TextEditingController();
  final _descC = TextEditingController();
  final _salaryC = TextEditingController();
  final _locationC =
      TextEditingController(); // নতুন: Location এর জন্য টেক্সট কন্ট্রোলার
  final _reqC = TextEditingController();
  final _resC = TextEditingController();

  // Selected values (enum strings)
  String? type = 'FULL_TIME';
  String? experienceLevel = 'MID_LEVEL';
  String? compensationType = 'MONTHLY';
  String? qualification = 'BSC';
  String? applicationType = 'CHAT';
  String? industry = 'Web Development';

  List<String> requirements = [];
  List<String> responsibilities = [];

  void _addItem(String type) {
    final controller = type == 'req' ? _reqC : _resC;
    if (controller.text.trim().isNotEmpty) {
      setState(() {
        (type == 'req' ? requirements : responsibilities).add(
          controller.text.trim(),
        );
        controller.clear();
      });
    }
  }

  void _removeItem(String type, int index) {
    setState(() {
      (type == 'req' ? requirements : responsibilities).removeAt(index);
    });
  }

  void createJob() {
    showLoadingOverLay(
      asyncFunction: () async => await performCreateJob(context),
      msg: 'Posting job...',
    );
  }

  Future<void> performCreateJob(BuildContext context) async {
    final bool isSuccess = await createJobController.createJob(
      title: _titleC.text.trim(),
      description: _descC.text.trim(),
      type: type!,
      experienceLevel: experienceLevel!,
      compensationType: compensationType!,
      salary: double.tryParse(_salaryC.text) ?? 0.0,
      location: _locationC.text.trim().isEmpty
          ? "Remote"
          : _locationC.text.trim(), // টেক্সট থেকে নেয়া হবে
      qualification: qualification!,
      industry: industry!,
      requirements: requirements,
      responsibilities: responsibilities,
      applicationType: applicationType!,
    );

    if (isSuccess) {
      final MyFeedJobController myFeedJobController =
          Get.find<MyFeedJobController>();

      myFeedJobController.page = 0;
      myFeedJobController.lastPage = null;
      myFeedJobController.allJobData.clear();

      await myFeedJobController.getJobs();
      Navigator.pop(context);
      showSnackBarMessage(context, "Job posted successfully!", false);
    } else {
      showSnackBarMessage(context, createJobController.errorMessage, true);
    }
  }

  @override
  void dispose() {
    _titleC.dispose();
    _descC.dispose();
    _salaryC.dispose();
    _locationC.dispose(); // ডিসপোজ করা হলো
    _reqC.dispose();
    _resC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightBox40,

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    width: 80,
                    child: CustomElevatedButton(
                      title: 'Post',
                      textSize: 14,
                      borderRadius: 50,
                      onPress: createJob,
                    ),
                  ),
                ],
              ),

              heightBox20,
              const Text(
                'Post a Job',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              heightBox20,

              // 1. Job Title
              const Label(label: 'Job Title'), heightBox6,
              CustomTextField(
                controller: _titleC,
                hintText: 'e.g. Frontend Developer',
              ),
              heightBox16,

              // 2. Description
              const Label(label: 'Description'), heightBox6,
              SizedBox(
                height: 140.h,
                child: CustomTextField(
                  controller: _descC,
                  maxLines: 8,
                  hintText: 'Describe the role...',
                ),
              ),
              heightBox16,

              // 3. Job Type
              const Label(label: 'Job Type'), heightBox6,
              CustomTextField(
                hintText: 'Select job type',
                value: type,
                onChanged: (v) => setState(() => type = v),
                items: const [
                  DropdownMenuItem(
                    value: 'FULL_TIME',
                    child: Text('Full Time'),
                  ),
                  DropdownMenuItem(
                    value: 'PART_TIME',
                    child: Text('Part Time'),
                  ),
                  DropdownMenuItem(value: 'CONTRACT', child: Text('Contract')),
                ],
              ),
              heightBox16,

              // 4. Experience Level
              const Label(label: 'Experience Level'), heightBox6,
              CustomTextField(
                hintText: 'Select experience level',
                value: experienceLevel,
                onChanged: (v) => setState(() => experienceLevel = v),
                items: const [
                  DropdownMenuItem(
                    value: 'ENTRY_LEVEL',
                    child: Text('Entry Level'),
                  ),
                  DropdownMenuItem(value: 'JUNIOR', child: Text('Junior')),
                  DropdownMenuItem(
                    value: 'MID_LEVEL',
                    child: Text('Mid Level'),
                  ),
                  DropdownMenuItem(value: 'SENIOR', child: Text('Senior')),
                ],
              ),
              heightBox16,

              // 5. Compensation Type
              const Label(label: 'Compensation Type'), heightBox6,
              CustomTextField(
                hintText: 'Select compensation type',
                value: compensationType,
                onChanged: (v) => setState(() => compensationType = v),
                items: const [
                  DropdownMenuItem(
                    value: 'MONTHLY',
                    child: Text('Monthly Salary'),
                  ),
                  DropdownMenuItem(
                    value: 'ONE_OFF',
                    child: Text('One-time Payment'),
                  ),
                ],
              ),
              heightBox16,

              // 6. Salary
              const Label(label: 'Salary (USD)'), heightBox6,
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _salaryC,
                      hintText: '1800',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  widthBox10,
                  Text(
                    compensationType == 'MONTHLY' ? '/ month' : 'total',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                ],
              ),
              heightBox16,

              // 7. Location → এখন টেক্সট ফিল্ড (ড্রপডাউন নয়)
              const Label(label: 'Location'), heightBox6,
              CustomTextField(
                controller: _locationC,
                hintText: 'e.g. Dhaka, Bangladesh | Remote | New York',
              ),
              heightBox16,

              // 8. Industry
              const Label(label: 'Industry'), heightBox6,
              CustomTextField(
                hintText: 'Select industry',
                value: industry,
                onChanged: (v) => setState(() => industry = v),
                items: const [
                  DropdownMenuItem(
                    value: 'Web Development',
                    child: Text('Web Development'),
                  ),
                  DropdownMenuItem(
                    value: 'Mobile Development',
                    child: Text('Mobile Development'),
                  ),
                  DropdownMenuItem(
                    value: 'UI/UX Design',
                    child: Text('UI/UX Design'),
                  ),
                  DropdownMenuItem(
                    value: 'Data Science',
                    child: Text('Data Science'),
                  ),

                  DropdownMenuItem(
                    value: 'Marketing',
                    child: Text('Marketing'),
                  ),
                  DropdownMenuItem(value: 'Sales', child: Text('Sales')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
              ),
              heightBox16,

              // 9. Qualification
              const Label(label: 'Minimum Qualification'), heightBox6,
              CustomTextField(
                hintText: 'Select qualification',
                value: qualification,
                onChanged: (v) => setState(() => qualification = v),
                items: const [
                  DropdownMenuItem(
                    value: 'BSC',
                    child: Text("Bachelor's Degree (BSc)"),
                  ),
                  DropdownMenuItem(value: 'HND', child: Text('HND')),
                  DropdownMenuItem(value: 'OND', child: Text('OND')),
                  DropdownMenuItem(value: 'PHD', child: Text('PhD')),
                ],
              ),
              heightBox16,

              // 10. Application Method
              const Label(label: 'Application Method'), heightBox6,
              CustomTextField(
                hintText: 'How should candidates apply?',
                value: applicationType,
                onChanged: (v) => setState(() => applicationType = v),
                items: const [
                  DropdownMenuItem(
                    value: 'CHAT',
                    child: Text('Via Wisper Chat'),
                  ),
                  DropdownMenuItem(value: 'EMAIL', child: Text('Via Email')),
                  DropdownMenuItem(
                    value: 'EXTERNAL',
                    child: Text('External Link'),
                  ),
                ],
              ),
              heightBox20,

              // Requirements
              const Label(label: 'Requirements'), heightBox8,
              ...requirements.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                      widthBox10,
                      Expanded(child: Text(e.value)),
                      GestureDetector(
                        onTap: () => _removeItem('req', e.key),
                        child: const Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _reqC,
                      hintText: 'Add requirement',
                    ),
                  ),
                  widthBox10,
                  IconButton(
                    onPressed: () => _addItem('req'),
                    icon: const Icon(Icons.add_circle, color: Colors.blue),
                  ),
                ],
              ),
              heightBox20,

              // Responsibilities
              const Label(label: 'Responsibilities'), heightBox8,
              ...responsibilities.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                      widthBox10,
                      Expanded(child: Text(e.value)),
                      GestureDetector(
                        onTap: () => _removeItem('res', e.key),
                        child: const Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _resC,
                      hintText: 'Add responsibility',
                    ),
                  ),
                  widthBox10,
                  IconButton(
                    onPressed: () => _addItem('res'),
                    icon: const Icon(Icons.add_circle, color: Colors.blue),
                  ),
                ],
              ),

              heightBox60,
            ],
          ),
        ),
      ),
    );
  }
}
