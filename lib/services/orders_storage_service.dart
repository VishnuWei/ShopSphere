import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OrdersStorageService {
  static const String ordersBoxName = 'orders';

  static Future<void> saveOrder(Map<String, dynamic> order) async {
    try {
      final box = Hive.box<Map<dynamic, dynamic>>(ordersBoxName);
      final orderId = order['orderId'] as String? ?? 'order_${DateTime.now().millisecondsSinceEpoch}';

      // Convert order to Hive-compatible format
      final hiveOrder = _convertToHiveMap(order);
      await box.put(orderId, hiveOrder);

      debugPrint('Order saved: $orderId');
    } catch (e) {
      debugPrint('Error saving order: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> loadOrders() async {
    try {
      final box = Hive.box<Map<dynamic, dynamic>>(ordersBoxName);
      final orders = <Map<String, dynamic>>[];

      for (var value in box.values) {
        final order = _convertFromHiveMap(value);
        orders.add(order);
      }

      // Sort by date (newest first)
      orders.sort((a, b) {
        final dateA = DateTime.tryParse(a['date'] as String? ?? '') ?? DateTime(1970);
        final dateB = DateTime.tryParse(b['date'] as String? ?? '') ?? DateTime(1970);
        return dateB.compareTo(dateA);
      });

      debugPrint('Loaded ${orders.length} orders from storage');
      return orders;
    } catch (e) {
      debugPrint('Error loading orders: $e');
      return [];
    }
  }

  static Future<void> clearAllOrders() async {
    try {
      final box = Hive.box<Map<dynamic, dynamic>>(ordersBoxName);
      await box.clear();
      debugPrint('All orders cleared');
    } catch (e) {
      debugPrint('Error clearing orders: $e');
    }
  }

  static Map<dynamic, dynamic> _convertToHiveMap(Map<String, dynamic> order) {
    return {
      'orderId': order['orderId'],
      'transactionId': order['transactionId'],
      'amount': order['amount'],
      'items': _convertItems(order['items'] as List<dynamic>? ?? []),
      'itemCount': order['itemCount'],
      'date': order['date'],
    };
  }

  static Map<String, dynamic> _convertFromHiveMap(Map<dynamic, dynamic> hiveMap) {
    return {
      'orderId': hiveMap['orderId'] as String? ?? 'N/A',
      'transactionId': hiveMap['transactionId'] as String? ?? 'N/A',
      'amount': (hiveMap['amount'] as num?)?.toDouble() ?? 0.0,
      'items': _convertItemsBack(hiveMap['items'] as List<dynamic>? ?? []),
      'itemCount': hiveMap['itemCount'] as int? ?? 0,
      'date': hiveMap['date'] as String? ?? 'N/A',
    };
  }

  static List<dynamic> _convertItems(List<dynamic> items) {
    return items.map((item) {
      if (item is Map<String, dynamic>) {
        return {
          'productId': item['productId'],
          'title': item['title'],
          'price': item['price'],
          'quantity': item['quantity'],
          'thumbnail': item['thumbnail'],
          'total': item['total'],
        };
      }
      return item;
    }).toList();
  }

  static List<dynamic> _convertItemsBack(List<dynamic> items) {
    return items.map((item) {
      if (item is Map<dynamic, dynamic>) {
        return {
          'productId': item['productId'],
          'title': item['title'],
          'price': item['price'],
          'quantity': item['quantity'],
          'thumbnail': item['thumbnail'],
          'total': item['total'],
        };
      }
      return item;
    }).toList();
  }
}
