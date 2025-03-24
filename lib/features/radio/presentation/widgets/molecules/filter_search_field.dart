import 'dart:async';

import 'package:flutter/material.dart';
import 'package:radio_stations/core/design_system/theme/app_colors.dart';
import 'package:radio_stations/core/design_system/theme/app_spacing.dart';
import 'package:radio_stations/core/utils/input_utils.dart';

/// A search field widget for filtering radio stations by name
class FilterSearchField extends StatefulWidget {
  /// Creates a new instance of [FilterSearchField]
  ///
  /// [searchTerm] is the current search term
  /// [onChanged] is called when the search term changes
  const FilterSearchField({
    required this.searchTerm,
    required this.onChanged,
    super.key,
  });

  /// The current search term
  final String searchTerm;

  /// Callback when search term changes
  final void Function(String) onChanged;

  @override
  State<FilterSearchField> createState() => _FilterSearchFieldState();
}

class _FilterSearchFieldState extends State<FilterSearchField> {
  late final TextEditingController _controller;
  final _debounce = Debouncer(milliseconds: 500);
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchTerm);
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(FilterSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchTerm != _controller.text && widget.searchTerm.isNotEmpty) {
      _controller.text = widget.searchTerm;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: 'Search stations...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            _controller.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    // Clear the search field and unfocus
                    InputUtils.unfocusAndThen(context, () {
                      _controller.clear();
                      widget.onChanged('');
                    });
                  },
                )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        fillColor: AppColors.background,
      ),
      onChanged: (value) {
        _debounce.run(() {
          // Only trigger search when input is empty or has at least 2 characters
          if (value.isEmpty || value.length >= 2) {
            widget.onChanged(value);
          }
        });
      },
      onTap: () {
        // Optional: if you want to perform actions when the field is tapped
      },
      onSubmitted: (_) {
        // Unfocus when user hits enter/done
        _focusNode.unfocus();
      },
    );
  }
}

/// A utility class to debounce rapid text input events
class Debouncer {
  /// Creates a new instance of [Debouncer]
  ///
  /// [milliseconds] is the delay duration in milliseconds
  Debouncer({required this.milliseconds});

  /// The delay duration in milliseconds
  final int milliseconds;

  Timer? _timer;

  /// Run the provided callback after the debounce period
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancel any pending callbacks
  void dispose() {
    _timer?.cancel();
  }
}
