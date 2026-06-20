import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/products/providers/wishlist_provider.dart';
import '../../models/product.dart';
import '../design/app_radius.dart';
import '../design/app_spacing.dart';
import '../extensions/context_extensions.dart';
import '../helpers/currency_formatter.dart';

class CompactProductCard extends ConsumerStatefulWidget {
  const CompactProductCard({
    required this.product,
    this.onTap,
    super.key,
  });

  final Product product;
  final VoidCallback? onTap;

  @override
  ConsumerState<CompactProductCard> createState() => _CompactProductCardState();
}

class _CompactProductCardState extends ConsumerState<CompactProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = ref.watch(wishlistProvider);
    final isFavorite = wishlist.contains(widget.product.id);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with wishlist
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    _buildImage(context),
                    Positioned(
                      top: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: _buildFavoriteButton(context, isFavorite),
                    ),
                  ],
                ),
              ),
              // Info section
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Text(
                        widget.product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Rating and Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 14,
                                color: const Color(0xFFFFA500),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.product.rating.toStringAsFixed(1),
                                style: context.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            CurrencyFormatter.formatINR(widget.product.price),
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppRadius.md),
        topRight: Radius.circular(AppRadius.md),
      ),
      child: CachedNetworkImage(
        imageUrl: widget.product.thumbnail,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: context.colorScheme.surfaceContainerHighest,
          child: const Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: context.colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.image_not_supported_outlined,
            color: context.colorScheme.outline,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context, bool isFavorite) {
    return GestureDetector(
      onTap: () async {
        await ref.read(wishlistProvider.notifier).toggleWishlist(widget.product.id);
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
          size: 16,
          color: isFavorite
              ? context.colorScheme.error
              : context.colorScheme.outline,
        ),
      ),
    );
  }
}
