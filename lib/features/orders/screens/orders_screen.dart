import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/helpers/currency_helper.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/orders_provider.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  static const routePath = '/orders';
  static const routeName = 'orders';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        elevation: 0,
        centerTitle: true,
      ),
      body: ordersAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error loading orders: $error'),
        ),
        data: (orders) => orders.isEmpty
            ? EmptyState(
                title: 'No Orders Yet',
                message: 'Start shopping and make your first purchase!',
                icon: Icons.shopping_bag_outlined,
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: orders.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.lg),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        OrderDetailScreen.routeName,
                        extra: order,
                      );
                    },
                    child: _buildOrderCard(context, order),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    final colorScheme = Theme.of(context).colorScheme;
    final items = (order['items'] as List<dynamic>?) ?? [];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surface,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['orderId'] ?? 'N/A',
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '✓ Paid',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Order Items
            Text(
              'Items Ordered',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...items.map((item) => _buildOrderItem(context, item as Map<String, dynamic>)).toList(),

            const SizedBox(height: AppSpacing.lg),
            Divider(color: colorScheme.outlineVariant),
            const SizedBox(height: AppSpacing.lg),

            // Order Details
            _buildDetailRow(
              context,
              'Amount',
              CurrencyHelper.formatINR(order['amount'] ?? 0),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailRow(
              context,
              'Transaction ID',
              '${(order['transactionId'] ?? 'N/A').toString().substring(0, 12)}...',
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailRow(
              context,
              'Items',
              '${order['itemCount'] ?? 0} item(s)',
            ),
            const SizedBox(height: AppSpacing.lg),

            // Date
            Text(
              order['date'] ?? 'Just now',
              style: context.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, Map<String, dynamic> item) {
    final colorScheme = Theme.of(context).colorScheme;
    final price = item['price'] as num? ?? 0;
    final quantity = item['quantity'] as num? ?? 1;
    final inrPrice = CurrencyHelper.convertToINR(price.toDouble());

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
        color: colorScheme.surfaceContainer,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colorScheme.surface,
            ),
            child: CachedNetworkImage(
              imageUrl: item['thumbnail'] ?? '',
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Icon(
                Icons.broken_image_outlined,
                color: colorScheme.outline,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] ?? 'Unknown Product',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${quantity.toInt()}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CurrencyHelper.formatINR(inrPrice),
                      style: context.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Total: ${CurrencyHelper.formatINR(inrPrice * quantity.toInt())}',
                      style: context.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: context.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
