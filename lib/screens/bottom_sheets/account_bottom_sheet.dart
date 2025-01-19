import 'dart:convert';
import 'dart:io';

import 'package:bet_online_latest_odds/assets/app_assets.dart';
import 'package:bet_online_latest_odds/data/local/preference_manager.dart';
import 'package:bet_online_latest_odds/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:state_extended/state_extended.dart';

import '../../assets/app_colors.dart';
import '../../controller/UserController.dart';
import '../../data/entity/account/user.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../data/remote/api_error.dart';
import '../../data/remote/api_response.dart';
import '../../generated/l10n.dart';
import '../../utils/helper/alert_helper.dart';
import '../../utils/helper/helper.dart';

class AccountBottomSheet extends StatefulWidget {
  const AccountBottomSheet({super.key});

  @override
  StateX<AccountBottomSheet> createState() => _AccountBottomSheetState();
}

class _AccountBottomSheetState extends StateX<AccountBottomSheet> {
  bool _isEmailVerified = false;
  User? _user;
  bool _isLoading = false;

  late UserController userController;

  _AccountBottomSheetState() : super(controller: UserController()) {
    // Acquire a reference to the passed Controller.
    userController = controller as UserController;
  }

  @override
  void initState() {
    super.initState();
    //_fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Replace with your API endpoint and authentication
      final response =
          await http.get(Uri.parse('https://api.example.com/user'));
      if (response.statusCode == 200) {
        setState(() {
          _user = User.fromMap(json.decode(response.body));
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 700,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppBar(
                    backgroundColor: AppColors.trans,
                    title: const Text('Account'),
                    centerTitle: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              const AssetImage(AppAssets.defaultProfileImage)
                                  as ImageProvider
                          /*_user?.profileImageThumb.isNotEmpty == true
                                  ? NetworkImage(_user!.profileImageThumb)
                                  : const AssetImage(AppAssets.defaultProfileImage)
                                      as ImageProvider*/
                          ,
                        ),
                        if (PreferenceManager.getEmailVerified())
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: AppColors.white,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: Card(
                      color: AppColors.accountCard,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: AppColors.grayColor, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 18),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                PreferenceManager.getEmail(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 12),
                            !PreferenceManager.getIsGuestUser()
                                ? PreferenceManager.getEmailVerified()
                                    ? Row(
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
                                            _isLoading =
                                                true; // Show loader when the API call starts
                                          });
                                          Helper.hideKeyBoard(context);
                                          setState(() {
                                            userController.isApiCall = true;
                                          });
                                          Helper.isInternetConnectionAvailable()
                                              .then((internet) async {
                                            if (internet) {
                                              await userController
                                                  .verifyEmail(PreferenceManager
                                                      .getEmail())
                                                  .then((value) async {
                                                if (value is APIResponse) {
                                                  setState(() {
                                                    _isLoading = false;
                                                    userController.isApiCall =
                                                        false;
                                                  });
                                                  AlertHelper.showToast(value.message);

                                                  /*screenType = Screen.register;
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    Screen.emailVerification,
                                                    arguments: {
                                                  'email': _emailController.text
                                                      .toString()
                                                      .trim()
                                                });*/
                                                } else {
                                                  if (value is APIError) {
                                                    setState(() {
                                                      _isLoading = false;
                                                      userController.isApiCall =
                                                          false;
                                                    });
                                                    AlertHelper.showToast(value.message);
                                                  }
                                                }
                                              });
                                            } else {
                                              setState(() {
                                                _isLoading = false;
                                                userController.isApiCall =
                                                    false;
                                              });
                                              AlertHelper.showToast(S.of(context).err_internet);
                                            }
                                          });
                                        },
                                        child: Row(
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
                            const SizedBox(height: 12),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {
                                  var terms =
                                      PreferenceManager.getPrivacyPolicyUrl();
                                  if (terms != null) {
                                    //_launchInWebView(terms);
                                    Helper.openBrowser(terms);
                                  }
                                },
                                child: Text("Privacy Policies",
                                    style: const TextStyle(
                                        color: AppColors.black)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {
                                  var supportUrl =
                                      PreferenceManager.getSupportUrl();
                                  if (supportUrl != null) {
                                    //_launchInWebView(supportUrl);
                                    Helper.openBrowser(supportUrl);
                                  }
                                },
                                child: Text("Support",
                                    style: const TextStyle(
                                        color: AppColors.black)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {
                                  var supportUrl =
                                      PreferenceManager.getFAQUrl();
                                  if (supportUrl != null) {
                                    //_launchInWebView(supportUrl);
                                    Helper.openBrowser(supportUrl);
                                  }
                                },
                                child: Text("FAQ",
                                    style: const TextStyle(
                                        color: AppColors.black)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {
                                  var tncUrl = PreferenceManager.getTnCUrl();
                                  if (tncUrl != null) {
                                    //_launchInWebView(tncUrl);
                                    Helper.openBrowser(tncUrl);
                                  }
                                },
                                child: Text("Term & Condition",
                                    style: const TextStyle(
                                        color: AppColors.black)),
                              ),
                            ),
                            const SizedBox(height: 18),
                            /*if (_user?.isEmailVerified != true)
                              Column(
                                children: [
                                  Container(
                                    height: 1,
                                    color: AppColors.black,
                                  ),
                                  const SizedBox(height: 18),
                                  // Send Email Option
                                  GestureDetector(
                                    onTap: () {
                                      // Action for sending email
                                    },
                                    child: const Text(
                                      'Send Us an Email',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),*/
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Log Out Button
                  Container(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
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
                            await userController.logout().then((value) async {
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
                      style: OutlinedButton.styleFrom(
                        side:
                            const BorderSide(color: AppColors.black, width: 2),
                        // Border color and width
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Rounded border
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12), // Padding inside the button
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: AppColors.black, // Text color
                          fontSize: 16, // Text size
                          fontWeight: FontWeight.bold, // Font weight
                        ),
                      ),
                    ),
                  ),
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
