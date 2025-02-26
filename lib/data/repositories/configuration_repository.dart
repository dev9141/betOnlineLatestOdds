import 'dart:convert';
import 'package:bet_online_latest_odds/data/entity/configuration_entity.dart';
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

class ConfigurationRepository {
  Future<String> getAccessToken() async {
    return await PreferenceManager.getAccessToken();
  }

  setAccessToken(String accessToken) {
    PreferenceManager.setAccessToken(accessToken);
  }

  setIsUserLoggedIn(bool loggedIn) {
    PreferenceManager.setIsUserLoggedIn(loggedIn);
  }

  bool getIsUserLoggedIn() {
    return PreferenceManager.getIsUserLoggedIn();
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

  Future<Object> configuration() async {

    final String url = AppUrl.configuration;
    var uri = Uri.parse(url);

    logPrint("configuration ");
    print(await Helper.getHeaders(hasToken: true));
    var response = await http.Client().get(
      uri,
      headers: await Helper.getHeaders(hasToken: true),
    );
    logPrint(
        "configuration Response:  ${response.statusCode} & Response Body  = ${response.body}");
    if (response.statusCode == AppUrl.successStatusCode) {
      if (json.decode(response.body) != null) {
        final objJsonObject = json.decode(response.body);
        ConfigurationEntity configurationEntity = ConfigurationEntity.fromJson(objJsonObject);
        PreferenceManager.setPrivacyPolicyUrl(configurationEntity.data.privacyPolicyUrl);
        PreferenceManager.setOrgRestrictionFlagged(configurationEntity.orgRestrictionFlagged);
        bool result = configurationEntity.data.restrict_signup.toString().toLowerCase() == "true";
        PreferenceManager.setRestrictSignupFlag(result);
        PreferenceManager.setSupportUrl(configurationEntity.data.supportUrl);
        PreferenceManager.setFAQUrl(configurationEntity.data.faqUrl);
        PreferenceManager.setTnCUrl(configurationEntity.data.tncUrl);
        return APIResponse(
            null, "Configuration Successfully...", true, configurationEntity);
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
      return APIError(
          response: null,
          status: response.statusCode,
          message: S.current.err_msg);
    }
  }
  Future<Object> pubConfiguration() async {

    final String url = AppUrl.pubConfiguration;
    var uri = Uri.parse(url);

    var response = await http.Client().get(
      uri,
      headers: await Helper.getHeaders(hasToken: false),
    );
    logPrint(
        "pub_configuration  Response:  ${response.statusCode} & Response Body  = ${response.body}");
    if (response.statusCode == AppUrl.successStatusCode) {
      if (json.decode(response.body) != null) {
        final objJsonObject = json.decode(response.body);
        PubConfigurationEntity configurationEntity = PubConfigurationEntity.fromJson(objJsonObject);
        PreferenceManager.setPrivacyPolicyUrl(configurationEntity.data.privacyPolicyUrl);
        PreferenceManager.setSupportUrl(configurationEntity.data.supportUrl);
        PreferenceManager.setRestrictSignupFlagged(configurationEntity.data.restrict_signup == null ? "True" : configurationEntity.data.restrict_signup!);
        PreferenceManager.setFAQUrl(configurationEntity.data.faqUrl);
        PreferenceManager.setTnCUrl(configurationEntity.data.tncUrl);
        PreferenceManager.setIsAllowGuestUser(configurationEntity.data.guestUser!.toLowerCase() == "true");
        PreferenceManager.setOrganizationFlag(configurationEntity.data.organizationFlag!.toLowerCase() == "true");
        PreferenceManager.setAffiliateUrl(configurationEntity.data.affiliateUrl);

        return APIResponse(
            null, "Configuration Successfully...", true, configurationEntity);
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
      return APIError(
          response: null,
          status: response.statusCode,
          message: S.current.err_msg);
    }
  }

}
