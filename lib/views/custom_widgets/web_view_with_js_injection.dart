import 'dart:math';

import 'package:bet_online_latest_odds/data/entity/configuration_entity.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWithJsInjection extends StatefulWidget {
  final String url;
  final Map<String, dynamic> configuration;

  const WebViewWithJsInjection({
    Key? key,
    required this.url,
    required this.configuration,
  }) : super(key: key);

  @override
  StateX<WebViewWithJsInjection> createState() => _WebViewWithJsInjectionState();
}

class _WebViewWithJsInjectionState extends StateX<WebViewWithJsInjection> {
  late WebViewController _controller;
  Map<String, List<String>> _jsScripts = {};
  bool _canGoBack = false;
  bool _isScriptLoaded = false;

  @override
  void initState() {
    super.initState();
    _extractJavaScriptScripts();
    _initWebView();
  }

  void _extractJavaScriptScripts() {
    _jsScripts = {};
    widget.configuration.forEach((key, value) {
      if (key.startsWith('INJECT_JS_ON_')) {
        String stage = key.replaceAll('INJECT_JS_ON_', '');
        if (value is List) {
          _jsScripts[stage] = List<String>.from(value);
        }
      }
    });
  }

  Future<void> _injectJavaScriptList(List<String> scripts) async {
    for (String script in scripts) {
      try {
        await _controller.runJavaScript(script);
        print('Successfully injected script: ${script.substring(0, min(50, script.length))}...');
        print('_injectJavaScriptList Successfully injected script: ${script.substring(0, min(50, script.length))}...');
      } catch (e) {
        print('_injectJavaScriptList Error injecting JavaScript: $e');
      }
    }
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) async {
            if (_jsScripts.containsKey('START')) {
              await _injectJavaScriptList(_jsScripts['START']!);
            }
            _updateBackNavigationState();
          },
          onProgress: (int progress) async {
            if (_jsScripts.containsKey('PROGRESS')) {
              await _injectJavaScriptList(_jsScripts['PROGRESS']!);
            }
          },
          onPageFinished: (String url) async {
            _isScriptLoaded = true;
            if (_jsScripts.containsKey('LOAD')) {
              await _injectJavaScriptList(_jsScripts['LOAD']!);
            }
            if (_jsScripts.containsKey('END')) {
              await _injectJavaScriptList(_jsScripts['END']!);
            }
          },
          onNavigationRequest: (NavigationRequest request) async {
            print("webviewurl request: ${request.url}");
            print("webviewurl: ${widget.url}");
            if (request.url.contains(widget.url)) {
              // Allow navigation within the WebView
              return NavigationDecision.navigate;
            }
            else {
              if (_isScriptLoaded) {
                // Open in external browser
                if (await canLaunchUrl(Uri.parse(request.url)
                )) {
                  await launchUrl(Uri.parse(request.url),
                      mode: LaunchMode.externalApplication);
                }
                else {
                  await launchUrl(Uri.parse(request.url),
                      mode: LaunchMode.externalApplication);
                }
              }
              return NavigationDecision.prevent;
            }
            /*if (_jsScripts.containsKey('NAVIGATION_STATE_CHANGE')) {
              await _injectJavaScriptList(_jsScripts['NAVIGATION_STATE_CHANGE']!);
            }
            return NavigationDecision.navigate;*/
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    // Inject ON_START scripts immediately
    if (_jsScripts.containsKey('ON_START')) {
      _injectJavaScriptList(_jsScripts['ON_START']!);
    }
  }

  Future<void> _updateBackNavigationState() async {
    final canGoBack = await _controller.canGoBack();
    if (mounted && canGoBack != _canGoBack) {
      setState(() {
        _canGoBack = canGoBack;
      });
    }
  }

  Future<bool> _handleBackPressed() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false; // Don't exit the app
    }
    return true; // Allow app to exit
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackPressed,
      child: Scaffold(
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
