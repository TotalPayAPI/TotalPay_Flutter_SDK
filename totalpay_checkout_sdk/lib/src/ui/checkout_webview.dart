import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:totalpay_checkout_sdk/src/totalpay_sdk.dart';

class CheckoutWebView extends StatefulWidget {
  final String checkoutUrl;
  final String? cookieHeader;
  final String successUrl;
  final String cancelUrl;

  const CheckoutWebView({
    super.key,
    required this.checkoutUrl,
    this.cookieHeader,
    required this.successUrl,
    required this.cancelUrl,
  });

  @override
  State<CheckoutWebView> createState() => _CheckoutWebViewState();
}

class _CheckoutWebViewState extends State<CheckoutWebView> {
  WebViewController? _controller;
  //late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Set cookie if available
    final cookieManager = WebViewCookieManager();
    if (widget.cookieHeader != null) {
      final parts = widget.cookieHeader!.split(';')[0].split('=');
      if (parts.length == 2) {
        final name = parts[0].trim();
        final value = parts[1].trim();

        cookieManager.setCookie(WebViewCookie(
          name: name,
          value: value,
          domain: 'checkout.totalpay.global',
          path: '/',
        ));
      }
    }

    // Debug print
    final url = widget.checkoutUrl;
    final hash = sha1.convert(utf8.encode(url)).toString();
    TotalPaySdk().debugLog("WebView URL: $url");
    TotalPaySdk().debugLog("Length: ${url.length}, SHA1: $hash");
    //print("WebView URL: $url");
    //print("Length: ${url.length}, SHA1: $hash");

    // Init WebView
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final navUrl = request.url;
            TotalPaySdk().debugLog("Navigating to: $navUrl");
            //print("Navigating to: $navUrl");

            // Detect success URL and return to app
            if (navUrl.startsWith(widget.successUrl)) {
              print("Success URL detected. Returning to app...");
              Navigator.pop(context, 'success');
              return NavigationDecision.prevent;
            }

            // Detect cancel URL and return to app
            if (navUrl.startsWith(widget.cancelUrl)) {
              print("Cancel URL detected. Returning to app...");
              Navigator.pop(context, 'cancel');
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_controller != null) {
          final canGoBack = await _controller!.canGoBack();
          if (canGoBack) {
            _controller!.goBack();
            return false;
          }
        }

        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cancel Payment?'),
            content: const Text('Are you sure you want to cancel the payment?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );

        if (confirm == true) {
          Navigator.pop(context, 'cancel');
        }

        return false; // Prevent default pop
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Secure Payment")),
        body: _controller != null
            ? WebViewWidget(controller: _controller!)
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
