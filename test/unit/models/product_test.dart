import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/models/product.dart';

void main() {
  group('Product', () {
    test('Product.fromJson creates instance correctly', () {
      final json = {
        'id': 1,
        'title': 'Test Product',
        'description': 'Test Description',
        'price': 99.99,
        'rating': 4.5,
        'thumbnail': 'https://example.com/image.jpg',
        'images': ['https://example.com/image1.jpg', 'https://example.com/image2.jpg'],
      };

      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.title, 'Test Product');
      expect(product.description, 'Test Description');
      expect(product.price, 99.99);
      expect(product.rating, 4.5);
      expect(product.thumbnail, 'https://example.com/image.jpg');
      expect(product.images.length, 2);
    });

    test('Product.fromJson handles missing fields gracefully', () {
      final json = {
        'id': 1,
      };

      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.title, 'Untitled product');
      expect(product.description, '');
      expect(product.price, 0.0);
      expect(product.rating, 0.0);
      expect(product.thumbnail, '');
      expect(product.images, []);
    });

    test('Product.fromJson handles null price correctly', () {
      final json = {
        'id': 1,
        'title': 'Test Product',
        'price': null,
      };

      final product = Product.fromJson(json);

      expect(product.price, 0.0);
    });

    test('Product.fromJson converts int price to double', () {
      final json = {
        'id': 1,
        'title': 'Test Product',
        'price': 100,
      };

      final product = Product.fromJson(json);

      expect(product.price, 100.0);
    });
  });
}
