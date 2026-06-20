import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/core/widgets/product_card.dart';
import 'package:shopsphere/models/product.dart';

void main() {
  group('ProductCard Widget', () {
    testWidgets('ProductCard renders with product information',
        (WidgetTester tester) async {
      final product = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        rating: 4.5,
        thumbnail: 'https://example.com/image.jpg',
        images: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: product),
          ),
        ),
      );

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('\$99.99'), findsOneWidget);
    });

    testWidgets('ProductCard has onTap callback',
        (WidgetTester tester) async {
      final product = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        rating: 4.5,
        thumbnail: 'https://example.com/image.jpg',
        images: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: product,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('ProductCard favorite button is displayed',
        (WidgetTester tester) async {
      final product = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        rating: 4.5,
        thumbnail: 'https://example.com/image.jpg',
        images: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: product,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    });

    testWidgets('ProductCard displays rating icon',
        (WidgetTester tester) async {
      final product = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        rating: 4.5,
        thumbnail: 'https://example.com/image.jpg',
        images: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: product),
          ),
        ),
      );

      expect(find.byIcon(Icons.star_rounded), findsWidgets);
    });

    testWidgets('ProductCard displays Sale badge',
        (WidgetTester tester) async {
      final product = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        rating: 4.5,
        thumbnail: 'https://example.com/image.jpg',
        images: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: product),
          ),
        ),
      );

      expect(find.text('Sale'), findsOneWidget);
    });
  });
}
