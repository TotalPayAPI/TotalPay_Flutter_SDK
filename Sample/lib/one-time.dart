import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:totalpay_checkout_sdk/totalpay_checkout_sdk.dart';

void main() {
  TotalPaySdk().init(
    key: 'YOUR_MERCHANT_CLIENT_KEY',
    password: 'YOUR_MERCHANT_CLIENT_PASSWORD',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TotalPay Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PaymentScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;

  Future<void> _startPayment() async {
    setState(() {
      _isLoading = true;
    });

    final order = Order(
      number: "ORDER123",
      amount: "0.19",
      currency: "AED",
      description: "Test Payment",
    );

    final customer = Customer(name: "Test User", email: "test@gmail.com");

    final billingAddress = BillingAddress(
      country: "US",
      city: "CA",
      state: "Los Angeles",
      address: "Moor Building 35274",
      phone: "0505050505",
    );

    final paymentRequest = PaymentRequest(
      merchantKey: TotalPaySdk().merchantKey,
      operation: "purchase",
      methods: ["card"],
      successUrl: "https://example.com/success",
      cancelUrl: "https://example.com/cancel",
      urlTarget: "_parent",
      hash: "", // Let PaymentService generate it
      order: order,
      customer: customer,
      billingAddress: billingAddress,
    );

    try {
      final response = await PaymentService().initiatePayment(paymentRequest);

      final redirect = response.redirectUrl ?? '';

      print("=== DEBUG REDIRECT URL ===");
      print("Redirect URL (first 100 chars): ${redirect.substring(0, 100)}");
      print(
        "Redirect URL (last 100 chars): ${redirect.substring(redirect.length - 100)}",
      );
      print("Redirect URL length: ${redirect.length}");
      print("Redirect URL SHA1: ${sha1.convert(utf8.encode(redirect))}");

      print("\nResponse Success: ${response.success}");
      print("Response Message: ${response.message}");
      print("Response Cookies: ${response.cookies}");

      if (redirect.isNotEmpty) {
        const baseUrl = "https://checkout.totalpay.global";
        String fullRedirect = redirect.startsWith("http")
            ? redirect
            : "$baseUrl$redirect";

        final result = await Navigator.push<String?>(
          context,
          MaterialPageRoute(
            builder: (_) => CheckoutWebView(
              checkoutUrl: fullRedirect,
              cookieHeader: response.cookies,
              successUrl: paymentRequest.successUrl,
              cancelUrl: paymentRequest.cancelUrl,
            ),
          ),
        );

        print("Returned from WebView: $result");

        if (result == 'success') {
          _showDialog('Payment Success', 'Your transaction was successful.');
        } else if (result == 'cancel') {
          _showDialog('Payment Cancelled', 'The payment was cancelled.');
        } else {
          _showDialog('Payment Failed', 'The payment was cancelled or failed.');
        }
      } else {
        _showDialog(
          'Payment Error',
          response.message ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      debugPrint('Payment exception: $e');
      _showDialog('Error', e.toString());
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDialog(String title, String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TotalPay Checkout')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _startPayment,
                child: const Text('Start Payment'),
              ),
      ),
    );
  }
}

class WebViewScaffoldPage extends StatelessWidget {
  final String url;

  const WebViewScaffoldPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Uri.parse(url).host)),
      body: WebViewWidget(
        controller: WebViewController()..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
