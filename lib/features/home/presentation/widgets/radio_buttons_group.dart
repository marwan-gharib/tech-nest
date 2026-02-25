import 'package:flutter/material.dart';

class RadioButtonsGroup<T> extends StatefulWidget {
  final List<T> values;
  final ValueChanged<T?> onTap;
  final String Function(T value)? labelBuilder;
  final T? initialValue;

  const RadioButtonsGroup({
    required this.values,
    required this.onTap,
    this.initialValue,
    this.labelBuilder,
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
    return RadioGroup<T>(
      groupValue: _selected,
      onChanged: (val) {
        setState(() {
          _selected = val;
        });
        widget.onTap(val);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.values
            .map(
              (value) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<T>(value: value),
                  Text(
                    widget.labelBuilder != null
                        ? widget.labelBuilder!(value)
                        : value.toString(),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
