import 'product.dart';

class CartItem {
  const CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.quantity,
  });

  final int productId;
  final String title;
  final double price;
  final String thumbnail;
  final int quantity;

  double get lineTotal => price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      title: title,
      price: price,
      thumbnail: thumbnail,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItem.fromProduct(Product product) {
    return CartItem(
      productId: product.id,
      title: product.title,
      price: product.price,
      thumbnail: product.thumbnail,
      quantity: 1,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] as int,
      title: json['title'] as String? ?? 'Untitled product',
      price: (json['price'] as num? ?? 0).toDouble(),
      thumbnail: json['thumbnail'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'thumbnail': thumbnail,
      'quantity': quantity,
    };
  }
}
