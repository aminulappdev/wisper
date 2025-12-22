import 'package:get/get.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/services/network_caller/network_caller.dart';
import 'package:wisper/app/core/services/network_caller/network_response.dart';
import 'package:wisper/app/modules/payment/model/payment_model.dart';
import 'package:wisper/app/urls.dart';

class PaymentController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _accessToken;
  String? get accessToken => _accessToken;

  PaymentModel? paymentModel;
  PaymentModel? get paymentData => paymentModel;

  Future<bool> getPayment(
    String packageId,
    String postId,
    String targetIndustry,
  ) async {
    bool isSuccess = false;

    _inProgress = true;

    update();

    Map<String, dynamic> requestBody = {
      "packageId": packageId,
      "postId": postId,
      "targetIndustry": targetIndustry,
    };

    final NetworkResponse response = await Get.find<NetworkCaller>()
        .postRequest(
          Urls.paymentUrl,
          body: requestBody,
          accessToken: StorageUtil.getData(StorageUtil.userAccessToken),
        );

    if (response.isSuccess) {
      paymentModel = PaymentModel.fromJson(response.responseData);
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}
