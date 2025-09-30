// import 'dart:io';
// import 'package:alyse_roe/app/services/network_caller/network_caller.dart'; 
// import 'package:alyse_roe/app/services/network_caller/network_response.dart';
// import 'package:alyse_roe/app/urls.dart';
// import 'package:get/get.dart';

// class SignUpController extends GetxController {
//   final RxBool _inProgress = false.obs;
//   bool get inProgress => _inProgress.value;

//   final RxString _errorMessage = ''.obs;
//   String get errorMessage => _errorMessage.value;

//   /// 🔁 Sign Up Function
//   Future<bool> signUp({
//     String? name,
//     String? schoolName,
//     String? email,
//     String? room,
//     String? password,
//     String? discrictId,
//     File? image,
//   }) async {
//     if (_inProgress.value) {
//       _errorMessage.value = 'Operation in progress';
//       return false;
//     }

//     _inProgress.value = true;
//     update();

//     print('districtId: $discrictId');
//     print('Image: $image');
//     if (image != null) {
//       print('Image path: ${image.path}');
//       print('Image exists: ${await image.exists()}');
//     } else {
//       print('Image is null');
//     }

//     try {
//       // Prepare the body
//       Map<String, dynamic> jsonFields = {
//         "name": name,
//         "email": email,
//         "roomNumber": room,
//         "school": schoolName,
//         "district": discrictId,
//         "password": password,
//       };

//       final NetworkResponse response = await Get.find<NetworkCaller>()
//           .postRequest(
//             Urls.signUpUrl,
//             body: jsonFields,
//             image: image, // Pass the image explicitly
//             keyNameImage: 'image', // Ensure this matches the server key
//           );

//       if (response.isSuccess && response.responseData != null) {
//         _errorMessage.value = '';
//         _inProgress.value = false;
//         update();
//         return true;
//       } else {
//         _errorMessage.value = response.errorMessage;
//         _inProgress.value = false;
//         update();
//         return false;
//       }
//     } catch (e) {
//       _errorMessage.value = 'Error signing up: $e';
//       _inProgress.value = false;
//       update();
//       return false;
//     }
//   }
// }
