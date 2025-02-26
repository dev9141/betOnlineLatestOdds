import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import '../../generated/l10n.dart';
import '../../utils/helper/app_url.dart';
import '../../utils/helper/helper.dart';
import '../../utils/helper/log.dart';
import '../entity/account/user.dart';
import '../local/preference_manager.dart';
import '../remote/api_error.dart';
import '../remote/api_response.dart';

String screenType = '';

class UserRepository {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Future<String?> getDevice() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.model;
    }
    return null;
  }
  Future<String> getAccessToken() async {
    return await PreferenceManager.getAccessToken();
  }

  setAccessToken(String accessToken) {
    PreferenceManager.setAccessToken(accessToken);
  }

  setIsUserLoggedIn(bool loggedIn) {
    PreferenceManager.setIsUserLoggedIn(loggedIn);
  }

  setIsEmailVerified(bool isVerified) {
    PreferenceManager.setEmailVerified(isVerified);
  }
  setIsGuestUser(bool loggedIn) {
    PreferenceManager.setIsGuestUser(loggedIn);
  }

  bool getIsUserLoggedIn() {
    return PreferenceManager.getIsUserLoggedIn();
  }
  bool getIsGuestUser() {
    return PreferenceManager.getIsGuestUser();
  }

  String getDeviceToken() {
    return PreferenceManager.getDeviceToken();
  }

  setDeviceToken(String deviceToken) {
    PreferenceManager.setDeviceToken(deviceToken);
  }

  setEmail(String email) {
    PreferenceManager.setEmail(email);
  }


  setPassword(String password) {
    PreferenceManager.setPassword(password);
  }

  setPhoneNumber(String phoneNumber) {
    PreferenceManager.setPhoneNumber(phoneNumber);
  }

  setPhoneNumberCode(String phoneNumberCode) {
    PreferenceManager.setPhoneNumberCode(phoneNumberCode);
  }

  String getFirstName() {
    return PreferenceManager.getFirstName();
  }

  String getLastName() {
    return PreferenceManager.getLastName();
  }

  String getEmail() {
    return PreferenceManager.getEmail();
  }

  Future<Object> login(User userData) async {
    final String url = AppUrl.login;
    var uri = Uri.parse(url);

    var response = await http.Client().post(
      uri,
      headers: await Helper.getHeaders(hasToken: false),
      body: {
        'email': userData.email,
        'password': userData.password,
        'device_name': await Helper.getDeviceType()
      },
    );
    logPrint(
        "LOGIN  Response:  ${response.statusCode} & Response Body  = ${response.body}");
    if (response.statusCode == AppUrl.successStatusCode) {
      if (json.decode(response.body) != null) {
        final objJsonObject = json.decode(response.body);
        User user = User.fromMap(objJsonObject['user']);
        String accessToken = objJsonObject['access_token'];
        setAccessToken(accessToken);
        setEmail(user.email);
        setPassword(userData.password);
        setIsUserLoggedIn(true);
        if(user.emailVerifiedAt != null && user.emailVerifiedAt.isNotEmpty ){
          setIsEmailVerified(true);
        }
        return APIResponse(
            null, "Login Successfully...", true);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else if (response.statusCode == AppUrl.parsingErrorStatusCode) {
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['errors'] != null) {
        message = List.from(objJsonObject['errors'])
            .map((element) => element['message'])
            .join("\n");
        return APIError(
            response: null, status: response.statusCode, message: message);
      }else if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else if (response.statusCode == AppUrl.validationErrorStatusCode) {
      String? emailVerifiedAt;
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['content'] != null) {
        emailVerifiedAt = objJsonObject['content']['emailVerifiedAt'];
      }
      if (objJsonObject['content'] != null) {
        return APIError(
            response: emailVerifiedAt,
            status: response.statusCode,
            message: message);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else {
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
  }

  Future<Object> loginGuest(User user) async {
    final device = await getDevice();
    print("Device: $device");
    final String url = AppUrl.login;
    var uri = Uri.parse(url);

    var response = await http.Client().post(
      uri,
      headers: await Helper.getHeaders(hasToken: false),
      body: {
        'email': user.email,
        'password': user.password,
        'device_name': await Helper.getDeviceType()
      },
    );
    logPrint(
        "loginGuest  Response:  ${response.statusCode} & Response Body  = ${response.body}");
    if (response.statusCode == AppUrl.successStatusCode) {
      if (json.decode(response.body) != null) {
        final objJsonObject = json.decode(response.body);
        User user = User.fromMap(objJsonObject['user']);
        String accessToken = objJsonObject['access_token'];
        setEmail(user.email);
        setAccessToken(accessToken);
        setEmail(user.email);
        setIsUserLoggedIn(true);
        return APIResponse(
            null, "Login Successfully...", true);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    } else if (response.statusCode == AppUrl.parsingErrorStatusCode) {
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['errors'] != null) {
        message = List.from(objJsonObject['errors'])
            .map((element) => element['message'])
            .join("\n");
        return APIError(
            response: null, status: response.statusCode, message: message);
      }else if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    } else if (response.statusCode == AppUrl.validationErrorStatusCode) {
      String? emailVerifiedAt;
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['content'] != null) {
        emailVerifiedAt = objJsonObject['content']['emailVerifiedAt'];
      }
      if (objJsonObject['content'] != null) {
        return APIError(
            response: emailVerifiedAt,
            status: response.statusCode,
            message: message);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    } else {
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
  }

  Future<Object> resetPassword(User user) async {

    final String url = AppUrl.resetPassword;
    var uri = Uri.parse(url);

    var response = await http.Client().post(
      uri,
      headers: await Helper.getHeaders(hasToken: false),
      body: {
        'email': user.email,
        'password': user.password,
        'token': user.code
      },
    );
    logPrint(
        "resetPassword  Response:  ${response.statusCode} & Response Body  = ${response.body}");
    if (response.statusCode == AppUrl.successStatusCode) {
      if (json.decode(response.body) != null) {
        return APIResponse(
            null, "Password reset Successfully", true);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    } else if (response.statusCode == AppUrl.parsingErrorStatusCode) {
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['errors'] != null) {
        message = List.from(objJsonObject['errors'])
            .map((element) => element['message'])
            .join("\n");
        return APIError(
            response: null, status: response.statusCode, message: message);
      }else if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    } else if (response.statusCode == AppUrl.validationErrorStatusCode) {
      String? emailVerifiedAt;
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['content'] != null) {
        emailVerifiedAt = objJsonObject['content']['emailVerifiedAt'];
      }
      if (objJsonObject['content'] != null) {
        return APIError(
            response: emailVerifiedAt,
            status: response.statusCode,
            message: message);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    } else {
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
  }
  Future<Object> deleteAccount(String password) async {

    final String url = AppUrl.deleteAccount;
    var uri = Uri.parse(url);

    var response = await http.Client().delete(
      uri,
      headers: await Helper.getHeaders(hasToken: false),
      body: {
        'password': password,
      },
    );
    logPrint(
        "deleteAccount  Response:  ${response.statusCode} & Response Body  = ${response.body}");
    if (response.statusCode == AppUrl.successStatusCode) {
        return APIResponse(
            null, "Account delete Successfully...", true);

    } else if (response.statusCode == AppUrl.parsingErrorStatusCode) {
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['errors'] != null) {
        message = List.from(objJsonObject['errors'])
            .map((element) => element['message'])
            .join("\n");
        return APIError(
            response: null, status: response.statusCode, message: message);
      }else if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    } else if (response.statusCode == AppUrl.validationErrorStatusCode) {
      String? emailVerifiedAt;
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['content'] != null) {
        emailVerifiedAt = objJsonObject['content']['emailVerifiedAt'];
      }
      if (objJsonObject['content'] != null) {
        return APIError(
            response: emailVerifiedAt,
            status: response.statusCode,
            message: message);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    } else {
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
  }

  Future<Object> loginAsGuest() async {
    final device = await Helper.getDeviceModel();
    final String url = AppUrl.loginAsGuest;
    var uri = Uri.parse(url);

    var response = await http.Client().post(
      uri,
      headers: await Helper.getHeaders(hasToken: false),
      body: {
        'device_name': device,
      },
    );
    logPrint(
        "loginAsGuest  Response:  ${response.statusCode} & Response Body  = ${response.body}");
    if (response.statusCode == AppUrl.successStatusCode) {
      if (json.decode(response.body) != null) {
        final objJsonObject = json.decode(response.body);
        User user = User.fromMap(objJsonObject['user']);
        String accessToken = objJsonObject['access_token'];
        setAccessToken(accessToken);
        setEmail(user.email);
        setIsUserLoggedIn(true);
        setIsGuestUser(true);
        return APIResponse(
            null, "Login Successfully...", true);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else if (response.statusCode == AppUrl.parsingErrorStatusCode) {
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['errors'] != null) {
        message = List.from(objJsonObject['errors'])
            .map((element) => element['message'])
            .join("\n");
        return APIError(
            response: null, status: response.statusCode, message: message);
      }else if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else if (response.statusCode == AppUrl.validationErrorStatusCode) {
      String? emailVerifiedAt;
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['content'] != null) {
        emailVerifiedAt = objJsonObject['content']['emailVerifiedAt'];
      }
      if (objJsonObject['content'] != null) {
        return APIError(
            response: emailVerifiedAt,
            status: response.statusCode,
            message: message);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else {
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
  }

  String formatPhoneNumber(String phone) {
    return '${phone.substring(0, 3)}-${phone.substring(3, 6)}-${phone.substring(6, 10)}';
  }

  Future<Object> register(User user) async {
    final String url = AppUrl.register;
    var uri = Uri.parse(url);

    var response = await http.Client().post(
      uri,
      headers: await Helper.getHeaders(hasToken: false),
      body: {
        "email": user.email,
        "password": user.password,
        "device_name": Helper.getDeviceType(),
        "username": user.email,
        "first_name": user.firstName,
        "last_name": user.lastName,
        "dob": user.dob,
        "phone": user.phoneNumber,
      },
    );
    logPrint("signup  response ${response.statusCode} $url,  ${response.body}");
    if (response.statusCode == AppUrl.successStatusCode) {
      if (json.decode(response.body) != null) {
        final objJsonObject = json.decode(response.body);
        User user = User.fromMap(objJsonObject['user']);
        String accessToken = objJsonObject['access_token'];
        setAccessToken(accessToken);
        setEmail(user.email);
        setIsUserLoggedIn(true);
        return APIResponse(
            null, "Registration successfully done", true);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else if (response.statusCode == AppUrl.parsingErrorStatusCode) {
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['errors'] != null) {
        message = List.from(objJsonObject['errors'])
            .map((element) => element['message'])
            .join("\n");
        return APIError(
            response: null, status: response.statusCode, message: message);
      }else if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else if (response.statusCode == AppUrl.validationErrorStatusCode2) {
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['message'] != null) {
        message = objJsonObject['message'];
      }
      if (objJsonObject['message'] != null) {
        return APIError(
            response: message,
            status: response.statusCode,
            message: message);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else {
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
  }

  Future<Object> registerConfirmation(User user) async {
    String url = AppUrl.registerConfirmation;
    var uri = Uri.parse(url);


    var response = await http.Client().post(
      uri,
      headers: await Helper.getHeaders(hasToken: true),
    );

    logPrint("registerConfirmation  response ${response.statusCode} $url,  ${response.body}");
    if (response.statusCode == AppUrl.successStatusCode) {
        return APIResponse(
            null, "Register Confirmation successfully done", true);
    }
    else if (response.statusCode == AppUrl.parsingErrorStatusCode) {
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['errors'] != null) {
        message = List.from(objJsonObject['errors'])
            .map((element) => element['message'])
            .join("\n");
        return APIError(
            response: null, status: response.statusCode, message: message);
      }else if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else if (response.statusCode == AppUrl.validationErrorStatusCode) {
      String? emailVerifiedAt;
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['content'] != null) {
        emailVerifiedAt = objJsonObject['content']['emailVerifiedAt'];
      }
      if (objJsonObject['content'] != null) {
        return APIError(
            response: emailVerifiedAt,
            status: response.statusCode,
            message: message);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else {
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
  }
  Future<Object> sendTokenToServer() async {
    final String url = AppUrl.setFirebaseDeviceToken;
    var uri = Uri.parse(url);

    var response = await http.Client().post(
      uri,
      headers: await Helper.getHeaders(hasToken: true),
      body: {
        "device_token": PreferenceManager.getDeviceToken()
      },
    );
    logPrint("sendTokenToServer  response ${response.statusCode} $url,  ${response.body}");
    if (response.statusCode == AppUrl.successStatusCode) {
      if (json.decode(response.body) != null) {
        setIsUserLoggedIn(true);
        return APIResponse(
            null, "", true);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else {
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
  }
  Future<Object> verifyEmail(String email) async {
    final String url = AppUrl.verifyEmail;
    var uri = Uri.parse(url);

    var response = await http.Client().post(
      uri,
      headers: await Helper.getHeaders(hasToken: true),
      /*body: {
        "email": email
      },*/
    );
    logPrint("verifyEmail  response ${response.statusCode} $url ${response.body}");
    if (response.statusCode == AppUrl.successStatusCode) {
      if (json.decode(response.body) != null) {
        final objJsonObject = json.decode(response.body);
        return APIResponse(
            null, "Link for email verification send on your email address", true);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else if (response.statusCode == AppUrl.parsingErrorStatusCode) {
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['errors'] != null) {
        message = List.from(objJsonObject['errors'])
            .map((element) => element['message'])
            .join("\n");
        return APIError(
            response: null, status: response.statusCode, message: message);
      }else if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else if (response.statusCode == AppUrl.validationErrorStatusCode) {
      String? emailVerifiedAt;
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['content'] != null) {
        emailVerifiedAt = objJsonObject['content']['emailVerifiedAt'];
      }
      if (objJsonObject['content'] != null) {
        return APIError(
            response: emailVerifiedAt,
            status: response.statusCode,
            message: message);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else {
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
  }

/*
  Future<Object> emailVerification(String email, String token) async {
    String url = AppUrl.accountVerification;
    final client = http.Client();

    final response = await client.post(
      Uri.parse(url),
      headers: await Helper.getHeaders(hasToken: false),
      body: {"email": email, "token": token},
    );

    if (response.statusCode == AppUrl.successStatusCode) {
      if (json.decode(response.body) != null) {
        final objJsonObject = json.decode(response.body);
        User user = User.fromMap(objJsonObject['content']);
        setAccessToken(user.accessToken);
        setEmail(user.email);
        setIsUserLoggedIn(true);
        if (objJsonObject['message'] != null) {
          return APIResponse(
              null, json.decode(response.body)['message'] as String, true);
        } else {
          return APIResponse(null, S.current.err_msg, false);
        }
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    } else if (response.statusCode == AppUrl.validationErrorStatusCode) {
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['errors'] != null) {
        message = List.from(objJsonObject['errors'])
            .map((element) => element['message'])
            .join("\n");
      }
      if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: message);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    } else {
      return APIError(
          response: null,
          status: response.statusCode,
          message: S.current.err_msg);
    }
  }
*/

  Future<Object> forgotPassword(User user) async {
    String url = AppUrl.forgotPassword;
    final client = http.Client();

    final response = await client.post(
      Uri.parse(url),
      headers: await Helper.getHeaders(hasToken: false),
      body: {
        "email": user.email,
      },
    );
    logPrint("resetToken Response: ${response.statusCode} ${response.body}");
    if (response.statusCode == AppUrl.successStatusCode) {
      if (json.decode(response.body) != null) {
        final objJsonObject = json.decode(response.body);

        if (objJsonObject['result'] != null) {
          if (objJsonObject['result'].toString().toLowerCase().startsWith("c")) {
            return APIResponse(
                null, "Code send on your email, Please check your email", true);
          } else {
            return APIResponse(null, S.current.err_msg, false);
          }
        } else {
          return APIResponse(null, S.current.err_msg, false);
        }
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    } else if (response.statusCode == AppUrl.parsingErrorStatusCode) {
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['errors'] != null) {
        message = List.from(objJsonObject['errors'])
            .map((element) => element['message'])
            .join("\n");
        return APIError(
            response: null, status: response.statusCode, message: message);
      } else
      if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    } else if (response.statusCode == AppUrl.validationErrorStatusCode) {
      String? emailVerifiedAt;
      String message = "";
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['content'] != null) {
        emailVerifiedAt = objJsonObject['content']['emailVerifiedAt'];
      }
      if (objJsonObject['content'] != null) {
        return APIError(
            response: emailVerifiedAt,
            status: response.statusCode,
            message: message);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    } else {
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
  }

  Future<Object> logout() async {
    String url = AppUrl.logout;
    final client = http.Client();
    final response = await client.post(Uri.parse(url),
        headers: await Helper.getHeaders(hasToken: true));
    logPrint("LOGOUT Response: ${response.statusCode}");

    if (response.statusCode == AppUrl.successStatusCode) {
      if (json.decode(response.body) != null) {
          String deviceTokenLogin = await getDeviceToken();
          PreferenceManager.clear();
          setDeviceToken(deviceTokenLogin);
          return APIResponse(
              null, "", true);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else if (response.statusCode == AppUrl.validationErrorStatusCode) {
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['message'] != null) {
        return APIError(
            response: null,
            status: response.statusCode,
            message: objJsonObject['message'] as String);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
    else if (response.statusCode == AppUrl.unautharized) {
      setIsUserLoggedIn(false);
      String deviceTokenLogin = await getDeviceToken();
      PreferenceManager.clear();
      UserRepository().setDeviceToken(deviceTokenLogin);
      return APIError(
          response: null,
          status: response.statusCode,
          message: S.current.err_msg);
    } else {
      final objJsonObject = json.decode(response.body);
      if (objJsonObject['message'] != null) {
        return APIError(
            response: null, status: response.statusCode, message: objJsonObject['message']);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    }
  }

/*
  Future<Object> editProfile(User user) async {
    final String url = AppUrl.editProfile;
    http.MultipartFile? multipartFile;
    var uri = Uri.parse(url);
    // create multipart request
    var request1 = http.MultipartRequest("POST", uri);
    try {
      // multipart that takes file

      // add file to multipart
      if (multipartFile != null) {
        request1.files.add(multipartFile);
      }
      request1.fields.addAll(user.toMap());
      request1.headers.addAll(await Helper.getHeaders(hasToken: true));

      var request = await request1.send();
      var response = await http.Response.fromStream(request);
      logPrint("editProfile  response ${response.statusCode} $url ${response.body}");
      if (response.statusCode == AppUrl.successStatusCode) {
        if (json.decode(response.body) != null) {
          final objJsonObject = json.decode(response.body);
          User user = User.fromMap(objJsonObject['content']);
          setEmail(user.email);
          logPrint("editProfile  accessToken $objJsonObject");
          return APIResponse(user, json.decode(response.body)['message'] as String, true);
        } else {
          return APIError(
              response: null,
              status: response.statusCode,
              message: S.current.err_msg);
        }
      } else if (response.statusCode == AppUrl.validationErrorStatusCode) {
        String message = "";
        final objJsonObject = json.decode(response.body);
        if (objJsonObject['errors'] != null) {
          message = List.from(objJsonObject['errors'])
              .map((element) => element['message'])
              .join("\n");
        }
        if (objJsonObject['message'] != null) {
          return APIError(
              response: null, status: response.statusCode, message: message);
        } else {
          return APIError(
              response: null,
              status: response.statusCode,
              message: S.current.err_msg);
        }
      } else if (response.statusCode == AppUrl.unautharized) {
        setIsUserLoggedIn(false);
        String deviceTokenLogin = await getDeviceToken();
        PreferenceManager.clear();
        setDeviceToken(deviceTokenLogin);
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      } else {
        return APIError(
            response: null,
            status: response.statusCode,
            message: S.current.err_msg);
      }
    } catch (e) {
      return APIError(response: null, status: 0, message: S.current.err_msg);
    }
  }
*/

}
