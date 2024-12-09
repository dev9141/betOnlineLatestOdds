import 'dart:async';

import 'package:betus/assets/app_assets.dart';
import 'package:betus/data/local/preference_manager.dart';
import 'package:betus/data/repositories/user_repository.dart';
import 'package:betus/screens/login_screen.dart';
import 'package:betus/utils/constants/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      // Replace with your logic to check if user is logged in
      bool isLoggedIn = false; // Change this based on actual login state
      //PreferenceManager.setIsUserLoggedIn(false);
      if (PreferenceManager.getIsUserLoggedIn()) {
        /*Fluttertoast.showToast(
            msg: await UserRepository().getAccessToken(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);*/
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            AppAssets.imgSplashBackground, // Replace with your image asset
            fit: BoxFit.cover,
          ),
          // App logo
          DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppAssets.imgBackgroundTexture),
                    fit: BoxFit.cover)),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.icLogo, // Replace with your logo asset
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
