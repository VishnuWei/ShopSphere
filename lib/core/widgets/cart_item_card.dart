import 'package:flutter/material.dart';
import '../helpers/currency_helper.dart';

/// Premium cart item card with quantity controls
/// Features:
/// - Product image
/// - Product name & price
/// - Quantity controls (+/-)
/// - Remove button
/// - Total price calculation
/// - Clean border design
class CartItemCard extends StatelessWidget {
  final String productId;
  final String image;
  final String name;
  final double price;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    required this.productId,
    required this.image,
    required this.name,
    required this.price,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final inrPrice = CurrencyHelper.convertToINR(price);
    final totalPrice = inrPrice * quantity;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surface,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 100,
                height: 100,
                color: colorScheme.surfaceContainer,
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          colorScheme.primary,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.broken_image_outlined,
                      size: 40,
                      color: colorScheme.outline,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  const SizedBox(height: 8),

                  // Price
                  Text(
                    CurrencyHelper.formatINR(inrPrice),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  const SizedBox(height: 12),

                  // Quantity Controls & Remove Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity Controls
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: colorScheme.outlineVariant,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Decrease Button
                            InkWell(
                              onTap: quantity > 1 ? onDecrement : null,
                              child: Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.remove,
                                  size: 16,
                                  color: quantity > 1
                                      ? colorScheme.primary
                                      : colorScheme.outline,
                                ),
                              ),
                            ),

                            // Divider
                            Container(
                              width: 1,
                              height: 24,
                              color: colorScheme.outlineVariant,
                            ),

                            // Quantity Display
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              child: Text(
                                quantity.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),

                            // Divider
                            Container(
                              width: 1,
                              height: 24,
                              color: colorScheme.outlineVariant,
                            ),

                            // Increase Button
                            InkWell(
                              onTap: onIncrement,
                              child: Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.add,
                                  size: 16,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Remove Button
                      IconButton(
                        onPressed: onRemove,
                        icon: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Total Price (vertical)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyHelper.formatINR(totalPrice),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
