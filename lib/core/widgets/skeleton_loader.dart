import 'package:flutter/material.dart';

import '../design/app_duration.dart';
import '../design/app_radius.dart';
import '../design/app_spacing.dart';

class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = AppRadius.md,
    super.key,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDuration.skeleton,
      vsync: this,
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.3, end: 0.7).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;

    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: _opacity.value),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}

class SkeletonProductCard extends StatelessWidget {
  const SkeletonProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLoader(
              height: 200,
              borderRadius: AppRadius.md,
            ),
            const SizedBox(height: AppSpacing.lg),
            SkeletonLoader(
              height: 16,
              width: double.infinity,
              borderRadius: AppRadius.sm,
            ),
            const SizedBox(height: AppSpacing.sm),
            SkeletonLoader(
              height: 14,
              width: 150,
              borderRadius: AppRadius.sm,
            ),
            const SizedBox(height: AppSpacing.lg),
            SkeletonLoader(
              height: 20,
              width: 100,
              borderRadius: AppRadius.sm,
            ),
          ],
        ),
      ),
    );
  }
}
