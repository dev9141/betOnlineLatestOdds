import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

import '../data/entity/account/user.dart';
import '../data/repositories/configuration_repository.dart';
import '../data/repositories/user_repository.dart';

class ConfigurationController extends StateXController  {

  final ConfigurationRepository userRepository = ConfigurationRepository();

  bool isApiCall = false;
  bool isLoading = true;
  User user = User();
  late GlobalKey<ScaffoldState> scaffoldKey;
  bool isInternetAvailable = true;
  ConfigurationController() {
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  Future<Object> configuration() async {
    return await userRepository.configuration();
  }

  Future<Object> pubConfiguration() async {
    return await userRepository.pubConfiguration();
  }
}