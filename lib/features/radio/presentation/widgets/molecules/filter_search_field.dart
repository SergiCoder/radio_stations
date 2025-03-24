import 'package:flutter/material.dart';
import 'package:radio_stations/core/constants/app_constants.dart';
import 'package:radio_stations/core/design_system/theme/app_spacing.dart';
import 'package:radio_stations/core/utils/debouncer.dart';
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
  final _debounce = Debouncer();
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
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  /// Builds the suffix icon for the search field
  Widget? _buildSuffixIcon() {
    if (_controller.text.isEmpty) return null;

    return IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        InputUtils.unfocusAndThen(context, () {
          _controller.clear();
          widget.onChanged('');
        });
      },
    );
  }

  /// Handles text changes with debouncing
  void _handleTextChange(String value) {
    _debounce.run(() {
      final isValid =
          value.isEmpty || value.length >= AppConstants.minSearchTermLength;

      if (isValid) {
        widget.onChanged(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: 'Search stations...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _buildSuffixIcon(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        fillColor: theme.scaffoldBackgroundColor,
      ),
      onChanged: _handleTextChange,
      onSubmitted: (_) => _focusNode.unfocus(),
    );
  }
}
