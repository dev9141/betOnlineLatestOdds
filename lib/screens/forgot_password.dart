import 'package:bet_online_latest_odds/assets/app_colors.dart';
import 'package:bet_online_latest_odds/screens/password_email_send.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:state_extended/state_extended.dart';

import '../../assets/app_assets.dart';
import '../../controller/UserController.dart';
import '../../data/entity/account/user.dart';
import '../../data/remote/api_error.dart';
import '../../data/remote/api_response.dart';
import '../../data/repositories/user_repository.dart';
import '../../generated/l10n.dart';
import '../../utils/constants/screen.dart';
import '../../utils/helper/alert_helper.dart';
import '../../utils/helper/helper.dart';
import '../../views/custom_widgets/common_textfield.dart';
import '../../views/custom_widgets/primary_button.dart';
import '../assets/app_theme.dart';
import 'login_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  StateX<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends StateX<ForgotPassword> {
  User user = User();
  final TextEditingController _emailController = TextEditingController();
  bool _obscureText = true;
  String? emailError;
  bool isValidation = false;
  bool isEnableBtn = false;
  bool _isLoading = false;
  late UserController userController;

  _ForgotPasswordState() : super(controller: UserController()) {
    // Acquire a reference to the passed Controller.
    userController = controller as UserController;
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        isEnableBtn = _emailController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
        child: Scaffold(
      body: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppAssets.imgBackgroundTexture),
                    fit: BoxFit.cover)),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "Reset Your Paswword",
                      style: TextStyle(color: AppColors.white, fontSize: 24),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Enter the email address associated with your account, and we’ll send you a link to reset your password.",
                    style:
                        TextStyle(color: AppColors.white, fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  // Email & Password Fields
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.box_background,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            'Email',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        const SizedBox(height: 8),
                        CommonTextField(
                          decoration: InputDecoration(
                            hintText: 'Enter a valid Email',
                            hintStyle: TextStyle(
                              color: AppColors.hintColor,
                            ),
                            filled: true,
                            fillColor: AppColors.white,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          commonController: _emailController,
                          textInputType: TextInputType.emailAddress,
                        ),
                        if (emailError != null)
                          Container(
                            margin: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 4,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              emailError ?? '',
                              style: AppTheme.errorTextTheme,
                            ),
                          ),
                        const SizedBox(height: 20),
                        SizedBox(height: 20),
                        // Register Button
                        PrimaryButton(
                          btnColor: AppColors.theme_carrot,
                          /*btnColor: isEnableBtn
                              ? AppColors.lightBlue
                              : AppColors.grayColor,*/
                          Text('Continue',
                              style: TextStyle(
                                  fontSize: 20, color: AppColors.white)),
                          () {
                            {
                              Helper.hideKeyBoard(context);
                              checkValidation();
                              if (isValidation) {
                                Helper.isInternetConnectionAvailable()
                                    .then((internet) async {
                                  if (internet) {
                                    setState(() {
                                      _isLoading = true;
                                      userController.isApiCall = true;
                                    });
                                    setData();
                                    await userController
                                        .forgotPassword(user)
                                        .then((value) async {
                                      if (value is APIResponse) {
                                        setState(() {
                                          _isLoading = false;
                                          userController.isApiCall = false;
                                        });
                                        AlertHelper.customSnackBar(
                                            context, value.message, false);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                              builder: (context) => PasswordEmailSend(email: _emailController.text,),
                                            ));
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
                                    AlertHelper.customSnackBar(context,
                                        S.of(context).err_internet, true);
                                  }
                                });
                              }
                            }

                            //checkValidation();
            /*
                            if (isValidation) {
                              setState(() {
                                userController.isApiCall = true;
                              });
                              Helper.isInternetConnectionAvailable()
                                  .then((internet) async {
                                if (internet) {
                                  setData();
                                  await userController
                                      .forgotPassword(user)
                                      .then((value) async {
                                    if (value is APIResponse) {
                                      setState(() {
                                        userController.isApiCall = false;
                                      });
                                      AlertHelper.customSnackBar(
                                          context, value.message, false);
                                      screenType = Screen.register;
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              Screen.emailVerification,
                                              arguments: {
                                            'email': _emailController.text
                                                .toString()
                                                .trim()
                                          });
                                    } else {
                                      if (value is APIError) {
                                        setState(() {
                                          userController.isApiCall = false;
                                        });
                                        AlertHelper.customSnackBar(
                                            context, value.message, true);
                                      }
                                    }
                                  });
                                } else {
                                  setState(() {
                                    userController.isApiCall = false;
                                  });
                                  AlertHelper.customSnackBar(context,
                                      S.of(context).err_internet, true);
                                }
                              });
                            }
            */
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          backgroundColor: AppColors.theme_carrot,
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          child: Text(
                            "Return to Sign In",
                            style: TextStyle(
                                color: AppColors.white, fontSize: 18),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
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
      ),
    ));
  }

  checkValidation() {
    setState(() {
      emailError = null;
      isValidation = false;
    });

    if (_emailController.text.trim().isEmpty) {
      setState(() {
        emailError = S.of(context).err_email_id;
        isValidation = false;
      });
    } else if (!Helper.validateEmail(_emailController.text.trim())) {
      setState(() {
        emailError = S.of(context).invalid_email_id;
        isValidation = false;
      });
    }
    if (emailError == null && emailError == null) {
      setState(() {
        isValidation = true;
      });
    }
  }

  void setData() {
    setState(() {
      user.email = _emailController.text.toString().trim();
    });
  }
}
