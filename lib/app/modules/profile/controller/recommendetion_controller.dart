import 'package:get/get.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/services/network_caller/network_caller.dart';
import 'package:wisper/app/core/services/network_caller/network_response.dart';
import 'package:wisper/app/modules/authentication/views/sign_in_screen.dart';
import 'package:wisper/app/modules/profile/model/recommendation_model.dart';
import 'package:wisper/app/urls.dart';

class AllRecommendationController extends GetxController {
  final RxBool _inProgress = false.obs;
  bool get inProgress => _inProgress.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  // পরিবর্তন: RxList ব্যবহার করো — এটা real-time update-এর জন্য সবচেয়ে ভালো
  final RxList<RecommendationItemModel> _recommendationList =
      <RecommendationItemModel>[].obs;

  // Public getter — UI থেকে এটাই ব্যবহার করবে
  List<RecommendationItemModel> get recommendationData => _recommendationList;

  @override
  void onInit() {
    super.onInit();
    // যদি প্রয়োজন হয় প্রথমবার লোড করার জন্য
  }

  Future<bool> getAllRecommendations(String? id) async {
    if (id == null || id.isEmpty) {
      _errorMessage.value = 'User ID is required';
      return false;
    }

    _inProgress.value = true;
    update(); // optional: loading state reflect করতে

    print('Fetching recommendations for ID: $id');

    try {
      final NetworkResponse response = await Get.find<NetworkCaller>()
          .getRequest(
            Urls.recommendationById(id),
            accessToken: StorageUtil.getData(StorageUtil.userAccessToken),
          );

      _inProgress.value = false;

      if (response.isSuccess && response.responseData != null) {
        _errorMessage.value = '';

        final RecommendationModel model = RecommendationModel.fromJson(
          response.responseData,
        );

        // মূল পরিবর্তন: RxList-এ assign করো
        _recommendationList.assignAll(model.data ?? []);

        // অতিরিক্ত নিশ্চিত করার জন্য (খুবই গুরুত্বপূর্ণ real-time-এর জন্য)
        _recommendationList.refresh();

        return true;
      } else {
        _errorMessage.value =
            response.errorMessage ?? 'Failed to load recommendations';

        if (_errorMessage.value.toLowerCase().contains('expired') ||
            _errorMessage.value.toLowerCase().contains('unauthorized')) {
          Get.offAll(() => SignInScreen());
        }

        // খালি লিস্ট সেট করো error এর ক্ষেত্রে
        _recommendationList.clear();

        return false;
      }
    } catch (e) {
      _inProgress.value = false;
      _errorMessage.value = 'Failed to fetch recommendations: $e';
      print('Error fetching recommendations: $e');

      _recommendationList.clear();
      return false;
    }
  }

  // অতিরিক্ত হেল্পার: নতুন রেকমেন্ডেশন যোগ করার পর ম্যানুয়ালি আপডেট (optional)
  void addRecommendationLocally(RecommendationItemModel newItem) {
    _recommendationList.insert(0, newItem); // সামনে যোগ করো (latest first)
    _recommendationList.refresh();
  }

  // যদি অন্য কোথাও থেকে refresh করতে চাও
  void refreshRecommendations() {
    _recommendationList.refresh();
    update(); // এটা খুবই জরুরি
  }
}
