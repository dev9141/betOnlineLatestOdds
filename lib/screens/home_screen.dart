import 'dart:convert';

import 'package:bet_online_latest_odds/assets/app_colors.dart';
import 'package:bet_online_latest_odds/controller/ConfigurationController.dart';
import 'package:bet_online_latest_odds/data/entity/configuration_entity.dart';
import 'package:bet_online_latest_odds/screens/account_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:state_extended/state_extended.dart';
import 'package:http/http.dart' as http;

import '../controller/UserController.dart';
import '../data/entity/account/user.dart';
import '../data/local/preference_manager.dart';
import '../data/remote/api_error.dart';
import '../data/remote/api_response.dart';
import '../utils/helper/alert_helper.dart';
import '../utils/helper/helper.dart';
import 'hub_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  StateX<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends StateX<HomeScreen> {
  int _currentIndex = 0;
  bool _isFABOpen = false;
  bool _isEmailVerified = false;
  User user = User();
  late UserController userController;

  _HomeScreenState() : super(controller: UserController()) {
    userController = controller as UserController;
  }
  @override
  void initState() {
    super.initState();
    if (!PreferenceManager.getIsLoginScreenOpen()) {
      _callLoginApi();
    }
    else{
      PreferenceManager.setIsLoginScreenOpen(false);
    }
  }

  Future<void> _callLoginApi() async {
    Helper.isInternetConnectionAvailable().then((internet) async {
      if (internet) {
        setData();
        await userController.login(user).then((value) async {
          if (value is APIResponse) {
            setState(() {
              userController.isApiCall = false;
            });
            PreferenceManager.setIsLoginScreenOpen(false);
          } else {
            if (value is APIError) {
              setState(() {
                userController.isApiCall = false;
              });
              //AlertHelper.customSnackBar(context, value.message, true);
            }
          }
        });
      } else {
        setState(() {
          userController.isApiCall = false;
        });
        //AlertHelper.customSnackBar(context, S.of(context).err_internet, true);
      }
    });
  }

  void setData() {
    setState(() {
      user.email = PreferenceManager.getEmail();
      user.password = PreferenceManager.getPassword();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to AccountScreen when the user icon is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountScreen()),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.red, // Red background for the icon
                child: Icon(
                  Icons.person, // Person icon inside the circle
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          HubScreen()
        ],
      ),
    );
  }
}
