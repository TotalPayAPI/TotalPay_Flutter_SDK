import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:totalpay_checkout_sdk/src/models/payment_request.dart';
import 'package:totalpay_checkout_sdk/src/totalpay_sdk.dart';

class HashUtil {
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
    //print("MD5 Hash: $md5Digest");

    final sha1Digest = sha1.convert(utf8.encode(md5Digest)).toString();
    TotalPaySdk().debugLog("Final SHA1 Hash: $sha1Digest");
    //print("Final SHA1 Hash: $sha1Digest");

    return sha1Digest;
  }

  static String generateRecurringHash({
    required String token,
    required String transId,
    required Order order,
    required Customer customer,
    required String password,
  }) {
    final raw = (order.number +
            order.amount +
            order.currency +
            token +
            transId +
            customer.email +
            password)
        .toUpperCase();

    TotalPaySdk().debugLog("Recurring raw string: $raw");

    final md5Digest = md5.convert(utf8.encode(raw)).toString();
    TotalPaySdk().debugLog("Recurring MD5 Hash: $md5Digest");
    //print("Recurring MD5 Hash: $md5Digest");

    final sha1Digest = sha1.convert(utf8.encode(md5Digest)).toString();
    TotalPaySdk().debugLog("Recurring SHA1 Hash: $sha1Digest");
    //print("Recurring SHA1 Hash: $sha1Digest");

    return sha1Digest;
  }
}
