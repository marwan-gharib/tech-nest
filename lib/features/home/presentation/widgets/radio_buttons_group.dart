import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/home/presentation/widgets/radio_tile.dart';

class RadioButtonsGroup<T> extends StatefulWidget {
  final List<T> values;
  final ValueChanged<T?> onTap;
  final String Function(T value)? labelBuilder;
  final IconData Function(T value)? iconBuilder;
  final T? initialValue;

  const RadioButtonsGroup({
    required this.values,
    required this.onTap,
    this.initialValue,
    this.labelBuilder,
    this.iconBuilder,
    super.key,
  });

  @override
  State<RadioButtonsGroup<T>> createState() => _RadioButtonsGroupState<T>();
}

class _RadioButtonsGroupState<T> extends State<RadioButtonsGroup<T>> {
  T? _selected;

  @override
  void initState() {
    _selected = widget.initialValue;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RadioButtonsGroup<T> oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      _selected = widget.initialValue;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: widget.values.map((value) {
        final isSelected = _selected == value;
        final label = widget.labelBuilder != null
            ? widget.labelBuilder!(value)
            : value.toString();
        final icon = widget.iconBuilder?.call(value);

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: RadioTile(
            label: label,
            icon: icon,
            isSelected: isSelected,
            onTap: () {
              setState(() => _selected = value);
              widget.onTap(value);
            },
            theme: theme,
          ),
        );
      }).toList(),
    );
  }
}
