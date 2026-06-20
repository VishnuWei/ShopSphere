import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/wishlist_storage_service.dart';

final wishlistProvider = NotifierProvider<WishlistNotifier, Set<int>>(
  () => WishlistNotifier(),
);

class WishlistNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() {
    return WishlistStorageService.getAllWishlistIds().toSet();
  }

  Future<void> toggleWishlist(int productId) async {
    await WishlistStorageService.toggleWishlist(productId);
    if (state.contains(productId)) {
      state = {...state}..remove(productId);
    } else {
      state = {...state, productId};
    }
  }

  Future<void> addToWishlist(int productId) async {
    if (!state.contains(productId)) {
      await WishlistStorageService.addToWishlist(productId);
      state = {...state, productId};
    }
  }

  Future<void> removeFromWishlist(int productId) async {
    if (state.contains(productId)) {
      await WishlistStorageService.removeFromWishlist(productId);
      state = {...state}..remove(productId);
    }
  }

  bool isInWishlist(int productId) => state.contains(productId);
  int get wishlistCount => state.length;
}
