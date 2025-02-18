import 'package:bet_online_latest_odds/data/local/preference_manager.dart';
import 'package:bet_online_latest_odds/utils/helper/alert_helper.dart';
import 'package:bet_online_latest_odds/utils/helper/app_url.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:video_player/video_player.dart';

import '../assets/app_assets.dart';
import '../assets/app_colors.dart';
import '../assets/app_strings.dart';
import '../controller/UserController.dart';
import '../data/entity/account/user.dart';
import '../data/remote/api_error.dart';
import '../data/remote/api_response.dart';
import '../utils/helper/helper.dart';
import '../views/custom_widgets/primary_button.dart';
import 'home_screen.dart';

class DynamicUrlWebView extends StatefulWidget {
  final Map<String, String> formData; // Data to autofill the form

  DynamicUrlWebView({super.key, required this.formData});

  @override
  StateX<DynamicUrlWebView> createState() => _DynamicUrlWebViewState();
}

class _DynamicUrlWebViewState extends StateX<DynamicUrlWebView> {
  late final WebViewController _controller;
  late VideoPlayerController _videoController;
  bool isFormUrlHandled = false; // Ensure form is handled only once
  bool _isVideoCompleted = false;
  bool _isVideoLoad = false;
  late UserController userController;

  User user = User();
  _DynamicUrlWebViewState() : super(controller: UserController()) {
    userController = controller as UserController;
  }
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            print("DynamicUrlWebView: Page started loading: $url");
          },
          onPageFinished: (url) {
            print("WebView: Page finished loading: $url");
            if (url.contains("https://api.betonline")) {
              print("DynamicUrlWebView: second url 2");
              print("DynamicUrlWebView: Page finished loading: $url");
              if (!isFormUrlHandled &&
                  url.contains("/registrations?client_id")) {
                print("DynamicUrlWebView: second url 2");
                isFormUrlHandled = true;
                _handleFormUrl();
              }
              if (isFormUrlHandled && url.contains("registration?execution")) {
                //_callRegistrationConfirmApi();
                print("DynamicUrlWebView: second url 2");
                AlertHelper.showToast("Registereted");
                setState(() {
                  //_isWebViewLoading = false;
                });
                /*Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );*/
              }
            }
          },
        ),
      )
      ..loadRequest(
          Uri.parse(PreferenceManager.getAffiliateUrl())); // Load the first URL

    // Initialize video player
    _videoController = VideoPlayerController.asset(
      AppAssets.intro_video, // Replace with your video URL
    )..initialize().then((_) {
        setState(() {}); // Update UI after initialization
        _videoController.play(); // Auto play video
        _isVideoLoad = true;
      });

    _videoController.addListener(() {
      if (_isVideoLoad && _videoController.value.position >= _videoController.value.duration - Duration(milliseconds: 200)) {
        if (!_isVideoCompleted) {  // Prevent multiple triggers
          setState(() {
            _isVideoCompleted = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _goToNextScreen() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(),
        ));
  }

  Future<void> _callRegistrationConfirmApi() async {
    Helper.isInternetConnectionAvailable().then((internet) async {
      if (internet) {
        setData();
        await userController.registerConfirmation(user).then((value) async {
          //if (value is APIResponse) {
            //_goToNextScreen();
          // } else {
          //   if (value is APIError) {
          //     setState(() {
          //       userController.isApiCall = false;
          //     });
          //     //AlertHelper.customSnackBar(context, value.message, true);
          //   }
          // }
        });
      } else {
        setState(() {
          userController.isApiCall = false;
        });
        //AlertHelper.customSnackBar(context, S.of(context).err_internet, true);
      }
    });
  }


  // Handle the form URL and autofill the data
  void _handleFormUrl() async {
    // Generate JavaScript for autofill and form submission
    String jsCode = _generateJavaScript(widget.formData);

    // Execute JavaScript in WebView
    await _controller.runJavaScript(jsCode);
  }

  // Generate JavaScript to autofill and submit the form
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
      /*jsBuffer.writeln(
        'document.getElementById("$fieldId").dispatchEvent(new Event(\'input\'));',
      );
      jsBuffer.writeln(
        'document.getElementById("$fieldId").dispatchEvent(new Event(\'change\'));',
      );*/
    });
    jsBuffer.writeln('setTimeout(function () {');
    jsBuffer.writeln('document.getElementById("btnsubmit").disabled = false;');
    jsBuffer.writeln('document.getElementById("btnsubmit").click();');
    jsBuffer.writeln('}, 5000);');
    print("DynamicUrlWebView: inject ${jsBuffer.toString()}");
    return jsBuffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _videoController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                : CircularProgressIndicator(), // Show loading until video initializes
          ),

          // Hidden WebView (Running in background using Opacity)
          IgnorePointer(
            ignoring: true,
            child: Opacity(
              opacity: 0.0, // Fully transparent but still active
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: WebViewWidget(controller: _controller),
              ),
            ),
          ),

          // Show "Next" button only when the video completes
          if (_isVideoCompleted)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: PrimaryButton(
                  btnColor: AppColors.theme_carrot,
                  /*btnColor: isEnableBtn
                                    ? AppColors.lightBlue
                                    : AppColors.grayColor,*/
                  Text(AppStrings.nextButton,
                      style: TextStyle(
                          fontSize: 20, color: AppColors.white, fontWeight: FontWeight.bold)),
                      () {
                        _goToNextScreen();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: AppColors.theme_carrot,
                ),
              ),
            ),
        ],
      ),
      //WebViewWidget(controller: _controller), // Use WebViewWidget
    );
  }
  void setData() {
    setState(() {
      user.email = widget.formData['EMail']!;
      user.password = widget.formData['PasswordJ']!;
      user.firstName = widget.formData['FirstName']!;
      user.lastName = widget.formData['LastName']!;
      user.dob = widget.formData['BirthDate']!;
      user.phoneNumber = widget.formData['HomePhone']!;
    });
  }
}

