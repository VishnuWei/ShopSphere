import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/cart/screens/cart_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/orders/screens/order_detail_screen.dart';
import '../../features/orders/screens/orders_screen.dart';
import '../../features/product_detail/screens/product_detail_screen.dart';
import '../../features/products/screens/product_listing_screen.dart';
import '../../features/wishlist/screens/wishlist_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final isOnboardingComplete = _isOnboardingComplete();

  return GoRouter(
    initialLocation:
        isOnboardingComplete ? ProductListingScreen.routePath : OnboardingScreen.routePath,
    routes: [
      GoRoute(
        path: OnboardingScreen.routePath,
        name: OnboardingScreen.routeName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: ProductListingScreen.routePath,
        name: ProductListingScreen.routeName,
        builder: (context, state) => const ProductListingScreen(),
      ),
      GoRoute(
        path: ProductDetailScreen.routePath,
        name: ProductDetailScreen.routeName,
        builder: (context, state) {
          final productId = int.tryParse(state.pathParameters['id'] ?? '');
          return ProductDetailScreen(productId: productId);
        },
      ),
      GoRoute(
        path: CartScreen.routePath,
        name: CartScreen.routeName,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: WishlistScreen.routePath,
        name: WishlistScreen.routeName,
        builder: (context, state) => const WishlistScreen(),
      ),
      GoRoute(
        path: OrdersScreen.routePath,
        name: OrdersScreen.routeName,
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: OrderDetailScreen.routePath,
        name: OrderDetailScreen.routeName,
        builder: (context, state) {
          final order = state.extra as Map<String, dynamic>?;
          if (order == null) {
            return const Scaffold(
              body: Center(child: Text('Order not found')),
            );
          }
          return OrderDetailScreen(order: order);
        },
      ),
    ],
  );
});

bool _isOnboardingComplete() {
  try {
    final box = Hive.box<bool>('app_settings');
    return box.get('onboarding_complete', defaultValue: false) ?? false;
  } catch (e) {
    return false;
  }
}
