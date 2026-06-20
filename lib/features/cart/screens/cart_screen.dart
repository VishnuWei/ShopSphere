import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design/app_radius.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/helpers/currency_helper.dart';
import '../../../core/helpers/razorpay_helper.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/cart_item_card.dart';
import '../../orders/providers/orders_provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  static const routePath = '/cart';
  static const routeName = 'cart';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart'), elevation: 0),
      body: cart.isEmpty
          ? EmptyState(
              title: 'Your cart is empty',
              message: 'Start shopping to add products to your cart.',
              icon: Icons.shopping_cart_outlined,
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildCartList(context, ref, cart),
                      ),
                      Expanded(child: _buildOrderSummary(context, ref, cart)),
                    ],
                  );
                }

                return Column(
                  children: [
                    Expanded(child: _buildCartList(context, ref, cart)),
                    _buildOrderSummary(context, ref, cart),
                  ],
                );
              },
            ),
    );
  }

  void _handlePaymentProcess(
    BuildContext context,
    WidgetRef ref,
    dynamic cartState,
    double totalAmount,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) {
        Future.microtask(() {
          _processPaymentWithResult(
            pageContext: context,
            dialogContext: dialogContext,
            ref: ref,
            cartState: cartState,
            totalAmount: totalAmount,
          );
        });

        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing Payment...'),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _processPaymentWithResult({
    required BuildContext pageContext,
    required BuildContext dialogContext,
    required WidgetRef ref,
    required dynamic cartState,
    required double totalAmount,
  }) async {
    try {
      final result = await RazorpayHelper.initiatePayment(
        orderId: RazorpayHelper.generateOrderId(),
        amount: totalAmount,
        customerEmail: 'user@example.com',
        customerPhone: '+91XXXXXXXXXX',
        description: 'ShopSphere Purchase - ${cartState.items.length} items',
      );

      debugPrint('Payment Result: ${result.success}');

      debugPrint('Before closing loader');

      if (dialogContext.mounted) {
        Navigator.of(dialogContext, rootNavigator: true).pop();
      }

      debugPrint('After closing loader');

      await Future.delayed(const Duration(milliseconds: 150));

      debugPrint('pageContext mounted = ${pageContext.mounted}');
      debugPrint('dialogContext mounted = ${dialogContext.mounted}');

      if (!pageContext.mounted) return;

      if (result.success) {
        debugPrint('Opening success dialog');

        _showPaymentSuccess(pageContext, ref, result, cartState);
      } else {
        _showPaymentError(pageContext, result.message);
      }
    } catch (e, stackTrace) {
      debugPrint('Payment Error: $e');
      debugPrint(stackTrace.toString());

      if (dialogContext.mounted) {
        Navigator.of(dialogContext, rootNavigator: true).pop();
      }

      if (!pageContext.mounted) return;

      _showPaymentError(pageContext, 'Error: $e');
    }
  }

  void _showPaymentSuccess(
    BuildContext context,
    WidgetRef ref,
    RazorpayPaymentResult result,
    dynamic cartState,
  ) {
    showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 64,
                color: Theme.of(dialogContext).colorScheme.primary,
              ),
              const SizedBox(height: 16),

              const Text(
                'Payment Successful',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(
                    dialogContext,
                  ).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID',
                      style: Theme.of(dialogContext).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result.paymentDetails?.orderId ?? 'N/A',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Transaction ID',
                      style: Theme.of(dialogContext).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result.transactionId ?? 'N/A',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Amount Paid',
                      style: Theme.of(dialogContext).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${result.paymentDetails?.amount.toStringAsFixed(0) ?? '0'}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Theme.of(dialogContext).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    debugPrint('Adding order to ordersProvider');
                    // Convert cart items to order format
                    final orderItems = (cartState.items as List)
                        .map((item) => {
                              'productId': item.productId,
                              'title': item.title,
                              'price': item.price,
                              'quantity': item.quantity,
                              'thumbnail': item.thumbnail,
                              'total': item.price * item.quantity,
                            })
                        .toList()
                        .cast<Map<String, dynamic>>();

                    // Add order to orders list (now async)
                    // ignore: use_build_context_synchronously
                    await ref.read(ordersProvider.notifier).addOrder(
                          result.paymentDetails?.orderId ?? 'ORD_UNKNOWN',
                          result.transactionId ?? 'TXN_UNKNOWN',
                          result.paymentDetails?.amount ?? 0,
                          orderItems,
                        );
                    debugPrint('Order added successfully');

                    ref.read(cartProvider.notifier).clear();
                    debugPrint('Cart cleared');

                    Navigator.of(dialogContext).pop();
                    debugPrint('Success dialog closed');

                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                      debugPrint('Returned to home');
                    }
                  },
                  child: const Text('Continue Shopping'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentError(BuildContext context, String message) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.error,
          size: 48,
        ),
        title: const Text('Payment Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(
    BuildContext context,
    WidgetRef ref,
    dynamic cartState,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: cartState.items.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final item = cartState.items[index];
        return CartItemCard(
          productId: item.productId.toString(),
          image: item.thumbnail,
          name: item.title,
          price: item.price,
          quantity: item.quantity,
          onIncrement: () =>
              ref.read(cartProvider.notifier).increaseQuantity(item.productId),
          onDecrement: () =>
              ref.read(cartProvider.notifier).decreaseQuantity(item.productId),
          onRemove: () =>
              ref.read(cartProvider.notifier).removeItem(item.productId),
        );
      },
    );
  }

  Widget _buildOrderSummary(
    BuildContext context,
    WidgetRef ref,
    dynamic cartState,
  ) {
    final colorScheme = context.colorScheme;

    return SafeArea(
      minimum: const EdgeInsets.all(AppSpacing.lg),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Order Summary',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _SummaryRow(
                  label: 'Subtotal',
                  value: cartState.subtotal,
                  context: context,
                ),
                const SizedBox(height: AppSpacing.md),
                _SummaryRow(
                  label: 'Shipping',
                  value: 0,
                  context: context,
                  subtitle: 'Free',
                ),
                const SizedBox(height: AppSpacing.md),
                _SummaryRow(
                  label: 'Tax',
                  value: cartState.total - cartState.subtotal,
                  context: context,
                ),
                const SizedBox(height: AppSpacing.md),
                Divider(color: colorScheme.outlineVariant, thickness: 1),
                const SizedBox(height: AppSpacing.md),
                _SummaryRow(
                  label: 'Total',
                  value: cartState.total,
                  context: context,
                  isTotal: true,
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: () => _handleCheckout(context, ref, cartState),
                  child: const Text('Proceed to Checkout'),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Continue Shopping'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleCheckout(BuildContext context, WidgetRef ref, dynamic cartState) {
    final totalAmount = CurrencyHelper.convertToINR(cartState.total);

    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirm Payment',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      CurrencyHelper.formatINR(totalAmount),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'You will be redirected to Razorpay to complete the payment.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();

                        _handlePaymentProcess(
                          context,
                          ref,
                          cartState,
                          totalAmount,
                        );
                      },
                      child: const Text('Pay Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.context,
    this.isTotal = false,
    this.subtitle,
  });

  final String label;
  final double value;
  final BuildContext context;
  final bool isTotal;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        Text(
          CurrencyHelper.formatINR(CurrencyHelper.convertToINR(value)),
          style: isTotal
              ? context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colorScheme.primary,
                )
              : context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
        ),
      ],
    );
  }
}
