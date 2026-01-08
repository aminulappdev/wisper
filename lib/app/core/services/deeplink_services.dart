import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🔥 GetX import করো

class DeepLinkService extends GetxService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initDeepLinks() async {
    // App খোলার সময় যদি deep link দিয়ে আসে (cold start)
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLink(initialLink);
    }

    // App চলার সময় deep link আসলে (hot start)
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        if (uri != null) {
          _handleLink(uri);
        }
      },
      onError: (err) => debugPrint("DeepLink error: $err"),
    );
  } 

  void _handleLink(Uri uri) {
    debugPrint("🔗 DeepLink received: $uri");

    // উদাহরণ: https://yourapp.com/running/12345
    // অথবা https://yourdomain.page.link/running/12345 (Firebase Dynamic Link)
    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'running') {
      final runId = uri.pathSegments.last;

      // GetX দিয়ে named route-এ navigate করা
      // যদি user logged in না থাকে তাহলে প্রথমে splash বা login-এ পাঠাতে পারো
      // কিন্তু সাধারণত deep link content দেখানোর জন্য logged in থাকতে হবে

      Get.toNamed('/running/$runId');
    }

    // অন্যান্য path যদি থাকে (যেমন /profile/123, /event/abc ইত্যাদি)
    // else if (uri.pathSegments.first == 'profile') { ... }
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }
}