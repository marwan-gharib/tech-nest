import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/products/presentation/widgets/counter_button.dart';

class CustomCounter extends StatefulWidget {
  final int maxCount;
  final int initialCount;
  final ValueChanged<int>? onChanged;

  const CustomCounter({
    required this.maxCount,
    this.onChanged,
    this.initialCount = 1,
    super.key,
  });

  @override
  State<CustomCounter> createState() => _CustomCounterState();
}

class _CustomCounterState extends State<CustomCounter> {
  late final ValueNotifier<int> _counter;

  @override
  void initState() {
    super.initState();
    _counter = ValueNotifier<int>(
      widget.initialCount > widget.maxCount
          ? widget.maxCount
          : widget.initialCount,
    );
  }

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  void _increment() {
    if (_counter.value < widget.maxCount) {
      _counter.value++;
      widget.onChanged?.call(_counter.value);
    }
  }

  void _decrement() {
    if (_counter.value > 1) {
      _counter.value--;
      widget.onChanged?.call(_counter.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
            ValueListenableBuilder<int>(
              valueListenable: _counter,
              builder: (context, value, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSpacing.md,
                  children: [
                    CounterButton(
                      icon: Icons.remove_rounded,
                      onPressed: _decrement,
                      isEnabled: widget.maxCount > 0 && value > 1,
                    ),
                    SizedBox(
                      width: 24,
                      child: Text(
                        "$value",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    CounterButton(
                      icon: Icons.add_rounded,
                      onPressed: _increment,
                      isEnabled: widget.maxCount > 0 && value < widget.maxCount,
                    ),
                  ],
                );
              },
            ),
        if (widget.maxCount == 0)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 2,
                color: colorScheme.error.withValues(alpha: 0.5),
              ),
            ),
          ),
      ],
    );
  }
}
