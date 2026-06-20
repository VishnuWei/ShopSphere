import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopsphere/features/orders/screens/orders_screen.dart';

import '../../../core/design/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/premium_product_card.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/search_bar.dart';
import '../../../models/product.dart';
import '../../../widgets/async_value_view.dart';
import '../../cart/providers/cart_provider.dart';
import '../../cart/screens/cart_screen.dart';
import '../../product_detail/screens/product_detail_screen.dart';
import '../../wishlist/screens/wishlist_screen.dart';
import '../providers/products_provider.dart';
import '../providers/wishlist_provider.dart';

class ProductListingScreen extends ConsumerStatefulWidget {
  const ProductListingScreen({super.key});

  static const routePath = '/';
  static const routeName = 'products';

  @override
  ConsumerState<ProductListingScreen> createState() =>
      _ProductListingScreenState();
}

class _ProductListingScreenState extends ConsumerState<ProductListingScreen> {
  late String _searchQuery;

  @override
  void initState() {
    super.initState();
    _searchQuery = '';
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);
    final cart = ref.watch(cartProvider);
    final themeMode = ref.watch(themeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopSphere'),
        elevation: 0,
        centerTitle: false,
        actions: [
          // Wishlist icon
          IconButton(
            tooltip: 'Wishlist',
            onPressed: () => context.pushNamed(WishlistScreen.routeName),
            icon: const Icon(Icons.favorite_outline),
          ),
          // Cart icon with badge
          IconButton(
            tooltip: 'Cart',
            onPressed: () => context.pushNamed(CartScreen.routeName),
            icon: Badge(
              isLabelVisible: cart.totalItems > 0,
              label: Text(cart.totalItems.toString()),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      // Add sidebar drawer
      drawer: AppDrawer(
        isDarkMode: themeMode == ThemeMode.dark,
        onThemeToggle: ref.read(themeControllerProvider.notifier).toggleTheme,
        onWishlistTap: () => context.pushNamed(WishlistScreen.routeName),
        onOrdersTap: () {
          context.pushNamed(OrdersScreen.routeName);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Orders Coming Soon')),
          // );
        },
        onCartTap: () => context.pushNamed(CartScreen.routeName),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(productsProvider.future),
        child: AsyncValueView<List<Product>>(
          value: products,
          data: (items) => _buildContent(context, items),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Product> items) {
    final filteredItems = _searchQuery.isEmpty
        ? items
        : items
            .where((p) =>
                p.title.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(context),
                const SizedBox(height: AppSpacing.md),
                AppSearchBar(
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildPromotion(context),
              ],
            ),
          ),
        ),
        if (filteredItems.isEmpty)
          SliverFillRemaining(
            child: EmptyState(
              title: 'No products found',
              message: _searchQuery.isEmpty
                  ? 'Pull down to refresh the catalog.'
                  : 'No products match your search.',
              icon: Icons.search_off_rounded,
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.55,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildProductCard(
                  context,
                  filteredItems[index],
                ),
                childCount: filteredItems.length,
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to ShopSphere',
          style: context.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Discover amazing products',
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPromotion(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        gradient: LinearGradient(
          colors: [
            context.colorScheme.primary,
            context.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summer Sale',
            style: context.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Get up to 30% off on selected items',
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    final wishlist = ref.watch(wishlistProvider);
    final isInWishlist = wishlist.contains(product.id);

    return PremiumProductCard(
      productId: product.id.toString(),
      image: product.thumbnail,
      name: product.title,
      price: product.price,
      rating: product.rating,
      reviewCount: 256,
      isInWishlist: isInWishlist,
      onTap: () => context.pushNamed(
        ProductDetailScreen.routeName,
        pathParameters: {'id': product.id.toString()},
      ),
      onWishlistToggle: () {
        ref.read(wishlistProvider.notifier).toggleWishlist(product.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isInWishlist ? 'Removed from wishlist' : 'Added to wishlist',
            ),
            duration: const Duration(milliseconds: 800),
          ),
        );
      },
    );
  }
}
