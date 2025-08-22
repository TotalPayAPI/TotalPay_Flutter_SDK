import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:totalpay_checkout_sdk/src/models/payment_request.dart';
import 'package:totalpay_checkout_sdk/src/models/payment_response.dart';
import 'package:totalpay_checkout_sdk/src/utils/hash_util.dart';
import '../totalpay_sdk.dart';

class PaymentService {
  /// Start a one-time or recurring init payment
  Future<PaymentResponse> initiatePayment(PaymentRequest request) async {
    final hash = HashUtil.generateHash(
      request: request,
      password: TotalPaySdk().merchantPassword,
    );

    final payload = request
        .copyWith(
          merchantKey: TotalPaySdk().merchantKey,
          hash: hash,
        )
        .toJson();

    TotalPaySdk().debugLog('Sending Payload: ${jsonEncode(payload)}');
    TotalPaySdk().debugLog('Sending request...');

    try {
      final response = await http
          .post(
            Uri.parse('https://checkout.totalpay.global/api/v1/session'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final rawRedirect = decoded['redirect_url'];

      TotalPaySdk().debugLog('MANUAL REDIRECT VALUE: $rawRedirect');
      TotalPaySdk().debugLog(
          'REDIRECT SHA1: ${sha1.convert(utf8.encode(rawRedirect ?? ''))}');

      try {
        log('Decoded body: ${decoded.toString()}');
        TotalPaySdk().debugLog('API response: ${response.body}');

        if (response.statusCode == 200) {
          final isSuccess =
              decoded['success']?.toString().toLowerCase() == 'true' ||
                  (rawRedirect != null && rawRedirect.toString().isNotEmpty);

          final base = PaymentResponse.fromJson(decoded);

          final result = base.copyWith(
            success: isSuccess,
            redirectUrl: rawRedirect,
            cookies: response.headers['set-cookie'],
          );

          return result;
        } else {
          return PaymentResponse(
            success: false,
            message: decoded['error_message'] ?? 'Unexpected error',
            errors: decoded['errors'] != null
                ? List<Map<String, dynamic>>.from(decoded['errors'])
                : null,
          );
        }
      } catch (e, stack) {
        print('JSON decode failed: $e');
        print('Stack trace: $stack');
        return PaymentResponse(
          success: false,
          message: 'Failed to parse response body',
        );
      }
    } catch (e, stack) {
      print('HTTP Exception: $e');
      print('Stack Trace: $stack');
      return PaymentResponse(
        success: false,
        message: 'Exception occurred: $e',
      );
    }
  }

  /// Fetch transaction status 
  Future<PaymentResponse> getTransactionStatus(String paymentId) async {
    final payload = {
      'merchant_key': TotalPaySdk().merchantKey,
      'payment_id': paymentId, 
    };
  
    final hash = HashUtil.generateStatusHash(
      paymentId: paymentId,
      password: TotalPaySdk().merchantPassword,
    );
    payload['hash'] = hash;
  
    try {
      final response = await http.post(
        Uri.parse('https://checkout.totalpay.global/api/v1/payment/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
  
      final decoded = jsonDecode(response.body);
      TotalPaySdk().debugLog('Payment Status Response: $decoded');
  
      return PaymentResponse.fromJson(decoded);
    } catch (e, stack) {
      print('Status Check Exception: $e');
      print(stack);
      return PaymentResponse(
        success: false,
        message: 'Status check failed: $e',
      );
    }
  }
  
  /// Make recurring payment using token + init transaction ID
  Future<PaymentResponse> makeRecurringPayment({
    required String recurringToken,
    required String recurringInitTransId,
    required Order order,
    required Customer customer,
  }) async {
    final payload = {
      'merchant_key': TotalPaySdk().merchantKey,
      'recurring_token': recurringToken,
      'recurring_init_trans_id': recurringInitTransId,
      'order': order.toJson(),
      'customer': customer.toJson(),
    };

    final hash = HashUtil.generateRecurringHash(
      token: recurringToken,
      transId: recurringInitTransId,
      order: order,
      password: TotalPaySdk().merchantPassword,
    );

    payload['hash'] = hash;

    TotalPaySdk().debugLog('Recurring Payload: ${jsonEncode(payload)}');

    try {
      final response = await http
          .post(
            Uri.parse(
                'https://checkout.totalpay.global/api/v1/payment/recurring'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 10));

      TotalPaySdk().debugLog('Recurring API Status: ${response.statusCode}');
      TotalPaySdk().debugLog('Recurring Body: ${response.body}');

      final decoded = jsonDecode(response.body);
      return PaymentResponse.fromJson(decoded);
    } catch (e) {
      print('Recurring Payment Exception: $e');
      return PaymentResponse(
        success: false,
        message: 'Recurring exception occurred: $e',
      );
    }
  }
}
