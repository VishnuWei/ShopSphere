import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/models/cart_item.dart';
import 'package:shopsphere/models/product.dart';

void main() {
  test('cart item serializes and restores from JSON', () {
    const product = Product(
      id: 1,
      title: 'Phone',
      description: 'A useful phone',
      price: 99.5,
      rating: 4.6,
      thumbnail: 'https://example.com/phone.png',
      images: ['https://example.com/phone.png'],
    );

    final item = CartItem.fromProduct(product).copyWith(quantity: 3);
    final restored = CartItem.fromJson(item.toJson());

    expect(restored.productId, 1);
    expect(restored.quantity, 3);
    expect(restored.lineTotal, 298.5);
  });
}
