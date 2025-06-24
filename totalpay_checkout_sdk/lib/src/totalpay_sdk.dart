class TotalPaySdk {
  static final TotalPaySdk _instance = TotalPaySdk._internal();

  factory TotalPaySdk() => _instance;

  late final String merchantKey;
  late final String merchantPassword;
  bool _initialized = false;
  bool _enableDebug = false;

  bool get isDebugEnabled => _enableDebug;

  TotalPaySdk._internal();

  void init({
    required String key,
    required String password,
    bool enableDebug = false,
  }) {
    merchantKey = key;
    merchantPassword = password;
    _enableDebug = enableDebug;
    _initialized = true;

    if (_enableDebug) {
      print('TotalPaySdk initialized with debug enabled');
    }
  }

  void _checkInitialization() {
    if (!_initialized) {
      throw Exception('TotalPaySdk is not initialized. Call init() first.');
    }
  }

  String get getMerchantKey {
    _checkInitialization();
    return merchantKey;
  }

  String get getMerchantPassword {
    _checkInitialization();
    return merchantPassword;
  }

  void debugLog(String message) {
    assert(() {
      print('[TotalPaySdk DEBUG]: $message');
      return true;
    }());
  }
}
