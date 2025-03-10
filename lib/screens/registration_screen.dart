import 'package:bet_online_latest_odds/assets/app_assets.dart';
import 'package:bet_online_latest_odds/data/local/preference_manager.dart';
import 'package:bet_online_latest_odds/screens/DynamicUrlWebView.dart';
import 'package:bet_online_latest_odds/screens/home_screen.dart';
import 'package:bet_online_latest_odds/screens/login_screen.dart';
import 'package:bet_online_latest_odds/views/custom_widgets/common_textfield.dart';
import 'package:bet_online_latest_odds/views/custom_widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
import '../assets/app_strings.dart';
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
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _obscureText = true;
  String? emailError;
  String? passwordError;
  // String? userNameError;
  String? firstNameError;
  String? phoneNumberError;
  bool isValidation = false;
  bool isEnableBtn = false;
  bool _isLoading = false;
  late UserController userController;
  bool _termsAccepted = false;

  late WebViewController _webViewController;
  bool _isWebViewLoading = false;
  bool _isWebViewInitialized = false;
  bool isFormUrlHandled = false;

  _RegistrationScreenState() : super(controller: UserController()) {
    // Acquire a reference to the passed Controller.
    userController = controller as UserController;
  }

  Future<void> _launchTermsUrl() async {
    final Uri url = Uri.parse(PreferenceManager.getTnCUrl());
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
    else{
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeWebView();
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

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            print("WebView: Page started loading: $url");
          },
          onPageFinished: (url) {
            print("WebView: Page finished loading: $url");
            if (url.contains("https://api.betonline")) {
              print("DynamicUrlWebView: second url 2");
              //_handleFormUrl(url);
              Map<String, String> formData = {
                'FirstName': _firstNameController.text.trim(),
                'EMail': _emailController.text.trim(),
                'PasswordJ': _passwordController.text.trim(),
                'HomePhone': _phoneNumberController.text.trim(),
              };

              print("DynamicUrlWebView: Page finished loading: $url");
              if (!isFormUrlHandled && url.contains("/registrations?client_id")) {
                print("DynamicUrlWebView: second url 2");
                isFormUrlHandled = true;
                _handleFormUrl(formData);
              }
              if (isFormUrlHandled && url.contains("registration?execution")) {
                print("DynamicUrlWebView: second url 2");
                AlertHelper.showToast("Registereted");
                setState(() {
                  _isWebViewLoading = false;
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              }
            }

          },
        ),
      );
  }

  void _handleFormUrl(Map<String, String> formData) async {

    // Generate JavaScript for autofill and form submission
    String jsCode = _generateJavaScript(formData);
    // Execute JavaScript in WebView
    await _webViewController.runJavaScript(jsCode);
  }

  String _generateJavaScript(Map<String, String> formData) {
    final StringBuffer jsBuffer = StringBuffer();

    // Populate form fields
    formData.forEach((fieldId, value) {
      print("DynamicUrlWebView: key ${fieldId}, value: $value");
      jsBuffer.writeln(
        'document.getElementById("$fieldId").value = "$value";',
      );
      jsBuffer.writeln(
        'document.getElementById("$fieldId").dispatchEvent(new Event(\'input\'));',
      );
      jsBuffer.writeln(
        'document.getElementById("$fieldId").dispatchEvent(new Event(\'change\'));',
      );
      jsBuffer.writeln(
        'document.getElementById("$fieldId").dispatchEvent(new Event(\'input\'));',
      );
      jsBuffer.writeln(
        'document.getElementById("$fieldId").dispatchEvent(new Event(\'change\'));',
      );
    });
    jsBuffer.writeln('setTimeout(function () {');
    jsBuffer.writeln('document.getElementById("btnsubmit").disabled = false;');
    jsBuffer.writeln('document.getElementById("btnsubmit").click();');
    //jsBuffer.writeln('document.getElementById("btnsubmit").form.submit();');
    jsBuffer.writeln('}, 5000);');

    jsBuffer.writeln(

    );
    print("DynamicUrlWebView: inject ${jsBuffer.toString()}");
    return jsBuffer.toString();
  }


  void _startWebViewProcess() {
    setState(() {
      _isWebViewLoading = true;
    });

    // Load initial URL
    _webViewController.loadRequest(Uri.parse('https://record.betonlineaffiliates.ag/_on42CIkH5pz-a8CTELPmZWNd7ZgqdRLk/1/'));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppAssets.imgBackgroundTexture),
                    fit: BoxFit.cover)),
            child: Center(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
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
                              Text(
                                AppStrings.sign_up,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,),
                              ),const SizedBox(height: 6),
                              Container(
                                child: Text(
                                  AppStrings.email,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: AppColors.textTitle,
                                    fontSize: 16,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              const SizedBox(height: 4),
                              CommonTextField(
                                decoration: InputDecoration(
                                  hintText: AppStrings.emailHint,
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
                              const SizedBox(height: 6),
                              Container(
                                child: Text(
                                  AppStrings.firstName,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: AppColors.textTitle,
                                    fontSize: 16,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 50,
                                child: CommonTextField(
                                  commonController: _firstNameController,
                                  textInputType: TextInputType.text,
                                  hintText: AppStrings.enter_first_name,
                                  decoration: InputDecoration(
                                    hintText: 'Create a first name',
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
                              if (firstNameError != null)
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 4,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    firstNameError ?? '',
                                    style: AppTheme.errorTextTheme,
                                  ),
                                ),
                              SizedBox(height: 12),
                              Container(
                                child: Text(
                                  AppStrings.password,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: AppColors.textTitle,
                                    fontSize: 16,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 50,
                                child: CommonTextField(
                                  commonController: _passwordController,
                                  textInputType: TextInputType.text,
                                  hintText: AppStrings.passwordHint,
                                  isShowPassword: _obscureText,
                                  decoration: InputDecoration(
                                    hintText: 'Create a password',
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
                              SizedBox(height: 12),
                              Container(
                                child: Text(
                                  AppStrings.phone_number,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: AppColors.textTitle,
                                    fontSize: 16,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 50,
                                child: CommonTextField(
                                  commonController: _phoneNumberController,
                                  textInputType: TextInputType.phone,
                                  hintText: AppStrings.phone_hint,
                                  decoration: InputDecoration(
                                    hintText: AppStrings.phone_hint,
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
                              if (phoneNumberError != null)
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 4,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    phoneNumberError ?? '',
                                    style: AppTheme.errorTextTheme,
                                  ),
                                ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Checkbox(
                                    focusColor: AppColors.red,
                                    value: _termsAccepted,
                                    onChanged: (value) {
                                      setState(() {
                                        _termsAccepted = value!;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _launchTermsUrl,
                                      child: const Text(
                                        'I accept the Terms and Conditions',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.red,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              // Register Button
                              PrimaryButton(
                                btnColor: AppColors.red,
                                /*btnColor: isEnableBtn
                                    ? AppColors.lightBlue
                                    : AppColors.grayColor,*/
                                Text(AppStrings.createAccount,
                                    style: TextStyle(
                                        fontSize: 20, color: AppColors.white)),
                                () {
                                  Helper.hideKeyBoard(context);
                                  checkValidation();
                                  //if (isValidation) {
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
                                            //_startWebViewProcess();
                                            Map<String, String> formData = {
                                              'FirstName': _firstNameController.text.trim(),
                                              'EMail': _emailController.text.trim(),
                                              'PasswordJ': _passwordController.text.trim(),
                                              'HomePhone': _phoneNumberController.text.trim(),
                                            };
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DynamicUrlWebView(formData: formData,),
                                                ));
                                            /*Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen(),
                                                ));*/
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
                                  //}
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                backgroundColor: AppColors.red,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        // Login Section
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                AppStrings.already_have_account,
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                child: Text(AppStrings.log_in,
                                    style: TextStyle(
                                        color: AppColors.theme_carrot,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800)),
                                onTap: (){
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                        (Route<dynamic> route) =>
                                    false, // Removes all routes
                                  );
                                },
                              ),
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
              // Hidden WebView
              Opacity(
                opacity: 1,
                child: SizedBox(
                  height: 1,
                  width: 1,
                  child: _isWebViewInitialized
                      ? WebViewWidget(controller: _webViewController)
                      : null,
                ),
              ),
              if (_isWebViewLoading)
                const Opacity(
                  opacity: 0.8,
                  child: ModalBarrier(dismissible: false, color: Colors.black),
                ),
              if (_isWebViewLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
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
      // userNameError = null;
      firstNameError = null;
      phoneNumberError = null;
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

    if (!_termsAccepted) {
      AlertHelper.showToast(
          "Please accept term and consitions");
      isValidation = false;
    }

    if (_firstNameController.text.trim().isEmpty) {
      setState(() {
        firstNameError = AppStrings.firstNameRequired;
        isValidation = false;
      });
    } else if (_firstNameController.text.trim().length < FIRST_NAME_LENGTH_MIN) {
      setState(() {
        firstNameError =
            S.of(context).err_user_name_min_length(FIRST_NAME_LENGTH_MIN);
        isValidation = false;
      });
    }

    if (_phoneNumberController.text.trim().isEmpty) {
      setState(() {
        phoneNumberError = AppStrings.phoneNumberRequired;
        isValidation = false;
      });
    } else if (_phoneNumberController.text.trim().length != PHONE_NUMBER_LENGTH) {
      setState(() {
        phoneNumberError =
            S.of(context).err_phone_length(PHONE_NUMBER_LENGTH);
        isValidation = false;
      });
    }
  }

  void setData() {
    setState(() {
      user.email = _emailController.text.toString().trim();
      user.password = _passwordController.text.toString().trim();
      user.firstName = _firstNameController.text.toString().trim();
      user.phoneNumber = _phoneNumberController.text.toString().trim();
    });
  }
}
