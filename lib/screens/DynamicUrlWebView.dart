import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DynamicUrlWebView extends StatefulWidget {
  final String firstUrl; // The initial URL to load
  final Map<String, String> formData; // Data to autofill the form

  DynamicUrlWebView({required this.firstUrl, required this.formData});

  @override
  _DynamicUrlWebViewState createState() => _DynamicUrlWebViewState();
}

class _DynamicUrlWebViewState extends State<DynamicUrlWebView> {
  late final WebViewController _controller;
  bool isFormUrlHandled = false; // Ensure form is handled only once

  @override
  void initState() {
    super.initState();

    // Initialize WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            print("DynamicUrlWebView: Page started loading: $url");

            // Detect form URL dynamically
            if (!isFormUrlHandled && url.contains("https://api.betonline")) {
              print("DynamicUrlWebView: second url");
              //isFormUrlHandled = true;
              //_handleFormUrl(url);
            }
          },
          onPageFinished: (url) {
            print("DynamicUrlWebView: Page finished loading: $url");
            // Detect form URL dynamically
            if (!isFormUrlHandled && url.contains("https://api.betonline")) {
              print("DynamicUrlWebView: second url 2");
              isFormUrlHandled = true;
              _handleFormUrl(url);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.firstUrl)); // Load the first URL
  }

  // Handle the form URL and autofill the data
  void _handleFormUrl(String url) async {
    print("DynamicUrlWebView: Form URL detected: $url");

    // Generate JavaScript for autofill and form submission
    String jsCode = _generateJavaScript(widget.formData);

    // Execute JavaScript in WebView
    await _controller.runJavaScript(jsCode);
    //await _controller.runJavaScript(_generateJavaScript2());

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

     /* jsBuffer.writeln(
        '''setTimeout(function() {
        document.getElementById("$fieldId").disabled = false;
        }, 1000); ''',
      );*/
    });
    jsBuffer.writeln('setTimeout(function () {');
    jsBuffer.writeln('document.getElementById("btnsubmit").disabled = false;');
    jsBuffer.writeln('document.querySelector("form").submit();');
    jsBuffer.writeln('}, 5000);');

    jsBuffer.writeln(

    );

    // Submit the form
/*    jsBuffer.writeln(
        'document.querySelector("form").submit();');*/
    print("DynamicUrlWebView: inject ${jsBuffer.toString()}");
    return jsBuffer.toString();
  }
  String _generateJavaScript2() {
    final StringBuffer jsBuffer = StringBuffer();

    jsBuffer.writeln(
      '''setTimeout(function() {
        document.getElementById(\'btnsubmit\').disabled = false;
        }, 1000); ''',
    );

    // Submit the form
    jsBuffer.writeln(
        'document.querySelector("form").submit();');
    print("DynamicUrlWebView: inject ${jsBuffer.toString()}");
    return jsBuffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dynamic URL WebView")),
      body: WebViewWidget(controller: _controller), // Use WebViewWidget
    );
  }
}
