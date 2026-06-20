import 'package:flutter/material.dart';

class PriceText extends StatelessWidget {
  const PriceText(this.price, {this.style, super.key});

  final double price;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      '\$${price.toStringAsFixed(2)}',
      style:
          style ??
          Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
