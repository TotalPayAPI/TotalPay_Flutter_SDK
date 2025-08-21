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

  // New response fields
  final String? paymentId;
  final String? orderId;
  final String? refundedAmount;
  final String? voided;
  final String? retryStatus;

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
    this.paymentId,
    this.orderId,
    this.refundedAmount,
    this.voided,
    this.retryStatus,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    final session = json['session'];
    final rawRedirect = json['redirect_url'];

    // check nested transaction/data objects
    final transaction = json['transaction'] ?? json['data'] ?? {};
    // Handle possible nesting under "transaction" or "data"
    //final transaction = json['transaction'] ?? {};
    final recurringToken = json['recurring_token']?.toString() ??
        transaction['recurring_token']?.toString();
    final recurringInitTransId = json['recurring_init_trans_id']?.toString() ??
        transaction['recurring_init_trans_id']?.toString();

    debugPrint("Extracted recurring_token: $recurringToken");
    debugPrint("Extracted recurring_init_trans_id: $recurringInitTransId");

    return PaymentResponse(
      success: json['success']?.toString().toLowerCase() == 'true' ||
          (json['redirect_url'] != null &&
              json['redirect_url'].toString().isNotEmpty),
      transactionId: recurringInitTransId ??
          json['transaction_id']?.toString() ??
          transaction['id']?.toString(),
      status: json['status']?.toString() ?? transaction['status']?.toString(),
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
      paymentId: json['payment_id']?.toString() ?? transaction['payment_id']?.toString(),
      orderId: json['order_id']?.toString() ?? transaction['order_id']?.toString(),
      refundedAmount: json['refunded_amount']?.toString(),
      voided: json['voided']?.toString(),
      retryStatus: json['retry_status']?.toString(),
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
    String? paymentId,
    String? orderId,
    String? refundedAmount,
    String? voided,
    String? retryStatus,
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
      paymentId: paymentId ?? this.paymentId,
      orderId: orderId ?? this.orderId,
      refundedAmount: refundedAmount ?? this.refundedAmount,
      voided: voided ?? this.voided,
      retryStatus: retryStatus ?? this.retryStatus,
    );
  }
}
