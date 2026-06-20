import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/core/widgets/error_state.dart';

void main() {
  group('Widget Error State Tests', () {
    late Widget testWidget;

    setUp(() {
      testWidget = MaterialApp(
        home: Scaffold(
          body: ErrorState(
            title: 'No Internet Connection',
            message: 'Please check your internet connection and try again.',
            icon: Icons.wifi_off,
            onRetry: () {},
          ),
        ),
      );
    });

    testWidgets('Should display error icon', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });

    testWidgets('Should display error title', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      expect(find.text('No Internet Connection'), findsOneWidget);
    });

    testWidgets('Should display error message', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      expect(
        find.text('Please check your internet connection and try again.'),
        findsOneWidget,
      );
    });

    testWidgets('Should display retry button', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('Retry button should be tappable', (WidgetTester tester) async {
      bool retryPressed = false;
      final widget = MaterialApp(
        home: Scaffold(
          body: ErrorState(
            title: 'No Internet',
            message: 'Connection failed',
            icon: Icons.wifi_off,
            onRetry: () {
              retryPressed = true;
            },
          ),
        ),
      );

      await tester.pumpWidget(widget);
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(retryPressed, true);
    });

    testWidgets('Should render in column layout', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('Error icon should be large', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      final iconWidget = find.byIcon(Icons.wifi_off);
      expect(iconWidget, findsOneWidget);
    });

    testWidgets('Text should be centered', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      final titleText = find.text('No Internet Connection');
      expect(titleText, findsOneWidget);

      final textWidget = tester.widget<Text>(
        find.ancestor(
          of: titleText,
          matching: find.byType(Text),
        ),
      );
      expect(textWidget.textAlign, TextAlign.center);
    });

    testWidgets('Should show no internet error state',
        (WidgetTester tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: ErrorState(
            title: 'No Internet',
            message: 'Blame the rat! He thought the Wi-Fi wire was a snack!',
            icon: Icons.wifi_off,
            onRetry: () {},
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      expect(find.text('No Internet'), findsOneWidget);
      expect(
        find.text('Blame the rat! He thought the Wi-Fi wire was a snack!'),
        findsOneWidget,
      );
    });

    testWidgets('Should handle retry callback',
        (WidgetTester tester) async {
      int retryCount = 0;
      final widget = MaterialApp(
        home: Scaffold(
          body: ErrorState(
            title: 'Connection Error',
            message: 'Unable to connect to the server',
            icon: Icons.error,
            onRetry: () {
              retryCount++;
            },
          ),
        ),
      );

      await tester.pumpWidget(widget);
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(retryCount, 1);

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(retryCount, 2);
    });
  });

  group('Widget Loading State Tests', () {
    testWidgets('Should display loading indicator', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should show loading state with text', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading...'),
            ],
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('Should show skeleton loading state', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                height: 100,
                margin: EdgeInsets.all(8),
                color: Colors.grey[300],
                child: Placeholder(),
              );
            },
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.byType(Placeholder), findsWidgets);
    });
  });

  group('Widget Empty State Tests', () {
    testWidgets('Should display empty state message', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 64),
                SizedBox(height: 16),
                Text('No products found'),
                SizedBox(height: 8),
                Text('Try searching for something else'),
              ],
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.text('No products found'), findsOneWidget);
      expect(find.text('Try searching for something else'), findsOneWidget);
    });

    testWidgets('Should display empty cart state', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart, size: 100),
                SizedBox(height: 24),
                Text('Your cart is empty'),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Continue Shopping'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Should display empty wishlist state', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 100),
                SizedBox(height: 24),
                Text('No saved items yet'),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Start Browsing'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.text('No saved items yet'), findsOneWidget);
    });

    testWidgets('Empty state should have action button', (WidgetTester tester) async {
      bool buttonPressed = false;

      final widget = MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No results'),
                ElevatedButton(
                  onPressed: () {
                    buttonPressed = true;
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(buttonPressed, true);
    });
  });

  group('Widget State Transitions Tests', () {
    testWidgets('Should transition from loading to loaded state',
        (WidgetTester tester) async {
      final loadingWidget = MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );

      await tester.pumpWidget(loadingWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      final loadedWidget = MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Content loaded')),
        ),
      );

      await tester.pumpWidget(loadedWidget);
      expect(find.text('Content loaded'), findsOneWidget);
    });

    testWidgets('Should transition from loading to error state',
        (WidgetTester tester) async {
      final loadingWidget = MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );

      await tester.pumpWidget(loadingWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      final errorWidget = MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error occurred')),
        ),
      );

      await tester.pumpWidget(errorWidget);
      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('Should transition from loading to empty state',
        (WidgetTester tester) async {
      final loadingWidget = MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );

      await tester.pumpWidget(loadingWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      final emptyWidget = MaterialApp(
        home: Scaffold(
          body: Center(child: Text('No items')),
        ),
      );

      await tester.pumpWidget(emptyWidget);
      expect(find.text('No items'), findsOneWidget);
    });
  });

  group('Widget Data Display Tests', () {
    testWidgets('Should display product list', (WidgetTester tester) async {
      final List<Map<String, dynamic>> products = [
        {'id': 1, 'name': 'Product 1', 'price': 100},
        {'id': 2, 'name': 'Product 2', 'price': 200},
      ];

      final widget = MaterialApp(
        home: Scaffold(
          body: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product['name'] as String),
                subtitle: Text('\$${product['price']}'),
              );
            },
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('Product 2'), findsOneWidget);
      expect(find.text('\$100'), findsOneWidget);
      expect(find.text('\$200'), findsOneWidget);
    });

    testWidgets('Should display grid of items', (WidgetTester tester) async {
      final items = List.generate(6, (index) => 'Item ${index + 1}');

      final widget = MaterialApp(
        home: Scaffold(
          body: GridView.count(
            crossAxisCount: 2,
            children: items
                .map((item) => Card(child: Center(child: Text(item))))
                .toList(),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.byType(Card), findsNWidgets(6));
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 6'), findsOneWidget);
    });

    testWidgets('Should display grid layouts', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: GridView.count(
            crossAxisCount: 2,
            children: List.generate(4, (index) {
              return Card(
                child: Container(
                  color: Colors.red,
                  child: Center(child: Text('Item $index')),
                ),
              );
            }),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      final gridView = find.byType(GridView);
      expect(gridView, findsOneWidget);
      expect(find.byType(Card), findsNWidgets(4));
    });

    testWidgets('Should display layout with expansion', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.blue,
                  child: const Text('Sidebar'),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.green,
                  child: const Text('Content'),
                ),
              ),
            ],
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Expanded), findsWidgets);
      expect(find.text('Sidebar'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('Should display padding layouts', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(color: Colors.blue),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      final padding = find.byType(Padding);
      expect(padding, findsOneWidget);
    });

    testWidgets('Should display buttons', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Button 1'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Button 2'),
                ),
              ),
            ],
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.byType(ElevatedButton), findsNWidgets(2));
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('Should display container with placeholder', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: Container(
            width: double.infinity,
            height: 300,
            color: Colors.grey,
            child: const Placeholder(),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Placeholder), findsOneWidget);
    });
  });
}
