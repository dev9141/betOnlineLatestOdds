import 'dart:async';

import 'package:bet_online_latest_odds/assets/app_assets.dart';
import 'package:bet_online_latest_odds/data/local/preference_manager.dart';
import 'package:bet_online_latest_odds/data/repositories/user_repository.dart';
import 'package:bet_online_latest_odds/screens/login_screen.dart';
import 'package:bet_online_latest_odds/utils/constants/screen.dart';
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

      if (PreferenceManager.getIsUserLoggedIn()) {
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
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.imgSplashBackground), // Replace with your image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // BET ONLINE text
                Image.asset(
                  AppAssets.icLogo, // Replace with your logo asset
                  height: 100,
                ),
                const SizedBox(height: 8), // Space between texts
                // LATEST ODDS text
                Text(
                  "LATEST ODDS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
