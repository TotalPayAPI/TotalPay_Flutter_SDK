# TotalPay Flutter SDK

The **TotalPay Flutter SDK** enables seamless integration of the TotalPay Payment Gateway [https://docs.totalpay.global/checkout_integration] into your Flutter mobile applications. It supports one-time payments, recurring billing, and tokenization through a secure WebView-based checkout flow.

---

## Features

- One-time card payments  
- Recurring payment support via tokenization (Kindly refer to https://docs.totalpay.global/checkout_integration#callback-parameters for return parameter of recurring/tokenization)  
- Card tokenization and reuse (Kindly refer to https://docs.totalpay.global/checkout_integration#callback-parameters for return parameter of card tokenization)
- WebView-based payment flow  
- Auto-generated secure hash  
- Custom success/cancel handling within your app  
- Lightweight and developer-friendly integration  

---

## Installation

### Step 1: Add SDK to `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter
  totalpay_checkout_sdk:
    git:
      url: https://github.com/TotalPayAPI/TotalPay_Flutter_SDK.git
      path: totalpay_checkout_sdk
  webview_flutter: ^4.2.2
```

Then run:

```bash
flutter pub get
```

---

## Android Setup

If you plan to support Google Pay in the future, configure the repositories now.

### In `android/build.gradle`:

```groovy
allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url 'https://jitpack.io' }
    }
}
```

### Or for Android Gradle Plugin 7.0+:

In `android/settings.gradle`:

```groovy
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        maven { url "https://jitpack.io" }
    }
}
```

### ProGuard (if enabled):

In `proguard-rules.pro`:

```proguard
-keep class com.totalpay.** { *; }
```

---

## iOS Setup

No additional configuration is required.


---

## Quick Start

### 1. Initialize SDK

```dart
TotalPaySdk().init(
  key: 'YOUR_MERCHANT_KEY',
  password: 'YOUR_MERCHANT_PASSWORD',
);
```

### 2. Create Payment Request

```dart
final paymentRequest = PaymentRequest(
  merchantKey: TotalPaySdk().merchantKey,
  operation: 'purchase',
  methods: ['card'],
  successUrl: 'https://yourdomain.com/success',
  cancelUrl: 'https://yourdomain.com/cancel',
  urlTarget: '_parent',
  hash: '', // Auto-generated internally
  order: Order(
    number: 'ORDER123',
    amount: '100.00',
    currency: 'AED',
    description: 'Test Payment',
  ),
  customer: Customer(
    name: 'John Doe',
    email: 'john@example.com',
  ),
  billingAddress: BillingAddress(
    country: 'AE',
    city: 'Dubai',
    state: 'Dubai',
    address: 'Business Bay',
    phone: '0500000000',
  ),
);
```

### 3. Start Payment

```dart
final response = await PaymentService().initiatePayment(paymentRequest);

if (response.success && response.redirectUrl != null) {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CheckoutWebView(
        checkoutUrl: response.redirectUrl!,
        cookieHeader: response.cookies,
      ),
    ),
  );

  if (result == 'success') {
    // Show payment success UI
  } else if (result == 'cancel') {
    // Show payment cancelled/failed UI
  }
}
```

---

## Recurring Payments

To initiate a recurring agreement:

```dart
final paymentRequest = PaymentRequest(
  ...
  recurringInit: true,
);
```

To charge a saved card later using the token and transaction ID:

```dart
final recurringRequest = PaymentRequest(
  ...
  operation: 'recurring',
  recurringToken: 'RECEIVED_TOKEN',
  recurringInitTransId: 'INITIAL_TRANSACTION_ID',
);
```

---

## Tokenization

When `recurringInit: true` is used, a `recurring_token` and `transaction_id` are returned in the response. These values can be stored securely and reused for recurring transactions without re-entering card data.

---

## Success / Cancel Handling

This SDK intercepts the redirect URLs from the WebView (such as `https://yourdomain.com/success`) and returns control back to the app.

Example:

```dart
final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CheckoutWebView(
      checkoutUrl: response.redirectUrl!,
      cookieHeader: response.cookies,
    ),
  ),
);

if (result == 'success') {
  // Navigate to your custom success screen
} else if (result == 'cancel') {
  // Navigate to failure/cancel screen
}
```

You don’t need to create any web pages at these URLs unless your backend requires them. These are only used to detect the status.

> You can use dummy URLs like `https://example.com/success` as placeholders if you're handling everything within the app.

---

## Optional Parameters

| Parameter                | Type      | Required | Description                                 |
|--------------------------|-----------|----------|---------------------------------------------|
| `recurringInit`          | `bool`    | Optional | Set to `true` to initialize recurring setup |
| `recurringToken`         | `String`  | Optional | Used for recurring transactions             |
| `recurringInitTransId`   | `String`  | Optional | Transaction ID from initial recurring txn   |

---

## API Reference

Official API documentation:  
[https://docs.totalpay.global/checkout_integration]

---

## License

MIT License © TotalPay

---

## Support

For technical issues, integration help, or feature requests, open a GitHub issue or contact your TotalPay integration manager.
