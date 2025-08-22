import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:totalpay_checkout_sdk/src/models/payment_request.dart';
import 'package:totalpay_checkout_sdk/src/totalpay_sdk.dart';

class HashUtil {
  /// Standard hash: SHA1(MD5(order_number + amount + currency + description + password).upper)
  static String generateHash({
    required PaymentRequest request,
    required String password,
  }) {
    final raw = (request.order.number +
            request.order.amount +
            request.order.currency +
            request.order.description +
            password)
        .toUpperCase();

    TotalPaySdk().debugLog("Raw string before hashing: $raw");

    final md5Digest = md5.convert(utf8.encode(raw)).toString();
    TotalPaySdk().debugLog("MD5 Hash: $md5Digest");

    final sha1Digest = sha1.convert(utf8.encode(md5Digest)).toString();
    TotalPaySdk().debugLog("Final SHA1 Hash: $sha1Digest");

    return sha1Digest;
  }

  /// Recurring hash: SHA1(MD5(transId + token + order.number + order.amount + order.description + password).upper)
  static String generateRecurringHash({
    required String transId,
    required String token,
    required Order order,
    required String password,
  }) {
    final raw = (transId +
            token +
            order.number +
            order.amount +
            order.description +
            password)
        .toUpperCase();

    TotalPaySdk().debugLog("Recurring raw string: $raw");

    final md5Digest = md5.convert(utf8.encode(raw)).toString();
    TotalPaySdk().debugLog("Recurring MD5 Hash: $md5Digest");

    final sha1Digest = sha1.convert(utf8.encode(md5Digest)).toString();
    TotalPaySdk().debugLog("Recurring SHA1 Hash: $sha1Digest");

    return sha1Digest;
  }

  /// Transaction status hash: SHA1(MD5(transactionId + password).upper)
  static String generateStatusHash({
    required String transactionId,
    required String password,
  }) {
    final raw = (transactionId + password).toUpperCase();

    TotalPaySdk().debugLog("Status raw string: $raw");

    final md5Digest = md5.convert(utf8.encode(raw)).toString();
    TotalPaySdk().debugLog("Status MD5 Hash: $md5Digest");

    final sha1Digest = sha1.convert(utf8.encode(md5Digest)).toString();
    TotalPaySdk().debugLog("Status SHA1 Hash: $sha1Digest");

    return sha1Digest;
  }
}
