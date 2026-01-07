import 'dart:convert';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/services/network_caller/network_caller.dart';
import 'package:wisper/app/core/services/network_caller/network_response.dart';
import 'package:wisper/app/modules/dashboard/views/dashboard_screen.dart';
import 'package:wisper/app/modules/profile/controller/person/profile_controller.dart';
import 'package:wisper/app/urls.dart';

/// Controller to handle Google Sign-In + Firebase Authentication + Backend Verification
class GoogleAuthController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Observable variables for state management
  final RxBool _inProgress = false.obs;
  bool get inProgress => _inProgress.value;

  final RxString _errorMessage = ''.obs;
  String? get errorMessage =>
      _errorMessage.value.isEmpty ? null : _errorMessage.value;

  final RxString _token = ''.obs;
  String? get token => _token.value.isEmpty ? null : _token.value;

  final ProfileController profileController =
      Get.find<ProfileController>();

  /// Main Google Sign-In Function
  Future<bool> signInWithGoogle() async {
    _inProgress.value = true;
    _errorMessage.value = '';
    update();

    try {
      // Step 1: Start Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in process
        _errorMessage.value = 'Google sign-in was cancelled by the user.';
        _inProgress.value = false;
        update();
        return false;
      }

      // Step 2: Get authentication details from Google account
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Step 3: Create a Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 4: Sign in to Firebase
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      // Step 5: Get the Firebase ID token
      final String? idToken = await userCredential.user?.getIdToken(true);
      if (idToken == null) {
        _errorMessage.value = 'Failed to retrieve Firebase ID token.';
        _inProgress.value = false;
        update();
        return false;
      }

      // Debug logging
      final String? name = userCredential.user?.displayName ?? 'Unknown';
      final String? email = userCredential.user?.email ?? 'Unknown';
      print('✅ Firebase ID Token: $idToken');
      print('👤 Name: $name');
      print('📧 Email: $email');

      // Decode token for debugging (optional)
      try {
        final parts = idToken.split('.');
        final payload = json.decode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
        );
        print('Issuer: ${payload['iss']}');
      } catch (e) {
        print('⚠️ Failed to decode ID token: $e');
      }

      // Step 6: Send Firebase ID token to backend
      final Map<String, dynamic> requestBody = {
        'email': email,
        'idToken': idToken, // Renamed from fcmToken for clarity
        'provider': 'google',
      };

      final NetworkResponse response = await Get.find<NetworkCaller>()
          .postRequest(Urls.googleAuthUrl, body: requestBody);

      // Step 7: Handle backend response
      if (response.isSuccess && response.responseData['data'] != null) {
        final String? accessToken =
            response.responseData['data']['accessToken'];
        if (accessToken == null) {
          _errorMessage.value = 'Backend did not return a valid access token.';
          _inProgress.value = false;
          update();
          return false;
        }

        // Save backend access token
        await StorageUtil.saveData(StorageUtil.userAccessToken, accessToken);
        _token.value = accessToken;

        // Fetch user profile
        final bool profileFetched = await profileController.getMyProfile();
        if (!profileFetched) {
          _errorMessage.value = 'Failed to fetch user profile.';
          _inProgress.value = false;
          update();
          return false;
        }

        // Navigate to main screen
        Get.offAll(() => MainButtonNavbarScreen());
        _inProgress.value = false;
        update();
        return true;
      } else {
        // Handle backend errors
        await _googleSignIn.signOut();
        await _firebaseAuth.signOut();
        _inProgress.value = false;
        update();
        return false;
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      _errorMessage.value = _mapFirebaseError(e.code);
      print('❌ Firebase Error: ${e.code} - ${e.message}');
      _inProgress.value = false;
      update();
      return false;
    }
  }

  /// Sign out from Google and Firebase
  Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();

      _token.value = '';
      _errorMessage.value = '';
      update();
      return true;
    } catch (e) {
      _errorMessage.value = 'Sign-out failed: $e';
      print('❌ Sign-Out Error: $e');
      update();
      return false;
    }
  }

  /// Map Firebase error codes to user-friendly messages
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different credential.';
      case 'invalid-credential':
        return 'Invalid Google credentials. Please try again.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'operation-not-allowed':
        return 'Google Sign-In is not enabled for this app.';
      default:
        return 'Firebase authentication failed. Please try again.';
    }
  }
}
