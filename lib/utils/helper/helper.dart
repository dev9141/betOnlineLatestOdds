import 'dart:io';

import 'package:bet_online_latest_odds/data/local/preference_manager.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../data/repositories/user_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../main.dart';
import 'app_url.dart';
import 'enumeration.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import 'log.dart';


class Helper {
  static bool isUpdatePopupShown = true;
  static DateTime currentBackPressTime = DateTime(0);

  static Future<bool> isInternetConnectionAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<bool> isInternetConnectionAvailableOne() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        final result = await InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        return false;
      }
    }
    return false; // No network connection
  }

  static Future<bool> isInternetAvailable() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static void hideKeyBoard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    return (!regex.hasMatch(value)) ? false : true;
  }

  static bool isValidPassword(String value) {
    String pattern =
        "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[\$@#%_^&+='!~()-*.?/,><:|])(?=\\S+).{5,}";
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value) || value == "") {
      return false;
    } else {
      return true;
    }
  }

  static Future<Map<String, String>> getHeaders({bool hasToken = true}) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'app-api-key': AppUrl.apiKey,
      'deviceType': getDeviceType()
    };
    if (hasToken) {
      headers['Authorization'] = 'Bearer ${await UserRepository().getAccessToken()}';
    }

    return headers;
  }
  static const platform = MethodChannel('my_flutter_app/channel');
  static Future<void> openBrowser(String webURl) async {
    if (Platform.isIOS) {
      try {
        await platform.invokeMethod('openExternalBrowser', {'url': webURl});
        print("Browser opened successfully");
      } on PlatformException catch (e) {
        print("Error: ${e.message}");
      }
    } else {
      _launchInWebView(webURl);
    }
  }

  static Future<void> _launchInWebView(String Urls) async {
    //  print('Urls===========>$Urls');
    var url = Uri.parse(Urls);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      await launchUrl(url);
    }
  }


  static String getDeviceType() {
    String deviceType;
    if (Platform.isIOS) {
      deviceType = describeEnum(DeviceType.ios);
    } else {
      deviceType = describeEnum(DeviceType.android);
    }
    return deviceType;
  }

  static Future<String?> getDeviceModel() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.model;
    } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await DeviceInfoPlugin().iosInfo;
    return iosInfo.model;
    }
    return null;
  }

  static AppBar commonAppBar(
      {String title = '',
      bool visibleLeading = false,
      Widget? leading,
      VoidCallback? callbackLeading,
      bool? visibleTrailing,
      Widget? trailing,
      VoidCallback? callbackTrailing}) {
    return AppBar(
      toolbarHeight: 60,
      elevation: 0,
      leadingWidth: 60,
      leading: visibleLeading
          ? GestureDetector(
              onTap: callbackLeading,
              child: leading,
            )
          : null,
      automaticallyImplyLeading: visibleLeading,
      centerTitle: true,
      title: Text(
        title,
      ),
      actions: [
        if (visibleTrailing != null && visibleTrailing)
          GestureDetector(
            onTap: callbackTrailing,
            child: trailing,
          ),
      ],
    );
  }

  static bool isNumeric(String s) => s.isNotEmpty && double.tryParse(s) != null;

/*  String getInitialCountryCode(BuildContext context) {
    String code = Platform.localeName.split('_')[1];
    return code;
  }*/

  static String convertTOCapital(String str) {
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }

  static bool isDarkMode(){
    print("isDarkTheme 123 ${isDarkTheme.value}");
    return isDarkTheme.value;
  }

  static showBuildVersion() async {
    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
      PreferenceManager.setExtVersion(packageInfo.buildNumber);
      PreferenceManager.setIntVersion(packageInfo.version);
      PreferenceManager.setPackageName(packageInfo.packageName);
    }).onError((error, stackTrace) {
      logPrint("ERROR_VERSION: ${error.toString()}");
    });
  }
}

typedef StringCallback = void Function(String);