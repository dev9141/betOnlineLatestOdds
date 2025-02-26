import 'package:shared_preferences/shared_preferences.dart';

class AppUrl {
  static const String apiKey = 'qXpzsZGWwntGcgDl7ZGH6j0DmjUXAk5RJFzmypGrNr';
      /*'qXpzsZGWwntGcgDl7ZGH6j0DmjUXAk5RJFzmypGrNr';*/

  static String _api_base_url = "https://bolapps.5monkeydevelopments.com/api/";
  //static String _api_base_url = "https://game.bu-nba.com/api/";
  //static String _api_base_url = "https://game.5monkeygames.com/api/";

  static String terms_service = "https://www.google.com/";
  static String privacy_policy = "https://www.google.com/";

  static String getAPIBaseURL() {
    return _api_base_url;
  }

  static setAPIBaseURL(String url) async {
    _api_base_url = url;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('api_base_url', url);
  }

  static String login = "${getAPIBaseURL()}auth/login";
  static String deleteAccount = "${getAPIBaseURL()}auth/delete";
  static String loginAsGuest = "${getAPIBaseURL()}auth/guest";
  static String register = "${getAPIBaseURL()}auth/createBolUser";
  static String registerConfirmation = "${getAPIBaseURL()}auth/bolrealplay";
  static String setFirebaseDeviceToken = "${getAPIBaseURL()}set_firebase_token";
  static String forgotPassword = "${getAPIBaseURL()}auth/forgot";
  static String logout = "${getAPIBaseURL()}auth/logout";
  static String resetPassword = "${getAPIBaseURL()}auth/reset";
  static String configuration = "${getAPIBaseURL()}configuration";
  static String pubConfiguration = "${getAPIBaseURL()}pub-configuration";
  static String verifyEmail = "${getAPIBaseURL()}auth/resend";
  static String signUpWebViewUrl = 'https://record.betonlineaffiliates.ag/_on42CIkH5pz-a8CTELPmZWNd7ZgqdRLk/1/';

  static const int successStatusCode = 200;
  static const int validationErrorStatusCode = 222;
  static const int validationErrorStatusCode2 = 422;
  static const int parsingErrorStatusCode = 400;
  static const int unautharized = 401;
  static const int forceLogoutStatusCode = 403;
  static const int requestedResourceNotFound = 404;
  static const int internalServer = 500;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
}
