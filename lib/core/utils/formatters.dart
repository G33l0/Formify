import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class Formatters {
  // Format currency with symbol
  static String formatCurrency(double amount, String currencyCode) {
    final symbol = AppConstants.currencySymbols[currencyCode] ?? currencyCode;
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  // Format date
  static String formatDate(DateTime date, {String? format}) {
    final dateFormat = DateFormat(format ?? AppConstants.dateFormat);
    return dateFormat.format(date);
  }

  // Format date time
  static String formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat(AppConstants.dateTimeFormat);
    return dateFormat.format(dateTime);
  }

  // Generate document number
  static String generateDocumentNumber(String prefix, int count) {
    return '$prefix-${(count + 1).toString().padLeft(4, '0')}';
  }

  // Format phone number
  static String formatPhoneNumber(String phone) {
    // Simple formatting - can be enhanced based on country code
    return phone.replaceAll(RegExp(r'\D'), '');
  }

  // Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate phone
  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-]{8,}$').hasMatch(phone);
  }

  // Parse double safely
  static double parseDouble(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0;
    }
  }

  // Parse int safely
  static int parseInt(String value) {
    try {
      return int.parse(value);
    } catch (e) {
      return 0;
    }
  }
}
