import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/orders_storage_service.dart';

final ordersProvider = AsyncNotifierProvider<OrdersNotifier, List<Map<String, dynamic>>>(
  OrdersNotifier.new,
);

class OrdersNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    // Load persisted orders from Hive on initialization
    final persistedOrders = await OrdersStorageService.loadOrders();
    return persistedOrders;
  }

  Future<void> addOrder(
    String orderId,
    String transactionId,
    double amount,
    List<Map<String, dynamic>> items,
  ) async {
    final newOrder = {
      'orderId': orderId,
      'transactionId': transactionId,
      'amount': amount,
      'items': items,
      'itemCount': items.length,
      'date': DateTime.now().toString().split('.')[0],
    };

    // Save to Hive persistence
    await OrdersStorageService.saveOrder(newOrder);

    // Update state - prepend new order to list
    final currentOrders = state.whenData((orders) => [newOrder, ...orders]);
    state = await currentOrders;

    debugPrint('Order saved and state updated');
  }

  Future<void> clearOrders() async {
    await OrdersStorageService.clearAllOrders();
    state = const AsyncValue.data([]);
    debugPrint('All orders cleared');
  }
}
