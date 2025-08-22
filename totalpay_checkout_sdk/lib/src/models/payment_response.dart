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

  // Extra response fields
  final String? channelId;
  final bool? reqToken;
  final List<String>? cardToken;
  final String? scheduleId;
  final bool? vatCalc;

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
    this.channelId,
    this.reqToken,
    this.cardToken,
    this.scheduleId,
    this.vatCalc,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    final session = json['session'];
    final rawRedirect = json['redirect_url'];

    final transaction = json['transaction'] ?? json['data'] ?? {};

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
          json['transaction_id']?.toString(),
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      redirectUrl: rawRedirect is String ? rawRedirect : '',
      sessionId: session != null ? session['id']?.toString() : null,
      token: recurringToken ?? json['token']?.toString(),
      cardBrand: json['card_brand']?.toString(),
      recurringToken: recurringToken,
      recurringInitTransId: recurringInitTransId,
      channelId: json['channel_id']?.toString(),
      reqToken: json['req_token'] == true,
      cardToken: (json['card_token'] is List)
          ? List<String>.from(json['card_token'])
          : null,
      scheduleId: json['schedule_id']?.toString(),
      vatCalc: json['vat_calc'] == true,
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
    String? channelId,
    bool? reqToken,
    List<String>? cardToken,
    String? scheduleId,
    bool? vatCalc,
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
      channelId: channelId ?? this.channelId,
      reqToken: reqToken ?? this.reqToken,
      cardToken: cardToken ?? this.cardToken,
      scheduleId: scheduleId ?? this.scheduleId,
      vatCalc: vatCalc ?? this.vatCalc,
    );
  }
}
