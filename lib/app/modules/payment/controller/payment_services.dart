// payment_service.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/modules/payment/controller/payment_controller.dart';
import 'package:wisper/app/modules/payment/view/payment_webview_screen.dart';

class PaymentService {
  final PaymentController paymentController = PaymentController();

  Future<void> payment(
    BuildContext context,
    String packageId,
    String postId,
    String targetIndustry,
  ) async {
    final bool isSuccess = await paymentController.getPayment(
      packageId,
      postId,
      targetIndustry,
    );

    Map<String, dynamic> paymentData = {
      'link': paymentController.paymentData!.data?.url ?? '',
      'reference': '',
    };

    if (isSuccess) {
      // Directly use context without mounted check
      // showSuccess('Payment request done');
      Get.to(PaymentView(paymentData: paymentData));
    } else {
      // Error handling
      showSnackBarMessage(context, 'Something went wrong', true);
    }
  }
}
