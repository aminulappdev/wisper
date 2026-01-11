import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/others/custom_size.dart';
import 'package:wisper/app/modules/payment/controller/payment_url_controller.dart';

class PaymentView extends StatefulWidget {
  final Map<String, dynamic> paymentData;

  static const String routeName = '/payment-webview-screen';

  const PaymentView({super.key, required this.paymentData});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  late WebViewController _controller;

  final PaymentURLController paymentURLController = PaymentURLController();

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(LightThemeColors.whiteColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('Page start loading: $url');
          },
          onPageFinished: (String url) async {
            debugPrint('Page finished loading: $url');
            if (url.contains("boosts/callback?sessionId")) {
              debugPrint(
                'Confirmed payment hoye geche............................',
              );
              final bool isSuccess = await paymentURLController.paymentUrl(url);
              if (isSuccess) {
                //Get.to(MainButtonNavbarScreen());
                // await confirmPayment('${widget.paymentData['reference']}');
                // Navigator.pushNamed(context, '/payment-success-screen'); // Adjust route name if needed
              }
              debugPrint('::::::::::::: if condition ::::::::::::::::');
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentData['link'] ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightThemeColors.whiteColor,
      appBar: AppBar(
        backgroundColor: LightThemeColors.darkGreyColor,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 18),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(Icons.shield_outlined, color: Colors.white, size: 14),
            // widthBox4,
            Text(
              widget.paymentData['link'] ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
