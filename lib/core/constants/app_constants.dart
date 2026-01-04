class AppConstants {
  // App Info
  static const String appName = 'Formify';
  static const String appTagline = 'Documents in Seconds';
  static const String appVersion = '1.0.0';

  // AdMob IDs (Replace with your actual AdMob IDs)
  static const String androidBannerAdId = 'ca-app-pub-3940256099942544/6300978111'; // Test ID
  static const String iosBannerAdId = 'ca-app-pub-3940256099942544/2934735716'; // Test ID
  static const String androidInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712'; // Test ID
  static const String iosInterstitialAdId = 'ca-app-pub-3940256099942544/4411468910'; // Test ID

  // In-App Purchase IDs (Replace with your actual product IDs)
  static const String premiumProductId = 'formify_premium_monthly';
  static const String premiumYearlyProductId = 'formify_premium_yearly';

  // URLs
  static const String privacyPolicyUrl = 'https://yourwebsite.com/privacy';
  static const String termsOfServiceUrl = 'https://yourwebsite.com/terms';
  static const String supportEmail = 'support@formify.app';

  // Limits
  static const int freePlanDocumentLimit = 10;
  static const int freePlanTemplateLimit = 3;

  // Watermark
  static const String watermarkText = 'Created with Formify';

  // Document Prefixes
  static const String invoicePrefix = 'INV';
  static const String receiptPrefix = 'RCP';
  static const String quotationPrefix = 'QUO';
  static const String contractPrefix = 'CNT';

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Supported Currencies
  static const List<String> supportedCurrencies = [
    'USD', 'EUR', 'GBP', 'INR', 'JPY', 'CNY', 'AUD', 'CAD', 'CHF', 'SEK',
    'NZD', 'SGD', 'HKD', 'NOK', 'KRW', 'TRY', 'RUB', 'BRL', 'ZAR', 'MXN',
    'AED', 'SAR', 'EGP', 'NGN', 'KES', 'PKR', 'BDT', 'PHP', 'IDR', 'MYR',
    'THB', 'VND'
  ];

  // Currency Symbols
  static const Map<String, String> currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'INR': '₹',
    'JPY': '¥',
    'CNY': '¥',
    'AUD': 'A\$',
    'CAD': 'C\$',
    'CHF': 'Fr',
    'SEK': 'kr',
    'NZD': 'NZ\$',
    'SGD': 'S\$',
    'HKD': 'HK\$',
    'NOK': 'kr',
    'KRW': '₩',
    'TRY': '₺',
    'RUB': '₽',
    'BRL': 'R\$',
    'ZAR': 'R',
    'MXN': 'Mex\$',
    'AED': 'د.إ',
    'SAR': 'ر.س',
    'EGP': 'E£',
    'NGN': '₦',
    'KES': 'KSh',
    'PKR': '₨',
    'BDT': '৳',
    'PHP': '₱',
    'IDR': 'Rp',
    'MYR': 'RM',
    'THB': '฿',
    'VND': '₫',
  };
}
