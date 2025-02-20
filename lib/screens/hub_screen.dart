import 'package:bet_online_latest_odds/assets/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

import '../controller/ConfigurationController.dart';
import '../data/entity/configuration_entity.dart';
import '../data/remote/api_error.dart';
import '../data/remote/api_response.dart';
import '../utils/helper/alert_helper.dart';
import '../views/custom_widgets/web_view_with_js_injection.dart';

class HubScreen extends StatefulWidget {
  const HubScreen({super.key});

  @override
  StateX<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends StateX<HubScreen> {
  bool _isEmailVerified = false;
  ConfigurationEntity? _configurationEntity;
  bool _isLoading = false;
  Map<String, dynamic>? _config;

  late ConfigurationController _configurationController;

  _HubScreenState() : super(controller: ConfigurationController()) {
    _configurationController = controller as ConfigurationController;
  }

  @override
  void initState() {
    super.initState();
    _fetchConfigurationData();
  }

  Future<void> _fetchConfigurationData() async {
    setState(() {
      _isLoading = true; // Show loader when the API call starts
    });
    try {
      _configurationController.configuration().then((value) async {
        if (value is APIResponse) {
          setState(() {
            _configurationController.isApiCall = false;
          });
          _configurationEntity = value.object as ConfigurationEntity?;
          //_configurationEntity!.data.webviewUrl = "https://www.bet_online_latest_odds.com.pa/nba/";
          _extractJavascriptData();
          print("Config Response: ${_configurationEntity!.data.toJson()}");
        } else {
          if (value is APIError) {
            setState(() {
              // _isLoading = false;
              _configurationController.isApiCall = false;
            });
            AlertHelper.customSnackBar(
                context, value.message, true);
          }
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide loader in case of error
      });
      print(e);
    }
  }

  Future<void> _extractJavascriptData() async {
    try {
      final config = await _configurationEntity!.data.toJson();
      setState(() {
        _config = config;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading configuration: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_config == null) {
      return const Scaffold(
        body: Center(child: Text('Failed to load configuration')),
      );
    }
    return WebViewWithJsInjection(
      url: _config!['WEBVIEW_URL_ODDS'],
      configuration: _config!,
    );
  }

  /*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main screen content
          Center(
            child: Text(
              "HubScreen",
              style: TextStyle(color: AppColors.white, fontSize: 30),
            ),
          ),
          // Transparent black loader overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent black background
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white), // Loader color
                ),
              ),
            ),
        ],
      ),
    );
  }
*/
}
