/// Currency formatting helper for Indian Rupee (₹)
class CurrencyHelper {
  /// Converts dollar amount to INR
  /// Default: 1 USD = 100 INR
  static double convertToINR(double dollarAmount, {double rate = 100}) {
    return dollarAmount * rate;
  }

  /// Formats a number to INR currency string
  /// Example: 4999 → "₹4,999"
    static String formatINR(double amount) {
      final inr = amount.toInt();
      return '₹${_addCommas(inr)}';
    }

  /// Formats with decimal places
  /// Example: 4999.99 → "₹4,999.99"
  static String formatINRWithDecimal(double amount, {int decimals = 2}) {
    final formatted = amount.toStringAsFixed(decimals);
    final parts = formatted.split('.');
    final intPart = _addCommas(int.parse(parts[0]));
    return decimals > 0 ? '₹$intPart.${parts[1]}' : '₹$intPart';
  }

  /// Calculates discount percentage
  /// Example: original=500, discounted=250 → 50
  static int getDiscountPercentage(double original, double discounted) {
    if (original == 0) return 0;
    return ((original - discounted) / original * 100).round();
  }

  /// Calculates EMI amount
  /// Example: amount=12000, months=3 → 4000
  static double calculateEMI(double amount, int months) {
    return amount / months;
  }

  /// Adds thousand separators to number
  /// Example: 4999 → "4,999"
  static String _addCommas(int number) {
    final str = number.toString();
    final regex = RegExp(r'(\d)(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(regex, (match) => '${match[1]},');
  }

  /// Get formatted EMI breakdown
  /// Returns: {months: ₹amount, ...}
  static Map<int, String> getEMIBreakdown(double amount) {
    return {
      3: formatINR(calculateEMI(amount, 3)),
      6: formatINR(calculateEMI(amount, 6)),
      12: formatINR(calculateEMI(amount, 12)),
    };
  }

  /// Calculate savings amount
  static double calculateSavings(double original, double discounted) {
    return original - discounted;
  }

  /// Format savings display
  static String formatSavings(double original, double discounted) {
    final savings = calculateSavings(original, discounted);
    final percentage = getDiscountPercentage(original, discounted);
    return 'Save ${formatINR(savings)} ($percentage% off)';
  }
}
