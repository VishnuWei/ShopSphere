import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/helpers/currency_helper.dart';
import '../../../core/widgets/image_carousel.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({required this.order, super.key});

  static const routePath = '/order-detail';
  static const routeName = 'order-detail';

  final Map<String, dynamic> order;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  late int selectedItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    final items = (widget.order['items'] as List<dynamic>?) ?? [];
    final selectedItem = items.isNotEmpty ? items[selectedItemIndex] as Map<String, dynamic> : null;
    final otherItems = items.asMap().entries.where((e) => e.key != selectedItemIndex).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Order Details'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          // Product Images Carousel
          if (selectedItem != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: ImageCarousel(
                  images: [selectedItem['thumbnail'] ?? ''],
                  height: 350,
                ),
              ),
            ),

          // Product Information
          if (selectedItem != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedItem['title'] ?? 'Product',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFA500),
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '4.5',
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          '(256 reviews)',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    // Show other items if multiple items in order
                    if (otherItems.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Other Items in Order',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ...otherItems.map((entry) {
                        final otherItem = entry.value as Map<String, dynamic>;
                        final otherIndex = entry.key;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedItemIndex = otherIndex;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: context.colorScheme.outlineVariant,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: context.colorScheme.surfaceContainer,
                              ),
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: context.colorScheme.surface,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: otherItem['thumbnail'] ?? '',
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) => Icon(
                                        Icons.broken_image_outlined,
                                        color: context.colorScheme.outline,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          otherItem['title'] ?? 'Product',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textTheme.labelMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Qty: ${otherItem['quantity']}',
                                          style: context.textTheme.bodySmall?.copyWith(
                                            color: context.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    CurrencyHelper.formatINR(
                                      CurrencyHelper.convertToINR(
                                        (otherItem['price'] as num?)?.toDouble() ?? 0,
                                      ),
                                    ),
                                    style: context.textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: context.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ],
                ),
              ),
            ),

          // Order Information Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _buildOrderInfoCard(context, widget.order),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

          // Order Timeline
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _buildOrderTimeline(context),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

          // Order Summary
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _buildOrderSummary(context, widget.order),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

          // Action Buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _buildActionButtons(context),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ],
      ),
    );
  }

  Widget _buildOrderInfoCard(BuildContext context, Map<String, dynamic> order) {
    final colorScheme = Theme.of(context).colorScheme;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Information',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
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
            _buildInfoRow(context, '📦 Order ID', order['orderId'] ?? 'N/A'),
            const SizedBox(height: AppSpacing.md),
            _buildInfoRow(context, '🔔 Transaction ID', '${(order['transactionId'] ?? 'N/A').toString().substring(0, 12)}...'),
            const SizedBox(height: AppSpacing.md),
            _buildInfoRow(context, '📅 Date', order['date'] ?? 'N/A'),
            const SizedBox(height: AppSpacing.md),
            _buildInfoRow(context, '💳 Amount Paid', CurrencyHelper.formatINR(order['amount'] ?? 0)),
            const SizedBox(height: AppSpacing.md),
            _buildInfoRow(context, '📍 Status', 'Delivered'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
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
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderTimeline(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final steps = [
      ('Order Placed', true),
      ('Payment Successful', true),
      ('Processing', true),
      ('Shipped', true),
      ('Out for Delivery', true),
      ('Delivered', true),
    ];

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
            Text(
              'Order Progress',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isCompleted = step.$2;
              final isLast = index == steps.length - 1;

              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isCompleted ? colorScheme.primary : colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: isCompleted ? colorScheme.onPrimary : colorScheme.outline,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          step.$1,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: isCompleted ? context.colorScheme.onSurface : colorScheme.onSurfaceVariant,
                            fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!isLast) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Container(
                        width: 2,
                        height: 16,
                        color: isCompleted ? colorScheme.primary : colorScheme.outlineVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, Map<String, dynamic> order) {
    final colorScheme = Theme.of(context).colorScheme;
    final amount = ((order['amount'] as num?) ?? 0).toDouble();
    final subtotal = amount * 0.85;
    final tax = amount - subtotal;

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
            Text(
              'Order Summary',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildSummaryRow(context, 'Subtotal', CurrencyHelper.formatINR(subtotal)),
            const SizedBox(height: AppSpacing.md),
            _buildSummaryRow(context, 'Shipping', 'Free'),
            const SizedBox(height: AppSpacing.md),
            _buildSummaryRow(context, 'Tax', CurrencyHelper.formatINR(tax)),
            const SizedBox(height: AppSpacing.lg),
            Divider(color: colorScheme.outlineVariant),
            const SizedBox(height: AppSpacing.lg),
            _buildSummaryRow(
              context,
              'Total Paid',
              CurrencyHelper.formatINR(amount),
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: isTotal ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: context.textTheme.bodySmall?.copyWith(
            color: isTotal ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Buy Again feature coming soon')),
            );
          },
          child: const Text('Buy Again'),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invoice download coming soon')),
                  );
                },
                child: const Text('Invoice'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order tracking coming soon')),
                  );
                },
                child: const Text('Track'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Support chat coming soon')),
            );
          },
          child: const Text('Contact Support'),
        ),
      ],
    );
  }
}
