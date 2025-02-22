import 'package:bet_online_latest_odds/assets/app_strings.dart';
import 'package:bet_online_latest_odds/assets/app_theme.dart';
import 'package:bet_online_latest_odds/controller/ConfigurationController.dart';
import 'package:bet_online_latest_odds/data/entity/account/user.dart';
import 'package:bet_online_latest_odds/data/local/preference_manager.dart';
import 'package:bet_online_latest_odds/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:state_extended/state_extended.dart';

import '../assets/app_assets.dart';
import '../controller/UserController.dart';
import '../assets/app_colors.dart';
import '../data/remote/api_error.dart';
import '../data/remote/api_response.dart';
import '../generated/l10n.dart';
import '../utils/constants/define.dart';
import '../utils/helper/alert_helper.dart';
import '../utils/helper/helper.dart';
import '../views/custom_widgets/common_textfield.dart';
import '../views/custom_widgets/primary_button.dart';
import 'DynamicUrlWebView.dart';
import 'forgot_password.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  StateX<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends StateX<LoginScreen> {
  User user = User();
  final TextEditingController _internetOneController = TextEditingController();
  final TextEditingController _internetTwoController = TextEditingController();
  final TextEditingController _internetThreeController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  String? emailError;
  String? passwordError;
  bool _isLoading = false;
  bool isValidation = false;
  bool isEnableBtn = false;
  bool isShowGuestUser = false;
  late UserController userController;
  late ConfigurationController configController;

  _LoginScreenState() : super(controller: UserController()) {
    // Acquire a reference to the passed Controller.
    userController = controller as UserController;
    configController = ConfigurationController();
  }

  @override
  void initState() {
    super.initState();
    callConfigurationAPI();
    _internetOneController.text = "Internet check one";
    _internetTwoController.text = "Internet check two";
    _internetThreeController.text = "Internet check three";
    _emailController.addListener(() {
      setState(() {
        isEnableBtn = _emailController.text.trim().isNotEmpty &&
            _passwordController.text.trim().isNotEmpty;
      });
    });

    _passwordController.addListener(() {
      setState(() {
        isEnableBtn = _emailController.text.trim().isNotEmpty &&
            _passwordController.text.trim().isNotEmpty;
      });
    });
  }

  Future<void> callConfigurationAPI() async {
    Helper.isInternetConnectionAvailable().then((internet) async {
      if (internet) {
        setData();
        await configController.pubConfiguration().then((value) async {
          if (value is APIResponse) {
            setState(() {
              isShowGuestUser = PreferenceManager.getIsAllowGuestUser();
              configController.isApiCall = false;
            });
          } else {
            if (value is APIError) {
              setState(() {
                configController.isApiCall = false;
              });
              //AlertHelper.customSnackBar(context, value.message, true);
            }
          }
        });
      } else {
        setState(() {
          configController.isApiCall = false;
        });
        //AlertHelper.customSnackBar(context, S.of(context).err_internet, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          body: DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppAssets.imgBackgroundTexture),
                    fit: BoxFit.cover)),
            child: Center(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Image.asset(AppAssets.icLogo,
                              height: 40), // Placeholder for logo
                        ),
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
                                AppStrings.log_in,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Text(
                                  AppStrings.email,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: AppColors.textTitle,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              const SizedBox(height: 8),
                              CommonTextField(
                                decoration: InputDecoration(
                                    hintText: AppStrings.enter_email,
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
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 2),
                                    )),
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
                              Container(
                                child: Text(
                                  AppStrings.password,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: AppColors.textTitle,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                                    hintText: AppStrings.enter_password,
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
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 2),
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
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  child: Text(
                                    AppStrings.forgot_password,
                                    style: TextStyle(
                                      color: AppColors.subTextGray,
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassword(), //ForgotPassword(),
                                        ));
                                  },
                                ),
                              ),
                              SizedBox(height: 30),
                              // Register Button
                              PrimaryButton(
                                btnColor: AppColors.theme_carrot,
                                /*btnColor: isEnableBtn
                                    ? AppColors.lightBlue
                                    : AppColors.grayColor,*/
                                Text(AppStrings.loginButton,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold)),
                                () {
                                  callLoginAPI();
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                backgroundColor: AppColors.theme_carrot,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        // Login Section
                        Container(
                          child: Column(
                            children: [
                              Text(
                                AppStrings.dont_have_account,
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                child: Text(
                                  AppStrings.sign_up,
                                  style: TextStyle(
                                      color: AppColors.theme_carrot,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RegistrationScreen(), //RegistrationScreenTwo(),
                                      ));
                                  /*Map<String, String> formData = {
                                    'FirstName': "Dev",
                                    'EMail': "deven0001@yopmail.com",
                                    'PasswordJ': "Test@123",
                                    'HomePhone': "6098545236",
                                    'BirthDate': "01/01/1997",
                                    'LastName': "Test",
                                  };
                                  PreferenceManager.setEmail(_emailController.text
                                      .trim());
                                  PreferenceManager.setPassword(_passwordController
                                      .text.trim());
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DynamicUrlWebView(
                                              formData: formData,),
                                      ));*/
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        isShowGuestUser
                            ? GestureDetector(
                                onTap: () {
                                  Helper.hideKeyBoard(context);

                                  Helper.isInternetConnectionAvailable()
                                      .then((internet) async {
                                    if (internet) {
                                      setState(() {
                                        _isLoading = true;
                                        userController.isApiCall = true;
                                      });
                                      await userController
                                          .loginAsGuest()
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
                                                builder: (context) =>
                                                    HomeScreen(),
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
                                      AlertHelper.customSnackBar(context,
                                          S.of(context).err_internet, true);
                                    }
                                  });
                                },
                                child: Text(
                                  "Login as Guest",
                                  style: TextStyle(
                                      color: AppColors.white, fontSize: 16),
                                ),
                              )
                            : Container()
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

  callLoginAPI(){
    Helper.hideKeyBoard(context);
    checkValidation();
    if (isValidation) {
      setState(() {
        userController.isApiCall = true;
      });
      Helper.isInternetConnectionAvailable()
          .then((internet) async {
        if (internet) {
          setState(() {
            _isLoading =
            true; // Show loader when the API call starts
          });
          setData();
          await userController
              .login(user)
              .then((value) async {
            if (value is APIResponse) {
              sendDeviceToken();
            } else {
              if (value is APIError) {
                setState(() {
                  _isLoading = false;
                  userController.isApiCall =
                  false;
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

  sendDeviceToken() async {
    await userController
        .sendTokenToServer()
        .then((value) async {
      if (value is APIResponse) {
        setState(() {
          _isLoading = false;
          userController.isApiCall =
          false;
        });
        PreferenceManager
            .setIsLoginScreenOpen(true);
        AlertHelper.customSnackBar(
            context,
            value.message,
            false);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(),
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
      }
      else {
        if (value is APIError) {
          setState(() {
            _isLoading = false;
            userController.isApiCall =
            false;
          });
          AlertHelper.customSnackBar(
              context, value.message, true);
        }
      }
    });
  }

  checkValidation() {
    setState(() {
      emailError = null;
      passwordError = null;
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

    if (emailError == null && emailError == null && passwordError == null) {
      setState(() {
        isValidation = true;
      });
    }
  }

  void setData() {
    setState(() {
      user.email = _emailController.text.toString().trim();
      user.password = _passwordController.text.toString().trim();
    });
  }
}
