import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static SharedPreferences? _sharedPreferences;
  static FlutterSecureStorage? storage;

  static AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences!;
  }


  static const String _prefIsUserLoggedIn = 'isUserLoggedIn';
  static const String _prefFirstName = 'firstName';
  static const String _prefLastName = 'lastName';
  static const String _prefEmail = 'email';
  static const String _prefEmailVerified = 'emailVerified';
  static const String _prefPassword = 'password';
  static const String _prefPhoneNumberCode = 'phoneNumberCode';
  static const String _prefPhoneNumber = 'phoneNumber';
  static const String _prefAccessToken = 'accessToken';
  static const String _prefDeviceToken = 'device_token';
  static const String _prefExtVersion = 'extVersion';
  static const String _prefPackageName = 'packageName';
  static const String _prefIntVersion = 'intVersion';
  static const String _prefIsGuestUser = 'isGuestUser';
  static const String _prefIsAllowGuestUser = 'isAllowGuestUser';
  static const String _prefOrganizationFlag = 'organizationFlag';
  static const String _prefAffiliateUrl = 'affiliateUrl';
  static const String _prefSupport = 'support';
  static const String _prefPrivacyPolicy = 'pricacyPolicy';
  static const String _prefFaq = 'faq';
  static const String _prefTnC = 'tnc';
  static const String _prefIsLoginScreenOpen = 'isLoginScreenOpen';
  static const String _prefOrgRestrictionFlagged = 'orgRestrictionFlagged';
  static const String _prefRestrictSignup = 'restrict_signup';


  static setIsUserLoggedIn(bool loggedIn) async {
    await _sharedPreferences!.setBool(_prefIsUserLoggedIn, loggedIn);
  }

  static bool getIsUserLoggedIn() =>
      _sharedPreferences!.getBool(_prefIsUserLoggedIn) ?? false;


  static setIsGuestUser(bool isGuestUser) async {
    await _sharedPreferences!.setBool(_prefIsGuestUser, isGuestUser);
  }

  static bool getIsGuestUser() =>
      _sharedPreferences!.getBool(_prefIsGuestUser) ?? false;


  static setIsAllowGuestUser(bool isAllowGuestUser) async {
    await _sharedPreferences!.setBool(_prefIsAllowGuestUser, isAllowGuestUser);
  }

  static bool getIsAllowGuestUser() =>
      _sharedPreferences!.getBool(_prefIsAllowGuestUser) ?? false;

  static setOrganizationFlag(bool organizationFlag) {
    _sharedPreferences!.setBool(_prefOrganizationFlag, organizationFlag);
  }

  static bool getOrganizationFlag() =>
      _sharedPreferences!.getBool(_prefOrganizationFlag) ?? true;

  static setAccessToken(String accessToken) async {
    await _sharedPreferences!.setString(_prefAccessToken, accessToken);
  }

  static String getAccessToken() => _sharedPreferences!.getString(_prefAccessToken) ?? '';

  static setDeviceToken(String deviceToken) async {
    await _sharedPreferences!.setString(_prefDeviceToken, deviceToken);
  }

  static String getDeviceToken() => _sharedPreferences!.getString(_prefDeviceToken) ?? '';


  static setSupportUrl(String supportUrl) async {
    await _sharedPreferences!.setString(_prefSupport, supportUrl);
  }

  static String getSupportUrl()  => _sharedPreferences!.getString(_prefSupport) ?? '';


  static setPrivacyPolicyUrl(String privacyPolicyUrl) async {
    await _sharedPreferences!.setString(_prefPrivacyPolicy, privacyPolicyUrl);
  }

  static String getPrivacyPolicyUrl()  => _sharedPreferences!.getString(_prefPrivacyPolicy) ?? '';


  static setTnCUrl(String tncUrl) async {
    await _sharedPreferences!.setString(_prefTnC, tncUrl);
  }

  static String getTnCUrl()  => _sharedPreferences!.getString(_prefTnC) ?? '';

  static setAffiliateUrl(String affiliateUrl) async {
    await _sharedPreferences!.setString(_prefAffiliateUrl, affiliateUrl);
  }

  static String getAffiliateUrl()  => _sharedPreferences!.getString(_prefAffiliateUrl) ?? '';

  static setIsLoginScreenOpen(bool isLoginScreenOpen) async {
    await _sharedPreferences!.setBool(_prefIsLoginScreenOpen, isLoginScreenOpen);
  }

  static bool getIsLoginScreenOpen()  => _sharedPreferences!.getBool(_prefIsLoginScreenOpen) ?? false;

  static setOrgRestrictionFlagged(bool orgRestrictionFlagged) async {
    await _sharedPreferences!.setBool(_prefOrgRestrictionFlagged, orgRestrictionFlagged);
  }

  static bool getOrgRestrictionFlagged()  => _sharedPreferences!.getBool(_prefOrgRestrictionFlagged) ?? false;
  static setRestrictSignupFlagged(String orgRestrictionFlagged) async {
    await _sharedPreferences!.setString(_prefOrgRestrictionFlagged, orgRestrictionFlagged);
  }

  static String getRestrictSignupFlagged()  => _sharedPreferences!.getString(_prefOrgRestrictionFlagged) ?? "True";

  static setRestrictSignupFlag(bool restrictSignup) async {
    await _sharedPreferences!.setBool(_prefRestrictSignup, restrictSignup);
  }

  static bool getRestrictSignupFlag()  => _sharedPreferences!.getBool(_prefRestrictSignup) ?? false;

  static setFAQUrl(String faqUrl) async {
    await _sharedPreferences!.setString(_prefFaq, faqUrl);
  }

  static String getFAQUrl()  => _sharedPreferences!.getString(_prefFaq) ?? '';


  static setFirstName(String firstName) async {
    await _sharedPreferences!.setString(_prefFirstName, firstName);
  }
  static String getFirstName() => _sharedPreferences!.getString(_prefFirstName) ?? '';


  static setLastName(String lastName) async {
    await _sharedPreferences!.setString(_prefLastName, lastName);
  }
  static String getLastName() => _sharedPreferences!.getString(_prefLastName) ?? '';

  static setEmail(String email) async {
    await _sharedPreferences!.setString(_prefEmail, email);
  }
  static String getEmail() => _sharedPreferences!.getString(_prefEmail) ?? '';

  static setPassword(String password) async {
    await _sharedPreferences!.setString(_prefPassword, password);
  }
  static String getPassword() => _sharedPreferences!.getString(_prefPassword) ?? '';

  static setEmailVerified(bool emailVerified) async {
    await _sharedPreferences!.setBool(_prefEmailVerified, emailVerified);
  }
  static bool getEmailVerified() => _sharedPreferences!.getBool(_prefEmailVerified) ?? false;

  static setPhoneNumber(String phoneNumber) async {
    await _sharedPreferences!.setString(_prefPhoneNumber, phoneNumber);
  }
  static String getPhoneNumber() => _sharedPreferences!.getString(_prefPhoneNumber) ?? '';

  static setPhoneNumberCode(String phoneNumberCode) async {
    await _sharedPreferences!.setString(_prefPhoneNumberCode, phoneNumberCode);
  }
  static String getPhoneNumberCode() => _sharedPreferences!.getString(_prefPhoneNumberCode) ?? '';

  static setIntVersion(String version) async {
    await _sharedPreferences!.setString(_prefIntVersion, version);
  }
  static String getIntVersion() => _sharedPreferences!.getString(_prefIntVersion) ?? '';

  static setExtVersion(String version) async {
    await _sharedPreferences!.setString(_prefExtVersion, version);
  }
  static String getExtVersion() => _sharedPreferences!.getString(_prefExtVersion) ?? '';

  static setPackageName(String packageName) async {
    await _sharedPreferences!.setString(_prefPackageName, packageName);
  }
  static String getPackageName() => _sharedPreferences!.getString(_prefPackageName) ?? '';

  static Future<String> getSecureString(String key,
      {String defaultValue = ""}) async {
    return await storage!.read(key: key) ?? defaultValue;
  }

  static Future<void> setSecureString(String key, String value) async =>
      await storage!.write(key: key, value: value);

  // Delete
  static Future<bool> remove(String key) async =>
      await _sharedPreferences!.remove(key);

  static Future<void> clear() async {
    for (final key in _sharedPreferences!.getKeys()) {
      if (key != _prefDeviceToken) {
        await _sharedPreferences!.remove(key);
      }
    }
    await storage!.delete(key: _prefAccessToken);

    //await _sharedPreferences.clear();
  }


}
