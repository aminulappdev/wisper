import 'package:wisper/app/modules/profile/widget/recommendation_widget.dart';

class Urls {
  // =========================================== Base ================================================ //
  // static const String _baseUrl = 'http://10.10.10.17:5005/api/v1';
  // static const String socketUrl = 'http://10.10.10.17:4000/';

  static const String _baseUrl = 'http://10.10.10.17:5000/api/v1';
  static const String socketUrl = 'http://10.10.10.17:5000';  

  // =========================================== Common ============================================== //

  // =========================================== Profile ============================================== //
  static const String personProfileUrl = '$_baseUrl/persons/profile';
  static const String businessProfileUrl = '$_baseUrl/businesses/profile';
  static const String personEditProfileUrl = '$_baseUrl/persons/profile';
  static const String businessEditProfileUrl = '$_baseUrl/businesses/profile';
  static const String personEditProfilePhotoUrl =
      '$_baseUrl/persons/profile-image';
  static const String businessEditProfilePhotoUrl =
      '$_baseUrl/businesses/profile-image';

  // =========================================== Authentication ====================================== //
  static const String signUpUrlPerson = '$_baseUrl/auths/person/signup';
  static const String signUpUrlBussiness = '$_baseUrl/auths/business/signup';
  static const String refreshTokenUrl = '$_baseUrl/auth/refresh-token';
  static const String googleAuthUrl = '$_baseUrl/auth/google-login';
  static const String otpVerifyUrl = '$_baseUrl/otps/verify';
  static const String resendOtpUrl = '$_baseUrl/otps/send';
  static const String signInUrl = '$_baseUrl/auths/login';
  static const String forgotPasswordUrl = '$_baseUrl/otps/send';
  static const String changePasswordUrl = '$_baseUrl/auths/change-password';
  static const String deleteAccountUrl = '$_baseUrl/auth/change-password';
  static const String resterPasswordUrl = '$_baseUrl/auths/reset-password';

  // =========================================== Profile Block ======================================= //
  static const String updateProfileUrl = '$_baseUrl/teachers/profile';
  static const String updateProfilImageUrl =
      '$_baseUrl/teachers/profile/change-image';
  static const String allConnectionUrl = '$_baseUrl/connections'; 
  static const String recommendationsUrl = '$_baseUrl/recommendations'; 

   static String otherProfileById(String id) {
    return '$_baseUrl/persons/$id';
  } 

    static String recommendationById(String id) {
    return '$_baseUrl/recommendations/$id';
  }

  // =========================================== Home Block ========================================== //
  static const String feedPostUrl = '$_baseUrl/posts/feed';
  static const String myFeedPostUrl = '$_baseUrl/posts/my';
  static const String postUrl = '$_baseUrl/posts';
  static const String feedJobUrl = '$_baseUrl/jobs';
  static const String roleUrl = '$_baseUrl/persons/roles';

  static String editPostId(String id) {
    return '$_baseUrl/posts/$id';
  }

  static String otherUserPostById(String id) {
    return '$_baseUrl/posts/user/$id';
  } 

 

  static String singleJobById(String id) {
    return '$_baseUrl/jobs/$id';
  }

  static String deleteNotificationById(String id) {
    return '$_baseUrl/notifications/$id';
  }

  // =========================================== Chat Block =========================================== //
  static const String createGroupUrl = '$_baseUrl/groups';
  static const String createClassUrl = '$_baseUrl/classes';
  static const String allChatsUrl = '$_baseUrl/chats/my';
  static String groupInfoById(String id) {
    return '$_baseUrl/groups/$id';
  }

  static String groupMembersById(String id) {
    return '$_baseUrl/groups/members/$id';
  }

  static String messagesById(String id) {
    return '$_baseUrl/messages/$id';
  }
}
