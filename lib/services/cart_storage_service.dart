import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/cart_item.dart';

final cartStorageServiceProvider = Provider<CartStorageService>((ref) {
  return CartStorageService(
    Hive.box<Map<dynamic, dynamic>>(CartStorageService.cartBoxName),
  );
});

class CartStorageService {
  const CartStorageService(this._box);

  static const cartBoxName = 'cart_items';

  final Box<Map<dynamic, dynamic>> _box;

  List<CartItem> loadItems() {
    return _box.values
        .map((item) => Map<String, dynamic>.from(item))
        .map(CartItem.fromJson)
        .toList();
  }

  Future<void> saveItems(List<CartItem> items) async {
    await _box.clear();
    final entries = {for (final item in items) item.productId: item.toJson()};
    await _box.putAll(entries);
  }
}
