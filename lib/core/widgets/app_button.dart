import 'package:flutter/material.dart';

import '../design/app_spacing.dart';

enum ButtonVariant { filled, outlined, text }

enum ButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.variant = ButtonVariant.filled,
    this.size = ButtonSize.large,
    this.icon,
    super.key,
  });

  final VoidCallback onPressed;
  final String label;
  final bool isLoading;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState(context);
    }

    final widget = icon != null
        ? _buildIconButton(context)
        : _buildTextButton(context);

    return SizedBox(
      height: _sizeHeight,
      child: widget,
    );
  }

  double get _sizeHeight {
    return switch (size) {
      ButtonSize.small => 36,
      ButtonSize.medium => 40,
      ButtonSize.large => AppSpacing.buttonHeight,
    };
  }

  Widget _buildTextButton(BuildContext context) {
    return switch (variant) {
      ButtonVariant.filled => FilledButton(
          onPressed: onPressed,
          child: Text(label),
        ),
      ButtonVariant.outlined => OutlinedButton(
          onPressed: onPressed,
          child: Text(label),
        ),
      ButtonVariant.text => TextButton(
          onPressed: onPressed,
          child: Text(label),
        ),
    };
  }

  Widget _buildIconButton(BuildContext context) {
    final buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        const SizedBox(width: AppSpacing.sm),
        Text(label),
      ],
    );

    return switch (variant) {
      ButtonVariant.filled => FilledButton(
          onPressed: onPressed,
          child: buttonContent,
        ),
      ButtonVariant.outlined => OutlinedButton(
          onPressed: onPressed,
          child: buttonContent,
        ),
      ButtonVariant.text => TextButton(
          onPressed: onPressed,
          child: buttonContent,
        ),
    };
  }

  Widget _buildLoadingState(BuildContext context) {
    return FilledButton(
      onPressed: null,
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
