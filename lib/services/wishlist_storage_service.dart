import 'package:hive_flutter/hive_flutter.dart';

class WishlistStorageService {
  static const String wishlistBoxName = 'wishlist';

  static Box<bool> get _wishlistBox => Hive.box<bool>(wishlistBoxName);

  /// Add product to wishlist
  static Future<void> addToWishlist(int productId) async {
    await _wishlistBox.put(productId.toString(), true);
  }

  /// Remove product from wishlist
  static Future<void> removeFromWishlist(int productId) async {
    await _wishlistBox.delete(productId.toString());
  }

  /// Check if product is in wishlist
  static bool isInWishlist(int productId) {
    return _wishlistBox.get(productId.toString(), defaultValue: false) ?? false;
  }

  /// Toggle wishlist status
  static Future<void> toggleWishlist(int productId) async {
    final isInWishlist = _wishlistBox.get(productId.toString(), defaultValue: false) ?? false;
    if (isInWishlist) {
      await removeFromWishlist(productId);
    } else {
      await addToWishlist(productId);
    }
  }

  /// Get all wishlist product IDs
  static List<int> getAllWishlistIds() {
    return _wishlistBox.keys
        .map((key) => int.tryParse(key.toString()))
        .whereType<int>()
        .toList();
  }

  /// Get wishlist count
  static int getWishlistCount() {
    return _wishlistBox.length;
  }

  /// Clear entire wishlist
  static Future<void> clearWishlist() async {
    await _wishlistBox.clear();
  }
}
