import 'package:bet_online_latest_odds/assets/app_colors.dart';
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
import '../utils/constants/define.dart';
import 'login_screen.dart';

class PasswordEmailSend extends StatefulWidget {
  final String email;

  const PasswordEmailSend({super.key, required this.email});

  @override
  StateX<PasswordEmailSend> createState() => _PasswordEmailSendState();
}

class _PasswordEmailSendState extends StateX<PasswordEmailSend> {
  User user = User();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  String? codeError;
  String? passwordError;
  bool _isLoading = false;
  bool isValidation = false;
  bool isEnableBtn = false;
  late UserController userController;

  _PasswordEmailSendState() : super(controller: UserController()) {
    // Acquire a reference to the passed Controller.
    userController = controller as UserController;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
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
                          "Check your Email",
                          style: TextStyle(color: AppColors.white, fontSize: 24),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "We just sent email you a code for reset password.",
                        style: TextStyle(color: AppColors.white, fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Container(
                        child: Center(
                          child: Image.asset(
                            AppAssets.emailSend,
                            width: 70,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        child: Text(
                          'Code',
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
                          hintText: 'Enter a code',
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
                        commonController: _codeController,
                        textInputType: TextInputType.emailAddress,
                      ),
                      if (codeError != null)
                        Container(
                          margin: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 4,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            codeError ?? '',
                            style: AppTheme.errorTextTheme,
                          ),
                        ),
                      Container(
                        child: Text(
                          'Password',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 50,
                        child: CommonTextField(
                          commonController: _passwordController,
                          textInputType: TextInputType.text,
                          hintText: S.of(context).password,
                          isShowPassword: _obscureText,
                          decoration: InputDecoration(
                            hintText: 'Create a Password',
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
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                color: AppColors.hintColor,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (passwordError != null)
                        Container(
                          margin: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 4,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            passwordError ?? '',
                            style: AppTheme.errorTextTheme,
                          ),
                        ),
                      SizedBox(height: 20),
                      PrimaryButton(
                        btnColor: AppColors.blue,
                        /*btnColor: isEnableBtn
                                    ? AppColors.lightBlue
                                    : AppColors.grayColor,*/
                        Text('Reset Password',
                            style: TextStyle(fontSize: 20, color: AppColors.white)),
                        () {
                          setState(() {
                            _isLoading = true; // Show loader when the API call starts
                          });
                          Helper.hideKeyBoard(context);
                          checkValidation();
                          if (isValidation) {
                            setState(() {
                              userController.isApiCall = true;
                            });
                            Helper.isInternetConnectionAvailable()
                                .then((internet) async {
                              if (internet) {
                                setData();
                                await userController
                                    .resetPassword(user)
                                    .then((value) async {
                                  if (value is APIResponse) {
                                    setState(() {
                                      _isLoading = false;
                                      userController.isApiCall = false;
                                    });
                                    AlertHelper.customSnackBar(
                                        context, value.message, false);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
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
                                AlertHelper.customSnackBar(
                                    context, S.of(context).err_internet, true);
                              }
                            });
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        backgroundColor: AppColors.blue,
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        child: Text(
                          "Return to Sign In",
                          style: TextStyle(color: AppColors.white, fontSize: 18),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ));
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )),
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

  checkValidation() {
    setState(() {
      codeError = null;
      passwordError = null;
      isValidation = false;
    });

    if (_codeController.text.trim().isEmpty) {
      setState(() {
        codeError = S.of(context).err_email_id;
        isValidation = false;
      });
    }

    if (_passwordController.text.trim().isEmpty) {
      setState(() {
        passwordError = S.of(context).err_password;
        isValidation = false;
      });
    } else if (_passwordController.text.trim().length < PASSWORD_LENGTH_MIN) {
      setState(() {
        passwordError =
            S.of(context).err_password_min_length(PASSWORD_LENGTH_MIN);
        isValidation = false;
      });
    }
    /*else if (_passwordController.text.trim().length > PASSWORD_LENGTH_MAX) {
      setState(() {
        passwordError = S.of(context).err_password_max_length(PASSWORD_LENGTH_MAX);
        isValidation = false;
      });
    } else if (!Helper.isValidPassword(_passwordController.text.trim())) {
      setState(() {
        passwordError = S
            .of(context)
            .err_valid_password(PASSWORD_LENGTH_MIN, PASSWORD_LENGTH_MAX);
        isValidation = false;
      });
    }*/

    if (codeError == null && codeError == null && passwordError == null) {
      setState(() {
        isValidation = true;
      });
    }
  }

  void setData() {
    setState(() {
      user.email = widget.email;
      user.code = _codeController.text.toString().trim();
      user.password = _passwordController.text.toString().trim();
    });
  }
}
