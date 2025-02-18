import 'package:bet_online_latest_odds/assets/app_strings.dart';
import 'package:bet_online_latest_odds/assets/app_theme.dart';
import 'package:bet_online_latest_odds/controller/ConfigurationController.dart';
import 'package:bet_online_latest_odds/data/entity/account/user.dart';
import 'package:bet_online_latest_odds/data/local/preference_manager.dart';
import 'package:bet_online_latest_odds/screens/password_email_send.dart';
import 'package:bet_online_latest_odds/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:state_extended/state_extended.dart';

import '../assets/app_assets.dart';
import '../controller/UserController.dart';
import '../assets/app_colors.dart';
import '../data/remote/api_error.dart';
import '../data/remote/api_response.dart';
import '../data/repositories/user_repository.dart';
import '../generated/l10n.dart';
import '../utils/constants/define.dart';
import '../utils/constants/screen.dart';
import '../utils/helper/alert_helper.dart';
import '../utils/helper/helper.dart';
import '../views/custom_widgets/common_textfield.dart';
import '../views/custom_widgets/primary_button.dart';
import 'forgot_password.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  StateX<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends StateX<AccountScreen> {
  User user = User();

  bool _isLoading = false;
  late UserController userController;
  late ConfigurationController configController;

  _AccountScreenState() : super(controller: UserController()) {
    // Acquire a reference to the passed Controller.
    userController = controller as UserController;
    configController = ConfigurationController();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Center(
              child: Text(
                'Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          backgroundColor: AppColors.background,
          body: DecoratedBox(
            decoration: BoxDecoration(),
            child: Center(
              child: Stack(
                children: [
                  SafeArea(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height/3,
                          color: AppColors.black,
                        ),
                        Container(
                          color: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Email & Password Fields
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.box_background,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Text(
                                PreferenceManager.getEmail(),
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              !PreferenceManager.getIsGuestUser()
                                  ? PreferenceManager.getEmailVerified()
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Email Verified',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Icon(
                                              Icons.verified,
                                              color: Colors.green,
                                              size: 18,
                                            ),
                                          ],
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isLoading = true; // Show loader when the API call starts
                                            });
                                            Helper.hideKeyBoard(context);
                                            setState(() {
                                              userController.isApiCall = true;
                                            });
                                            Helper.isInternetConnectionAvailable()
                                                .then((internet) async {
                                              if (internet) {
                                                await userController
                                                    .verifyEmail(
                                                        PreferenceManager
                                                            .getEmail())
                                                    .then((value) async {
                                                  if (value is APIResponse) {
                                                    setState(() {
                                                      _isLoading = false;
                                                      userController.isApiCall =
                                                          false;
                                                    });
                                                    AlertHelper.showToast(
                                                        value.message);
                                                  } else {
                                                    if (value is APIError) {
                                                      setState(() {
                                                        _isLoading = false;
                                                        userController
                                                            .isApiCall = false;
                                                      });
                                                      AlertHelper.showToast(
                                                          value.message);
                                                    }
                                                  }
                                                });
                                              } else {
                                                setState(() {
                                                  _isLoading = false;
                                                  userController.isApiCall =
                                                      false;
                                                });
                                                AlertHelper.showToast(
                                                    S.of(context).err_internet);
                                              }
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                'Verify Email',
                                                style: TextStyle(
                                                  color: AppColors.blue,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Icon(
                                                Icons.error_outline,
                                                color: AppColors.grayColor,
                                                size: 18,
                                              ),
                                            ],
                                          ),
                                        )
                                  : Container(),
                              const SizedBox(height: 40),
                              Container(
                                height: 1,
                                color: AppColors.grayColor,
                              ),
                              const SizedBox(height: 40),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppStrings.support_privacy,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: AppColors.textTitle,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 25),
                              _buildClickableItem(AppStrings.FAQ),
                              const SizedBox(height: 25),
                              _buildClickableItem(AppStrings.support),
                              const SizedBox(height: 25),
                              _buildClickableItem(AppStrings.privacy_policies),
                              const SizedBox(height: 25),
                              _buildClickableItem(
                                  AppStrings.term_and_condition),
                              const SizedBox(height: 25),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        PrimaryButton(
                          btnColor: AppColors.theme_carrot,
                          /*btnColor: isEnableBtn
                                    ? AppColors.lightBlue
                                    : AppColors.grayColor,*/
                          Text(AppStrings.logoutButton,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold)),
                          () {
                            Helper.hideKeyBoard(context);
                            setState(() {
                              userController.isApiCall = true;
                            });
                            Helper.isInternetConnectionAvailable()
                                .then((internet) async {
                              if (internet) {
                                setState(() {
                                  _isLoading = true;
                                });
                                await userController
                                    .logout()
                                    .then((value) async {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (value is APIResponse) {
                                    PreferenceManager.clear();
                                    setState(() {
                                      _isLoading = false;
                                      userController.isApiCall = false;
                                    });
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ));
                                  } else {
                                    if (value is APIError) {
                                      setState(() {
                                        _isLoading = false;
                                        userController.isApiCall = false;
                                      });
                                      AlertHelper.customSnackBar(
                                          context, value.message, true);
                                    }
                                  }
                                });
                              } else {
                                setState(() {
                                  _isLoading = false;
                                  userController.isApiCall = false;
                                });
                                AlertHelper.customSnackBar(
                                    context, S.of(context).err_internet, true);
                              }
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          backgroundColor: AppColors.theme_carrot,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}

Widget _buildClickableItem(String title) {
  return InkWell(
    onTap: () {
      String supportUrl = "";
      if (title == AppStrings.FAQ) {
        supportUrl = PreferenceManager.getFAQUrl();
      } else if (title == AppStrings.support) {
        supportUrl = PreferenceManager.getSupportUrl();
      } else if (title == AppStrings.privacy_policies) {
        supportUrl = PreferenceManager.getPrivacyPolicyUrl();
      } else if (title == AppStrings.term_and_condition) {
        supportUrl = PreferenceManager.getTnCUrl();
      }

      Helper.openBrowser(supportUrl);
    },
    child: Container(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(color: AppColors.textTitle, fontSize: 16),
      ),
    ),
  );
}
