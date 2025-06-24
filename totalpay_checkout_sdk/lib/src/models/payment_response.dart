import 'package:flutter/foundation.dart';

class PaymentResponse {
  final bool success;
  final String? transactionId;
  final String? status;
  final String? message;
  final String? redirectUrl;
  final List<Map<String, dynamic>>? errors;
  final String? sessionId;
  final String? token;
  final String? cardBrand;
  final String? cookies;
  final String? recurringToken;
  final String? recurringInitTransId;

  PaymentResponse({
    required this.success,
    this.transactionId,
    this.status,
    this.message,
    this.redirectUrl,
    this.errors,
    this.sessionId,
    this.token,
    this.cardBrand,
    this.cookies,
    this.recurringToken,
    this.recurringInitTransId,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    final session = json['session'];
    final rawRedirect = json['redirect_url'];

    // Handle possible nesting under "transaction" or "data"
    final transaction = json['transaction'] ?? {};
    final recurringToken = json['recurring_token']?.toString() ??
        transaction['recurring_token']?.toString();
    final recurringInitTransId = json['recurring_init_trans_id']?.toString() ??
        transaction['recurring_init_trans_id']?.toString();

    // Debug logs to verify
    debugPrint("Extracted recurring_token: $recurringToken");
    debugPrint("Extracted recurring_init_trans_id: $recurringInitTransId");

    return PaymentResponse(
      success: json['success']?.toString().toLowerCase() == 'true' ||
          (json['redirect_url'] != null &&
              json['redirect_url'].toString().isNotEmpty),
      transactionId: recurringInitTransId ??
          json['transaction_id']
              ?.toString(), // prioritize recurring_init_trans_id
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      redirectUrl: rawRedirect is String ? rawRedirect : '',
      sessionId: session != null ? session['id']?.toString() : null,
      token: recurringToken ?? json['token']?.toString(),
      cardBrand: json['card_brand']?.toString(),
      recurringToken: recurringToken,
      recurringInitTransId: recurringInitTransId,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => Map<String, dynamic>.from(e))
          .toList(),
    );
  }

  PaymentResponse copyWith({
    bool? success,
    String? transactionId,
    String? status,
    String? message,
    String? redirectUrl,
    List<Map<String, dynamic>>? errors,
    String? sessionId,
    String? token,
    String? cardBrand,
    String? cookies,
    String? recurringToken,
    String? recurringInitTransId,
  }) {
    return PaymentResponse(
      success: success ?? this.success,
      transactionId: transactionId ?? this.transactionId,
      status: status ?? this.status,
      message: message ?? this.message,
      redirectUrl: redirectUrl ?? this.redirectUrl,
      errors: errors ?? this.errors,
      sessionId: sessionId ?? this.sessionId,
      token: token ?? this.token,
      cardBrand: cardBrand ?? this.cardBrand,
      cookies: cookies ?? this.cookies,
      recurringToken: recurringToken ?? this.recurringToken,
      recurringInitTransId: recurringInitTransId ?? this.recurringInitTransId,
    );
  }
}
