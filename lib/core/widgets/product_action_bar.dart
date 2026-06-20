import 'package:flutter/material.dart';

import '../design/app_spacing.dart';
import '../helpers/currency_helper.dart';

class ProductActionBar extends StatelessWidget {
  const ProductActionBar({
    required this.price,
    required this.isAddedToCart,
    required this.onAddToCart,
    required this.onGoToCart,
    required this.onBuyNow,
    super.key,
  });

  final double price;
  final bool isAddedToCart;
  final VoidCallback onAddToCart;
  final VoidCallback onGoToCart;
  final VoidCallback onBuyNow;

  @override
  Widget build(BuildContext context) {
    final inrPrice = CurrencyHelper.convertToINR(price);
    final monthlyEMI = CurrencyHelper.calculateEMI(inrPrice, 12);

    return SafeArea(
      minimum: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isAddedToCart) ...[
            // EMI option
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'EMI available starting ${CurrencyHelper.formatINR(monthlyEMI)}/month',
                    ),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text('Buy with EMI'),
            ),
            const SizedBox(height: AppSpacing.md),
            // Add to cart and Buy buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onAddToCart,
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Add to Cart'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onBuyNow,
                    icon: const Icon(Icons.flash_on),
                    label: Text(CurrencyHelper.formatINR(inrPrice)),
                  ),
                ),
              ],
            ),
          ] else
            // When item is in cart
            FilledButton.icon(
              onPressed: onGoToCart,
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Go to Cart'),
            ),
        ],
      ),
    );
  }
}
