import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

import '../../assets/app_colors.dart';
import '../../data/local/preference_manager.dart';
import '../../views/custom_widgets/primary_button.dart';
import '../login_screen.dart';

class LogoutBottomSheet extends StatefulWidget {
  const LogoutBottomSheet({super.key});

  @override
  StateX<LogoutBottomSheet> createState() => _LogoutBottomSheetState();
}

class _LogoutBottomSheetState extends StateX<LogoutBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Center(
                  child: Icon(
                Icons.logout,
                size: 40.0,
              )),
              SizedBox(
                height: 8,
              ),
              Text(
                "Log Out",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    fontSize: 20),
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                "Are you sure you want to log out?",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: AppColors.black,
                    fontSize: 18),
              ),
              SizedBox(
                height: 14,
              ),
              PrimaryButton(
                btnColor: AppColors.black,
                /*btnColor: isEnableBtn
                          ? AppColors.lightBlue
                          : AppColors.grayColor,*/
                Text('Yes, log out',
                    style: TextStyle(fontSize: 20, color: AppColors.white)),
                () {
                  PreferenceManager.clear();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: AppColors.black,
              ),
              SizedBox(
                height: 6,
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.black, width: 2),
                  minimumSize: Size(double.infinity, double.minPositive),
                  // Border color and width
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded border
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12), // Padding inside the button
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.black, // Text color
                    fontSize: 20, // Text size
                    fontWeight: FontWeight.bold, // Font weight
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
