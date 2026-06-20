import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/cart_item.dart';
import '../../../models/cart_state.dart';
import '../../../models/product.dart';
import '../../../services/cart_storage_service.dart';

final cartProvider = NotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);

class CartNotifier extends Notifier<CartState> {
  late final CartStorageService _storage;

  @override
  CartState build() {
    _storage = ref.watch(cartStorageServiceProvider);
    return CartState(items: _storage.loadItems());
  }

  void addProduct(Product product) {
    final existingItem = state.items
        .where((item) => item.productId == product.id)
        .firstOrNull;

    if (existingItem == null) {
      _setItems([...state.items, CartItem.fromProduct(product)]);
      return;
    }

    _setItems([
      for (final item in state.items)
        if (item.productId == product.id)
          item.copyWith(quantity: item.quantity + 1)
        else
          item,
    ]);
  }

  void increaseQuantity(int productId) {
    _setItems([
      for (final item in state.items)
        if (item.productId == productId)
          item.copyWith(quantity: item.quantity + 1)
        else
          item,
    ]);
  }

  void decreaseQuantity(int productId) {
    final nextItems = state.items
        .map((item) {
          if (item.productId != productId) {
            return item;
          }
          return item.copyWith(quantity: item.quantity - 1);
        })
        .where((item) => item.quantity > 0)
        .toList();
    _setItems(nextItems);
  }

  void removeItem(int productId) {
    _setItems(
      state.items.where((item) => item.productId != productId).toList(),
    );
  }

  void clear() {
    _setItems([]);
  }

  void _setItems(List<CartItem> items) {
    state = state.copyWith(items: List.unmodifiable(items));
    _storage.saveItems(state.items);
  }
}
