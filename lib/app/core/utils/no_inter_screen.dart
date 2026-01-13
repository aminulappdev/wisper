import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/others/get_storage.dart';
import 'package:wisper/app/core/utils/connectivity_services.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.signal_wifi_off,
                  size: 120,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 32),
                const Text(
                  "No Internet",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Please check your Wi-Fi or mobile data and try again.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Obx(() {
                  final connectivity = Get.find<ConnectivityService>();
                  return ElevatedButton.icon(
                    onPressed: connectivity.isOnline.value
                        ? null
                        : () async {
                            final isConnected = await connectivity.checkInternetAccess();
                            if (isConnected) {
                              connectivity.isOnline.value = true;

                              // Token check করে সঠিক page-এ যাও
                              final String? token = StorageUtil.getData(StorageUtil.userAccessToken);
                              if (token != null && token.isNotEmpty) {
                                Get.offAllNamed('/dashboard');
                              } else {
                                Get.offAllNamed('/onboarding');
                              }
                            } else {
                              Get.snackbar(
                                "Still Offline",
                                "No internet detected. Please try again.",
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                              );
                            }
                          },
                    icon: const Icon(Icons.refresh, color: Colors.white,),
                    label: const Text("Retry", style: TextStyle(fontSize: 18, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}