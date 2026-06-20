import 'package:flutter/material.dart';
import '../helpers/currency_helper.dart';

/// Premium product card for grid display (2-column layout)
/// Features:
/// - Centered product image
/// - Product name (2 lines max)
/// - Price in INR
/// - Rating badge
/// - Wishlist toggle button
/// - Clean border design
class PremiumProductCard extends StatelessWidget {
  final String productId;
  final String image;
  final String name;
  final double price;
  final double rating;
  final int reviewCount;
  final bool isInWishlist;
  final VoidCallback onTap;
  final VoidCallback? onWishlistToggle;

  const PremiumProductCard({
    required this.productId,
    required this.image,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.isInWishlist,
    required this.onTap,
    this.onWishlistToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final inrPrice = CurrencyHelper.convertToINR(price);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: colorScheme.surface,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Container
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(11),
                        topRight: Radius.circular(11),
                      ),
                    ),
                    child: Center(
                      child: Hero(
                        tag: 'product-image-$productId',
                        child: Image.network(
                          image,
                          fit: BoxFit.contain,
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
                  ),
                ),

                // Product Info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Product Name
                        Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),

                        const SizedBox(height: 6),

                        // Rating
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: colorScheme.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '($reviewCount)',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 11,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Price
                        Text(
                          CurrencyHelper.formatINR(inrPrice),
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Wishlist Button (top-right)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onWishlistToggle,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isInWishlist ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: isInWishlist ? colorScheme.error : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
