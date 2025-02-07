import 'package:bet_online_latest_odds/data/local/preference_manager.dart';
import 'package:bet_online_latest_odds/utils/helper/alert_helper.dart';
import 'package:bet_online_latest_odds/utils/helper/app_url.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'home_screen.dart';

class DynamicUrlWebView extends StatefulWidget {
  final Map<String, String> formData; // Data to autofill the form

  DynamicUrlWebView({super.key, required this.formData});

  @override
  _DynamicUrlWebViewState createState() => _DynamicUrlWebViewState();
}

class _DynamicUrlWebViewState extends State<DynamicUrlWebView> {
  late final WebViewController _controller;
  bool isFormUrlHandled = false; // Ensure form is handled only once

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
              if (!isFormUrlHandled && url.contains("/registrations?client_id")) {
                print("DynamicUrlWebView: second url 2");
                isFormUrlHandled = true;
                _handleFormUrl();
              }
              if (isFormUrlHandled && url.contains("registration?execution")) {
                print("DynamicUrlWebView: second url 2");
                AlertHelper.showToast("Registereted");
                setState(() {
                  //_isWebViewLoading = false;
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
      )
      ..loadRequest(Uri.parse(PreferenceManager.getAffiliateUrl())); // Load the first URL
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
    jsBuffer.writeln('}, 5000);');
    print("DynamicUrlWebView: inject ${jsBuffer.toString()}");
    return jsBuffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Auto sign up, Don't perform any action")),
      body: WebViewWidget(controller: _controller), // Use WebViewWidget
    );
  }
}