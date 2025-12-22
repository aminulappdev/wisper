// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/services/network_caller/network_caller.dart';
import 'package:wisper/app/core/services/network_caller/network_response.dart';
import 'package:wisper/app/modules/authentication/views/sign_in_screen.dart';
import 'package:wisper/app/modules/homepage/model/feed_job_model.dart';
import 'package:wisper/app/urls.dart';

class OthersJobController extends GetxController {
  final NetworkCaller networkCaller = Get.find<NetworkCaller>();

  final RxBool _inProgress = false.obs;
  bool get inProgress => _inProgress.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  final RxList<FeedJobItemModel> _allJobList = <FeedJobItemModel>[].obs;
  RxList<FeedJobItemModel> get allJobData => _allJobList;

  final int _limit = 20;
  int page = 0;
  int? lastPage;

  // Category filter
  final RxString _selectedCategoryId = ''.obs;
  String get selectedCategoryId => _selectedCategoryId.value;
  set selectedCategoryId(String value) {
    _selectedCategoryId.value = value;
    resetPagination(); // Reset and fetch data when category changes
    update(); // Ensure UI updates
  }

  Future<bool> getAllJob({String? userId}) async {
    print('User ID avobe getAllPost: $userId');
    if (_inProgress.value) {
      print('Fetch already in progress, skipping');
      return false;
    }

    if (lastPage != null && page >= lastPage!) {
      print('Reached last page: $lastPage');
      _inProgress.value = false;
      update();
      return false;
    }

    _inProgress.value = true;
    update();

    try {
      // Increment page after checking lastPage
      page++;
      print('Fetching assets for page: $page');

      Map<String, dynamic> queryParams = userId != null || userId != ''
          ? {'limit': _limit, 'page': page, 'authorId': userId ?? ''}
          : {'limit': _limit, 'page': page};

      print('Fetching assets with params: $queryParams');

      if (userId != null || userId != '') {
        print('Fetching assets with userId: $userId');
      }

      final NetworkResponse response = await networkCaller.getRequest(
        Urls.feedJobUrl,
        queryParams: queryParams,
        accessToken: StorageUtil.getData(StorageUtil.userAccessToken),
      );

      print('Raw response: ${response.responseData}');

      if (response.isSuccess && response.responseData != null) {
        _errorMessage.value = '';

        FeedJobModel jobModel = FeedJobModel.fromJson(response.responseData);

        _allJobList.addAll(jobModel.data?.jobs ?? []);

        if (jobModel.data?.meta?.total != null &&
            jobModel.data?.meta?.limit != null) {
          lastPage = (jobModel.data!.meta!.total! / jobModel.data!.meta!.limit!)
              .ceil();
          print('Last page calculated: $lastPage');
        }

        _inProgress.value = false;
        update();
        return true;
      } else {
        _errorMessage.value = response.errorMessage;
        if (_errorMessage.value.contains('expired')) {
          Get.to(() => SignInScreen());
        }
        _inProgress.value = false;
        update();
        return false;
      }
    } catch (e) {
      _errorMessage.value = 'Failed to fetch asset data: ${e.toString()}';
      print('Error fetching asset data: $e');
      _inProgress.value = false;
      update();
      return false;
    }
  }

  void resetPagination() {
    page = 0; // Reset to 0 so first call uses page 1
    lastPage = null;
    _allJobList.clear();
    print('Pagination reset, fetching with categoryId: $_selectedCategoryId');
  }
}
