import 'package:flutter/material.dart';

import '../design/app_radius.dart';
import '../design/app_spacing.dart';
import '../extensions/context_extensions.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    required this.onChanged,
    this.hintText = 'Search products...',
    this.onSubmitted,
    super.key,
  });

  final Function(String) onChanged;
  final String hintText;
  final Function(String)? onSubmitted;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: _controller,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      hintText: widget.hintText,
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(
        context.colorScheme.brightness == Brightness.light
            ? const Color(0xFFF3F4F6)
            : const Color(0xFF2A2A2A),
      ),
      shape: WidgetStatePropertyAll(AppRadius.lgBorder),
      leading: const Icon(Icons.search),
      trailing: [
        if (_controller.text.isNotEmpty)
          IconButton(
            onPressed: () {
              _controller.clear();
              widget.onChanged('');
            },
            icon: const Icon(Icons.clear),
          ),
      ],
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      ),
    );
  }
}
