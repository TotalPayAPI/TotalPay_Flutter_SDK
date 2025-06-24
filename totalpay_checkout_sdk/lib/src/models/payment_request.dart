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
  final bool? recurringInit;
  final String? recurringToken;
  final String? recurringInitTransId;

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

    if (recurringInit != null) {
      map['recurring_init'] = recurringInit!;
    }
    if (recurringToken != null) {
      map['recurring_token'] = recurringToken!;
    }
    if (recurringInitTransId != null) {
      map['recurring_init_trans_id'] = recurringInitTransId!;
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

    if (recurringInit != null) map['recurring_init'] = recurringInit.toString();
    if (recurringToken != null) map['recurring_token'] = recurringToken!;
    if (recurringInitTransId != null)
      map['recurring_init_trans_id'] = recurringInitTransId!;

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

  Customer({
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}

class BillingAddress {
  final String country;
  final String city;
  final String state;
  final String address;
  final String phone;

  BillingAddress({
    required this.country,
    required this.city,
    required this.state,
    required this.address,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'city': city,
      'state': state,
      'address': address,
      'phone': phone,
    };
  }
}
