import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/helpers/currency_helper.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/image_carousel.dart';
import '../../../core/widgets/product_action_bar.dart';
import '../../../models/product.dart';
import '../../../widgets/async_value_view.dart';
import '../../cart/providers/cart_provider.dart';
import '../../cart/screens/cart_screen.dart';
import '../../products/providers/products_provider.dart';
import '../../products/providers/wishlist_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({required this.productId, super.key});

  static const routePath = '/products/:id';
  static const routeName = 'product-detail';

  final int? productId;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = 1;
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);

    return AsyncValueView<List<Product>>(
      value: products,
      data: (items) {
        final product = widget.productId == null
            ? null
            : items.firstWhere(
                (item) => item.id == widget.productId,
                orElse: () => null as dynamic,
              ) as Product?;

        if (product == null) {
          return Scaffold(
            appBar: AppBar(elevation: 0),
            body: EmptyState(
              title: 'Product Not Found',
              message: 'This product no longer exists.',
              icon: Icons.shopping_bag_outlined,
            ),
          );
        }

        return _buildDetail(context, product);
      },
    );
  }

  Widget _buildDetail(BuildContext context, Product product) {
    final images =
        product.images.isEmpty ? [product.thumbnail] : product.images;
    final cartItems = ref.watch(cartProvider);
    final wishlist = ref.watch(wishlistProvider);
    final isFavorite = wishlist.contains(product.id);
    final isInCart = cartItems.items.any((item) => item.productId == product.id);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
              color: context.colorScheme.error,
            ),
            onPressed: () async {
              await ref.read(wishlistProvider.notifier).toggleWishlist(product.id);
            },
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ImageCarousel(
                images: images,
                height: 350,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: context.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildRatingAndReviews(context, product),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    CurrencyHelper.formatINR(CurrencyHelper.convertToINR(product.price)),
                    style: context.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Divider(
                    color: context.colorScheme.outlineVariant,
                    thickness: 1,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildDescription(context, product),
                  const SizedBox(height: AppSpacing.xl),
                  if (!isInCart) _buildQuantitySelector(context),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ProductActionBar(
        price: product.price,
        isAddedToCart: isInCart,
        onAddToCart: () {
          for (int i = 0; i < _quantity; i++) {
            ref.read(cartProvider.notifier).addProduct(product);
          }
          setState(() => _quantity = 1);
        },
        onGoToCart: () => context.pushNamed(CartScreen.routeName),
        onBuyNow: () {
          ref.read(cartProvider.notifier).addProduct(product);
          context.pushNamed(CartScreen.routeName);
        },
      ),
    );
  }

  Widget _buildRatingAndReviews(BuildContext context, Product product) {
    return Row(
      children: [
        Icon(
          Icons.star_rounded,
          color: const Color(0xFFFFA500),
          size: 20,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          product.rating.toStringAsFixed(1),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          '(256 reviews)',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          product.description,
          style: context.textTheme.bodyLarge?.copyWith(
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.colorScheme.outlineVariant),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: _quantity > 1 ? () => setState(() => _quantity--) : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Icon(
                  Icons.remove_rounded,
                  color: _quantity > 1
                      ? context.colorScheme.primary
                      : context.colorScheme.outline,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Text(
              _quantity.toString(),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _quantity++),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Icon(
                  Icons.add_rounded,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
