import 'package:flutter/material.dart';
//import 'dart:convert';
//import 'package:crypto/crypto.dart';
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
  bool _isRecurringInit = true;
  String? savedToken;
  String? savedTransactionId;

  Future<void> _startPayment() async {
    if (!_isRecurringInit &&
        (savedToken == null || savedTransactionId == null)) {
      _showDialog("Missing Info", "Please complete a recurring init first.");
      return;
    }

    setState(() => _isLoading = true);

    final order = Order(
      number: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: "100.00",
      currency: "AED",
      description: _isRecurringInit
          ? "Recurring Init Payment"
          : "Recurring Charge",
    );

    final customer = Customer(name: "Test User", email: "test@gmail.com");

    final billingAddress = BillingAddress(
      country: "AE",
      city: "JVC",
      state: "Dubai",
      address: "Barsha",
      phone: "0505050505",
    );

    final request = PaymentRequest(
      merchantKey: TotalPaySdk().merchantKey,
      operation: _isRecurringInit ? "purchase" : "recurring",
      methods: ["card"],
      successUrl: "https://example.com/success",
      cancelUrl: "https://example.com/cancel",
      urlTarget: "_parent",
      hash: "",
      order: order,
      customer: customer,
      billingAddress: billingAddress,
      recurringInit: _isRecurringInit ? true : null,
      recurringToken: !_isRecurringInit ? savedToken : null,
      recurringInitTransId: !_isRecurringInit ? savedTransactionId : null,
    );

    try {
      final response = await PaymentService().initiatePayment(request);

      if (response.recurringToken != null &&
          response.recurringInitTransId != null) {
        savedToken = response.recurringToken!;
        savedTransactionId = response.recurringInitTransId!;
        print("Saved recurring token: $savedToken");
        print("Saved recurring txn ID: $savedTransactionId");
      } else {
        print("Token or transaction ID missing in recurring init response.");
      }

      if (response.success && response.redirectUrl != null) {
        final fullRedirect = response.redirectUrl!.startsWith("http")
            ? response.redirectUrl!
            : "https://checkout.totalpay.global${response.redirectUrl}";

        final result = await Navigator.push<String?>(
          context,
          MaterialPageRoute(
            builder: (_) => CheckoutWebView(
              checkoutUrl: fullRedirect,
              cookieHeader: response.cookies,
              successUrl: request.successUrl,
              cancelUrl: request.cancelUrl,
            ),
          ),
        );

        print("Returned from WebView: $result");

        if (result == 'success') {
          _showDialog("Payment Success", "Transaction completed.");
        } else if (result == 'cancel') {
          _showDialog("Payment Cancelled", "Transaction was cancelled.");
        } else {
          _showDialog("Payment Failed", "Something went wrong.");
        }
      } else {
        _showDialog("Payment Error", response.message ?? "Unknown error.");
      }
    } catch (e) {
      _showDialog("Exception", e.toString());
    }

    if (mounted) setState(() => _isLoading = false);
  }

  void _showDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TotalPay Checkout")),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text("Recurring Init Mode"),
                    value: _isRecurringInit,
                    onChanged: (val) => setState(() => _isRecurringInit = val),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _startPayment,
                    child: const Text("Start Payment"),
                    // child: Text(
                    //   _isRecurringInit
                    //       ? "Start Recurring Init"
                    //       : "Use Saved Token",
                    // ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CheckoutWebView extends StatelessWidget {
  final String checkoutUrl;
  final String? cookieHeader;
  final String successUrl;
  final String cancelUrl;

  const CheckoutWebView({
    super.key,
    required this.checkoutUrl,
    required this.successUrl,
    required this.cancelUrl,
    this.cookieHeader,
  });

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final navUrl = request.url;
            print("Navigating to: $navUrl");

            if (navUrl.startsWith(successUrl)) {
              Navigator.pop(context, 'success');
              return NavigationDecision.prevent;
            }

            if (navUrl.startsWith(cancelUrl)) {
              Navigator.pop(context, 'cancel');
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(checkoutUrl));

    return Scaffold(
      appBar: AppBar(title: const Text("Secure Checkout")),
      body: WebViewWidget(controller: controller),
    );
  }
}
