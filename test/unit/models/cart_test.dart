import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/models/cart_item.dart';
import 'package:shopsphere/models/cart_state.dart';
import 'package:shopsphere/models/product.dart';

void main() {
  group('CartItem', () {
    test('CartItem.fromProduct creates instance from Product', () {
      final product = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        rating: 4.5,
        thumbnail: 'https://example.com/image.jpg',
        images: [],
      );

      final cartItem = CartItem.fromProduct(product);

      expect(cartItem.productId, 1);
      expect(cartItem.title, 'Test Product');
      expect(cartItem.price, 99.99);
      expect(cartItem.quantity, 1);
    });

    test('CartItem.lineTotal calculates correctly', () {
      final cartItem = CartItem(
        productId: 1,
        title: 'Test Product',
        price: 50.0,
        thumbnail: 'https://example.com/image.jpg',
        quantity: 3,
      );

      expect(cartItem.lineTotal, 150.0);
    });

    test('CartItem.copyWith updates quantity', () {
      final cartItem = CartItem(
        productId: 1,
        title: 'Test Product',
        price: 50.0,
        thumbnail: 'https://example.com/image.jpg',
        quantity: 1,
      );

      final updated = cartItem.copyWith(quantity: 5);

      expect(updated.quantity, 5);
      expect(updated.productId, cartItem.productId);
      expect(updated.price, cartItem.price);
    });

    test('CartItem.fromJson creates instance correctly', () {
      final json = {
        'productId': 1,
        'title': 'Test Product',
        'price': 99.99,
        'thumbnail': 'https://example.com/image.jpg',
        'quantity': 2,
      };

      final cartItem = CartItem.fromJson(json);

      expect(cartItem.productId, 1);
      expect(cartItem.title, 'Test Product');
      expect(cartItem.price, 99.99);
      expect(cartItem.quantity, 2);
    });

    test('CartItem.toJson serializes correctly', () {
      final cartItem = CartItem(
        productId: 1,
        title: 'Test Product',
        price: 99.99,
        thumbnail: 'https://example.com/image.jpg',
        quantity: 2,
      );

      final json = cartItem.toJson();

      expect(json['productId'], 1);
      expect(json['title'], 'Test Product');
      expect(json['price'], 99.99);
      expect(json['quantity'], 2);
    });
  });

  group('CartState', () {
    test('CartState.isEmpty returns true when no items', () {
      final cartState = CartState(items: []);
      expect(cartState.isEmpty, true);
    });

    test('CartState.isEmpty returns false when has items', () {
      final items = [
        CartItem(
          productId: 1,
          title: 'Test Product',
          price: 50.0,
          thumbnail: 'https://example.com/image.jpg',
          quantity: 1,
        ),
      ];
      final cartState = CartState(items: items);
      expect(cartState.isEmpty, false);
    });

    test('CartState.totalItems sums quantities correctly', () {
      final items = [
        CartItem(
          productId: 1,
          title: 'Product 1',
          price: 50.0,
          thumbnail: 'https://example.com/image1.jpg',
          quantity: 2,
        ),
        CartItem(
          productId: 2,
          title: 'Product 2',
          price: 30.0,
          thumbnail: 'https://example.com/image2.jpg',
          quantity: 3,
        ),
      ];
      final cartState = CartState(items: items);
      expect(cartState.totalItems, 5);
    });

    test('CartState.subtotal calculates correctly', () {
      final items = [
        CartItem(
          productId: 1,
          title: 'Product 1',
          price: 50.0,
          thumbnail: 'https://example.com/image1.jpg',
          quantity: 2,
        ),
        CartItem(
          productId: 2,
          title: 'Product 2',
          price: 30.0,
          thumbnail: 'https://example.com/image2.jpg',
          quantity: 1,
        ),
      ];
      final cartState = CartState(items: items);
      expect(cartState.subtotal, 130.0);
    });

    test('CartState.copyWith creates new instance with updated items', () {
      final originalItems = [
        CartItem(
          productId: 1,
          title: 'Product 1',
          price: 50.0,
          thumbnail: 'https://example.com/image1.jpg',
          quantity: 1,
        ),
      ];
      final originalState = CartState(items: originalItems);

      final newItems = [
        CartItem(
          productId: 2,
          title: 'Product 2',
          price: 30.0,
          thumbnail: 'https://example.com/image2.jpg',
          quantity: 1,
        ),
      ];
      final newState = originalState.copyWith(items: newItems);

      expect(newState.items.length, 1);
      expect(newState.items[0].productId, 2);
      expect(originalState.items.length, 1);
      expect(originalState.items[0].productId, 1);
    });
  });
}
