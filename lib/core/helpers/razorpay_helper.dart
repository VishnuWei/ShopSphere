/// Razorpay Payment Helper
/// Handles payment processing integration
///
/// Note: In production, add razorpay_flutter package to pubspec.yaml
/// For demo, this simulates the payment flow
class RazorpayHelper {
  // Demo credentials (replace with real in production)
  static const String demoKeyId = 'rzp_live_ILBRLBRLBRLBxxxx';
  static const String merchantId = 'MERCHANT_ID';

  /// Initialize Razorpay payment
  /// Returns success/failure status
  static Future<RazorpayPaymentResult> initiatePayment({
    required String orderId,
    required double amount,
    required String customerEmail,
    required String customerPhone,
    required String description,
  }) async {
    try {
      // In production, use actual Razorpay SDK
      // For demo, simulate successful payment

      final paymentDetails = RazorpayPaymentDetails(
        orderId: orderId,
        amount: amount,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
        description: description,
        timestamp: DateTime.now(),
        transactionId: _generateTransactionId(),
        paymentMethod: 'card', // In demo, always card
      );

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      return RazorpayPaymentResult(
        success: true,
        transactionId: paymentDetails.transactionId,
        message: 'Payment successful!',
        paymentDetails: paymentDetails,
      );
    } catch (e) {
      return RazorpayPaymentResult(
        success: false,
        transactionId: null,
        message: 'Payment failed: $e',
        paymentDetails: null,
      );
    }
  }

  /// Generate order ID
  static String generateOrderId() {
    return 'ORD_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Generate transaction ID
  static String _generateTransactionId() {
    return 'TXN_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Calculate total amount with taxes
  static Map<String, double> calculateTotalWithTax(double subtotal) {
    const taxRate = 0.18; // 18% GST
    const shippingCharge = 0.0; // Free shipping

    final tax = subtotal * taxRate;
    final total = subtotal + tax + shippingCharge;

    return {
      'subtotal': subtotal,
      'tax': tax,
      'shipping': shippingCharge,
      'total': total,
    };
  }

  /// Format amount for Razorpay (in paise)
  static int formatAmountForPayment(double amount) {
    return (amount * 100).toInt(); // Convert to paise
  }

  /// Format payment methods display
  static List<String> getAvailablePaymentMethods() {
    return [
      'Credit Card',
      'Debit Card',
      'Net Banking',
      'Wallet',
      'UPI',
    ];
  }
}

/// Payment details model
class RazorpayPaymentDetails {
  final String orderId;
  final double amount;
  final String customerEmail;
  final String customerPhone;
  final String description;
  final DateTime timestamp;
  final String transactionId;
  final String paymentMethod;

  RazorpayPaymentDetails({
    required this.orderId,
    required this.amount,
    required this.customerEmail,
    required this.customerPhone,
    required this.description,
    required this.timestamp,
    required this.transactionId,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'amount': amount,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'transactionId': transactionId,
      'paymentMethod': paymentMethod,
    };
  }
}

/// Payment result model
class RazorpayPaymentResult {
  final bool success;
  final String? transactionId;
  final String message;
  final RazorpayPaymentDetails? paymentDetails;

  RazorpayPaymentResult({
    required this.success,
    required this.transactionId,
    required this.message,
    required this.paymentDetails,
  });
}
