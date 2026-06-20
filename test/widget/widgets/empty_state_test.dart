import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/core/widgets/empty_state.dart';

void main() {
  group('EmptyState Widget', () {
    testWidgets('EmptyState displays title and message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'No Items',
              message: 'There are no items to display.',
            ),
          ),
        ),
      );

      expect(find.text('No Items'), findsOneWidget);
      expect(find.text('There are no items to display.'), findsOneWidget);
    });

    testWidgets('EmptyState displays custom icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'No Items',
              message: 'There are no items to display.',
              icon: Icons.search_off_rounded,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
    });

    testWidgets('EmptyState displays default icon when not specified',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'No Items',
              message: 'There are no items to display.',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('EmptyState displays action button when provided',
        (WidgetTester tester) async {
      var actionPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'No Items',
              message: 'There are no items to display.',
              action: () => actionPressed = true,
              actionLabel: 'Retry',
            ),
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(actionPressed, true);
    });

    testWidgets('EmptyState does not display action button when not provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'No Items',
              message: 'There are no items to display.',
            ),
          ),
        ),
      );

      expect(find.byType(FilledButton), findsNothing);
    });
  });
}
