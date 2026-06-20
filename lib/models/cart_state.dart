import 'cart_item.dart';

class CartState {
  const CartState({required this.items});

  final List<CartItem> items;

  bool get isEmpty => items.isEmpty;
  int get totalItems => items.fold(0, (total, item) => total + item.quantity);
  double get subtotal => items.fold(0, (total, item) => total + item.lineTotal);
  double get total => subtotal;

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}
