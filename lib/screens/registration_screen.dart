import 'package:betus/assets/app_assets.dart';
import 'package:betus/screens/home_screen.dart';
import 'package:betus/screens/login_screen.dart';
import 'package:betus/views/custom_widgets/common_textfield.dart';
import 'package:betus/views/custom_widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:state_extended/state_extended.dart';

import '../../controller/UserController.dart';
import '../../assets/app_colors.dart';
import '../../data/entity/account/user.dart';
import '../../data/remote/api_error.dart';
import '../../data/remote/api_response.dart';
import '../../data/repositories/user_repository.dart';
import '../../generated/l10n.dart';
import '../../utils/constants/define.dart';
import '../../utils/constants/screen.dart';
import '../../utils/helper/alert_helper.dart';
import '../../utils/helper/helper.dart';
import '../assets/app_theme.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  StateX<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends StateX<RegistrationScreen> {
  User user = User();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  bool _obscureText = true;
  String? emailError;
  String? passwordError;
  String? userNameError;
  bool isValidation = false;
  bool isEnableBtn = false;
  bool _isLoading = false;
  late UserController userController;

  _RegistrationScreenState() : super(controller: UserController()) {
    // Acquire a reference to the passed Controller.
    userController = controller as UserController;
  }

  @override
  void initState() {
    super.initState();
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
                          child: SvgPicture.asset(AppAssets.icLogo,
                              height: 60), // Placeholder for logo
                        ),
                        Text(
                          "Sign up for updates & notifications",
                          style: TextStyle(color: AppColors.white, fontSize: 22),
                        ),
                        SizedBox(height: 20),
                        // Email & Password Fields
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.inputBackground,
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
                              const SizedBox(height: 20),
                              Container(
                                child: Text(
                                  'User Name',
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
                                  commonController: _userNameController,
                                  textInputType: TextInputType.text,
                                  hintText: S.of(context).password,
                                  decoration: InputDecoration(
                                    hintText: 'Create a User Name',
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
                                ),
                              ),
                              if (userNameError != null)
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 4,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    userNameError ?? '',
                                    style: AppTheme.errorTextTheme,
                                  ),
                                ),
                              SizedBox(height: 25),
                              // Register Button
                              PrimaryButton(
                                btnColor: AppColors.red,
                                /*btnColor: isEnableBtn
                                    ? AppColors.lightBlue
                                    : AppColors.grayColor,*/
                                Text('Register',
                                    style: TextStyle(
                                        fontSize: 20, color: AppColors.white)),
                                () {
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
                                            .register(user)
                                            .then((value) async {
                                          if (value is APIResponse) {
                                            setState(() {
                                              _isLoading = false;
                                              userController.isApiCall = false;
                                            });
                                            AlertHelper.customSnackBar(
                                                context, value.message, false);
                                            /*screenType = Screen.register;
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                Screen.emailVerification,
                                                arguments: {
                                                  'email': _emailController.text
                                                      .toString()
                                                      .trim()
                                                });*/
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => HomeScreen(),
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
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                backgroundColor: AppColors.red,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Login Section
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.bgGrayColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Need to Login?",
                                style: TextStyle(color: AppColors.white, fontSize: 18),
                              ),
                              SizedBox(height: 10),
                              PrimaryButton(
                                Text(S.of(context).login,
                                    style: TextStyle(
                                        fontSize: 20, color: AppColors.white)),
                                () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginScreen()),
                                        (Route<dynamic> route) => false, // Removes all routes
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                backgroundColor: AppColors.blue,
                              )
                            ],
                          ),
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

  checkValidation() {
    setState(() {
      emailError = null;
      passwordError = null;
      userNameError = null;
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

    if (_userNameController.text.trim().isEmpty) {
      setState(() {
        userNameError = S.of(context).err_user_name;
        isValidation = false;
      });
    } else if (_userNameController.text.trim().length < USER_NAME_LENGTH_MIN) {
      setState(() {
        userNameError =
            S.of(context).err_user_name_min_length(USER_NAME_LENGTH_MIN);
        isValidation = false;
      });
    }
  }

  void setData() {
    setState(() {
      user.email = _emailController.text.toString().trim();
      user.password = _passwordController.text.toString().trim();
      user.username = _userNameController.text.toString().trim();
    });
  }
}