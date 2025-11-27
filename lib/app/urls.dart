class Urls {
  // =========================================== Base ================================================ //
  // static const String _baseUrl = 'http://10.10.10.17:5005/api/v1';
  // static const String socketUrl = 'http://10.10.10.17:4000/';

  static const String _baseUrl = 'http://10.10.10.17:5000/api/v1';
  static const String socketUrl = 'http://206.162.244.133:4001/';

  // =========================================== Common ============================================== //


  // =========================================== Profile ============================================== //
  static const String profileUrl = '$_baseUrl/persons/profile';
  static const String editProfileUrl = '$_baseUrl/persons/profile';
  static const String editProfilePhotoUrl = '$_baseUrl/persons/profile-image';
 

  // =========================================== Authentication ====================================== //
  static const String signUpUrlPerson = '$_baseUrl/auths/person/signup';
  static const String signUpUrlBussiness = '$_baseUrl/auths/business/signup';
  static const String refreshTokenUrl = '$_baseUrl/auth/refresh-token';
  static const String googleAuthUrl = '$_baseUrl/auth/google-login';
  static const String otpVerifyUrl = '$_baseUrl/otps/verify'; 
  static const String resendOtpUrl = '$_baseUrl/otps/send'; 
  static const String signInUrl = '$_baseUrl/auths/login'; 
  static const String forgotPasswordUrl = '$_baseUrl/auths/send-otp';
  static const String changePasswordUrl = '$_baseUrl/auth/change-password';
  static const String deleteAccountUrl = '$_baseUrl/auth/change-password';
  static const String resterPasswordUrl =
      '$_baseUrl/auth/reset-forgotten-password';

  // =========================================== Profile Block ======================================= //
  static const String updateProfileUrl = '$_baseUrl/teachers/profile';
  static const String updateProfilImageUrl =
      '$_baseUrl/teachers/profile/change-image';

  // =========================================== Home Block ========================================== //

  static String deleteNotificationById(String id) {
    return '$_baseUrl/notifications/$id';
  }

  // =========================================== Chat Block =========================================== //
}
