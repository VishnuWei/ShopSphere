import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/widgets/empty_state.dart';
import '../core/widgets/error_state.dart';
import '../core/widgets/skeleton_loader.dart';

class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.data,
    this.onError,
    this.loadingBuilder,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Function(Object error, StackTrace stackTrace)? onError;
  final WidgetBuilder? loadingBuilder;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () =>
          loadingBuilder?.call(context) ??
          const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        onError?.call(error, stackTrace);
        return ErrorState(
          message: error.toString(),
        );
      },
    );
  }
}

class AsyncValueListView<T> extends StatelessWidget {
  const AsyncValueListView({
    required this.value,
    required this.itemBuilder,
    this.emptyMessage = 'No items found',
    this.onError,
    super.key,
  });

  final AsyncValue<List<T>> value;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final String emptyMessage;
  final Function(Object error, StackTrace stackTrace)? onError;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (items) {
        if (items.isEmpty) {
          return EmptyState(
            title: 'No items',
            message: emptyMessage,
          );
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) =>
              itemBuilder(context, items[index], index),
        );
      },
      loading: () => _buildSkeletonList(),
      error: (error, stackTrace) {
        onError?.call(error, stackTrace);
        return ErrorState(message: error.toString());
      },
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.all(8),
        child: SkeletonProductCard(),
      ),
    );
  }
}
