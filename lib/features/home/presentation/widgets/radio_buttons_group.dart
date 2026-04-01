import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

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
          child: _RadioTile(
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

class _RadioTile extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _RadioTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.08)
                : theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              const Spacer(),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 13,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
