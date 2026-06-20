import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../design/app_radius.dart';
import '../design/app_spacing.dart';
import '../extensions/context_extensions.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({
    required this.images,
    this.height = 300,
    this.onImageChanged,
    super.key,
  });

  final List<String> images;
  final double height;
  final Function(int index)? onImageChanged;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main image carousel
        ClipRRect(
          borderRadius: AppRadius.lgRadius,
          child: SizedBox(
            height: widget.height,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
                widget.onImageChanged?.call(index);
              },
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: widget.images[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: context.colorScheme.surfaceContainerHighest,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: context.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: context.colorScheme.outline,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Dot indicators
        _buildDotIndicators(context),
        const SizedBox(height: AppSpacing.lg),
        // Thumbnail selector
        if (widget.images.length > 1) _buildThumbnails(context),
      ],
    );
  }

  Widget _buildDotIndicators(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.images.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 8,
          width: _currentIndex == index ? 24 : 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? context.colorScheme.primary
                : context.colorScheme.outline,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnails(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.images.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final isSelected = index == _currentIndex;
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              decoration: BoxDecoration(
                borderRadius: AppRadius.mdRadius,
                border: Border.all(
                  color: isSelected
                      ? context.colorScheme.primary
                      : context.colorScheme.outlineVariant,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: AppRadius.mdRadius,
                child: CachedNetworkImage(
                  imageUrl: widget.images[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: context.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
