class PaymentRequest {
  final String merchantKey;
  final String operation;
  final List<String> methods;
  final String successUrl;
  final String cancelUrl;
  final String urlTarget;
  final String hash;
  final Order order;
  final Customer customer;
  final BillingAddress billingAddress;

  // recurring fields
  final bool? recurringInit;
  final String? recurringToken;
  final String? recurringInitTransId;

  // Extra fields 
  final String? channelId;
  final int? sessionExpiry;
  final String? expiryUrl;
  final String? errorUrl;
  final bool? reqToken;
  final List<String>? cardToken;
  final String? scheduleId;
  final bool? vatCalc;
  final Payee? payee;
  final PayeeBillingAddress? payeeBillingAddress;

  PaymentRequest({
    required this.merchantKey,
    required this.operation,
    required this.methods,
    required this.successUrl,
    required this.cancelUrl,
    required this.urlTarget,
    required this.hash,
    required this.order,
    required this.customer,
    required this.billingAddress,
    this.recurringInit,
    this.recurringToken,
    this.recurringInitTransId,
    this.channelId,
    this.sessionExpiry,
    this.expiryUrl,
    this.errorUrl,
    this.reqToken,
    this.cardToken,
    this.scheduleId,
    this.vatCalc,
    this.payee,
    this.payeeBillingAddress,
  });

  PaymentRequest copyWith({
    String? merchantKey,
    String? operation,
    List<String>? methods,
    String? successUrl,
    String? cancelUrl,
    String? urlTarget,
    String? hash,
    Order? order,
    Customer? customer,
    BillingAddress? billingAddress,
    bool? recurringInit,
    String? recurringToken,
    String? recurringInitTransId,
    String? channelId,
    int? sessionExpiry,
    String? expiryUrl,
    String? errorUrl,
    bool? reqToken,
    List<String>? cardToken,
    String? scheduleId,
    bool? vatCalc,
    Payee? payee,
    PayeeBillingAddress? payeeBillingAddress,
  }) {
    return PaymentRequest(
      merchantKey: merchantKey ?? this.merchantKey,
      operation: operation ?? this.operation,
      methods: methods ?? this.methods,
      successUrl: successUrl ?? this.successUrl,
      cancelUrl: cancelUrl ?? this.cancelUrl,
      urlTarget: urlTarget ?? this.urlTarget,
      hash: hash ?? this.hash,
      order: order ?? this.order,
      customer: customer ?? this.customer,
      billingAddress: billingAddress ?? this.billingAddress,
      recurringInit: recurringInit ?? this.recurringInit,
      recurringToken: recurringToken ?? this.recurringToken,
      recurringInitTransId: recurringInitTransId ?? this.recurringInitTransId,
      channelId: channelId ?? this.channelId,
      sessionExpiry: sessionExpiry ?? this.sessionExpiry,
      expiryUrl: expiryUrl ?? this.expiryUrl,
      errorUrl: errorUrl ?? this.errorUrl,
      reqToken: reqToken ?? this.reqToken,
      cardToken: cardToken ?? this.cardToken,
      scheduleId: scheduleId ?? this.scheduleId,
      vatCalc: vatCalc ?? this.vatCalc,
      payee: payee ?? this.payee,
      payeeBillingAddress: payeeBillingAddress ?? this.payeeBillingAddress,
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'merchant_key': merchantKey,
      'operation': operation,
      'methods': methods,
      'success_url': successUrl,
      'cancel_url': cancelUrl,
      'url_target': urlTarget,
      'hash': hash,
      'order': order.toJson(),
      'customer': customer.toJson(),
      'billing_address': billingAddress.toJson(),
    };

    // Recurring
    if (recurringInit != null) map['recurring_init'] = recurringInit!;
    if (recurringToken != null) map['recurring_token'] = recurringToken!;
    if (recurringInitTransId != null) {
      map['recurring_init_trans_id'] = recurringInitTransId!;
    }

    // Extras
    if (channelId != null) map['channel_id'] = channelId!;
    if (sessionExpiry != null) map['session_expiry'] = sessionExpiry!;
    if (expiryUrl != null) map['expiry_url'] = expiryUrl!;
    if (errorUrl != null) map['error_url'] = errorUrl!;
    if (reqToken != null) map['req_token'] = reqToken!;
    if (cardToken != null) map['card_token'] = cardToken!;
    if (scheduleId != null) map['schedule_id'] = scheduleId!;
    if (vatCalc != null) map['vat_calc'] = vatCalc!;
    if (payee != null) map['payee'] = payee!.toJson();
    if (payeeBillingAddress != null) {
      map['payee_billing_address'] = payeeBillingAddress!.toJson();
    }

    return map;
  }

  Map<String, String> toMap() {
    final map = {
      'merchant_key': merchantKey,
      'operation': operation,
      'methods': methods.join(','),
      'success_url': successUrl,
      'cancel_url': cancelUrl,
      'url_target': urlTarget,
      'hash': hash,
      'order_number': order.number,
      'order_amount': order.amount,
      'order_currency': order.currency,
      'order_description': order.description,
      'customer_name': customer.name,
      'customer_email': customer.email,
      'billing_country': billingAddress.country,
      'billing_city': billingAddress.city,
      'billing_state': billingAddress.state,
      'billing_address': billingAddress.address,
      'billing_phone': billingAddress.phone,
    };

    // Recurring
    if (recurringInit != null) map['recurring_init'] = recurringInit.toString();
    if (recurringToken != null) map['recurring_token'] = recurringToken!;
    if (recurringInitTransId != null) {
      map['recurring_init_trans_id'] = recurringInitTransId!;
    }

    // Extras (as strings)
    if (channelId != null) map['channel_id'] = channelId!;
    if (sessionExpiry != null) map['session_expiry'] = sessionExpiry.toString();
    if (expiryUrl != null) map['expiry_url'] = expiryUrl!;
    if (errorUrl != null) map['error_url'] = errorUrl!;
    if (reqToken != null) map['req_token'] = reqToken.toString();
    if (cardToken != null) map['card_token'] = cardToken!.join(',');
    if (scheduleId != null) map['schedule_id'] = scheduleId!;
    if (vatCalc != null) map['vat_calc'] = vatCalc.toString();

    return map;
  }
}

class Order {
  final String number;
  final String amount;
  final String currency;
  final String description;

  Order({
    required this.number,
    required this.amount,
    required this.currency,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'amount': amount,
      'currency': currency,
      'description': description,
    };
  }
}

class Customer {
  final String name;
  final String email;
  final String? birthDate;

  Customer({
    required this.name,
    required this.email,
    this.birthDate,
  });

  Map<String, dynamic> toJson() {
    final map = {
      'name': name,
      'email': email,
    };
    if (birthDate != null) map['birth_date'] = birthDate!;
    return map;
  }
}

class BillingAddress {
  final String country;
  final String city;
  final String state;
  final String address;
  final String phone;
  final String? district;
  final String? houseNumber;
  final String? zip;

  BillingAddress({
    required this.country,
    required this.city,
    required this.state,
    required this.address,
    required this.phone,
    this.district,
    this.houseNumber,
    this.zip,
  });

  Map<String, dynamic> toJson() {
    final map = {
      'country': country,
      'city': city,
      'state': state,
      'address': address,
      'phone': phone,
    };
    if (district != null) map['district'] = district!;
    if (houseNumber != null) map['house_number'] = houseNumber!;
    if (zip != null) map['zip'] = zip!;
    return map;
  }
}

class Payee {
  final String name;
  final String? email;

  Payee({required this.name, this.email});

  Map<String, dynamic> toJson() {
    final map = {'name': name};
    if (email != null) map['email'] = email!;
    return map;
  }
}

class PayeeBillingAddress {
  final String country;
  final String city;
  final String state;
  final String address;
  final String? district;
  final String? houseNumber;
  final String? zip;

  PayeeBillingAddress({
    required this.country,
    required this.city,
    required this.state,
    required this.address,
    this.district,
    this.houseNumber,
    this.zip,
  });

  Map<String, dynamic> toJson() {
    final map = {
      'country': country,
      'city': city,
      'state': state,
      'address': address,
    };
    if (district != null) map['district'] = district!;
    if (houseNumber != null) map['house_number'] = houseNumber!;
    if (zip != null) map['zip'] = zip!;
    return map;
  }
}
