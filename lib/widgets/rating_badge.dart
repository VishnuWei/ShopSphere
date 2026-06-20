import 'package:flutter/material.dart';

class RatingBadge extends StatelessWidget {
  const RatingBadge(this.rating, {super.key});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, color: Color(0xFFF4B400), size: 18),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
