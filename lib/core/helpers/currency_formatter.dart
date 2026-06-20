class CurrencyFormatter {
  static const String inrSymbol = '₹';

  /// Format double to INR currency string
  /// Example: 2499.0 → "₹2,499"
  static String formatINR(double amount, {bool showSymbol = true}) {
    final intAmount = amount.toInt();
    final formatted = _formatNumberWithCommas(intAmount);
    return showSymbol ? '$inrSymbol$formatted' : formatted;
  }

  /// Format with decimal places
  /// Example: 2499.99 → "₹2,499.99"
  static String formatINRWithDecimal(double amount, {bool showSymbol = true}) {
    final formatted = amount.toStringAsFixed(2);
    final parts = formatted.split('.');
    final intPart = _formatNumberWithCommas(int.parse(parts[0]));
    final decimalPart = parts[1];
    final result = '$intPart.$decimalPart';
    return showSymbol ? '$inrSymbol$result' : result;
  }

  /// Format with custom prefix like "From", "Upto"
  /// Example: (2499, "From") → "From ₹2,499"
  static String formatINRWithPrefix(double amount, String prefix) {
    return '$prefix ${formatINR(amount)}';
  }

  /// Parse formatted string back to double
  static double parseINR(String formatted) {
    return double.parse(
      formatted.replaceAll(inrSymbol, '').replaceAll(',', '').trim(),
    );
  }

  /// Format price range
  /// Example: (1000, 5000) → "₹1,000 - ₹5,000"
  static String formatPriceRange(double minPrice, double maxPrice) {
    return '${formatINR(minPrice)} - ${formatINR(maxPrice)}';
  }

  /// Format discount amount
  /// Example: (5000, 1000) → "₹4,000 off"
  static String formatDiscount(double original, double discounted) {
    final discount = original - discounted;
    return '${formatINR(discount)} off';
  }

  /// Calculate and format discount percentage
  /// Example: (5000, 2500) → "-50%"
  static String formatDiscountPercentage(double original, double discounted) {
    final percentage = ((original - discounted) / original * 100).toInt();
    return '-$percentage%';
  }

  /// Helper method to format number with commas
  static String _formatNumberWithCommas(int number) {
    final str = number.toString();
    if (str.length <= 3) return str;

    final reversed = str.split('').reversed.toList();
    final parts = <String>[];

    for (int i = 0; i < reversed.length; i += 3) {
      final end = (i + 3 > reversed.length) ? reversed.length : i + 3;
      parts.add(reversed.sublist(i, end).reversed.join());
    }

    return parts.reversed.join(',');
  }
}
