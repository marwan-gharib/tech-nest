import 'package:flutter/material.dart';

class CustomCounter extends StatefulWidget {
  final int stock;
  const CustomCounter({required this.stock, super.key});

  @override
  State<CustomCounter> createState() => _CustomCounterState();
}

class _CustomCounterState extends State<CustomCounter> {
  late final ValueNotifier<int> _counter;

  @override
  void initState() {
    super.initState();
    _counter = ValueNotifier<int>(1);
  }

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  void _increment() {
    if (_counter.value < widget.stock) {
      _counter.value++;
    }
  }

  void _decrement() {
    if (_counter.value > 1) {
      _counter.value--;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        _buildCounterButton(context, icon: Icons.remove, onPressed: _decrement),
        ValueListenableBuilder<int>(
          valueListenable: _counter,
          builder: (context, value, _) {
            return Text(
              "$value",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: 15,
                color: Theme.of(context).shadowColor,
              ),
            );
          },
        ),
        _buildCounterButton(context, icon: Icons.add, onPressed: _increment),
      ],
    );
  }

  Widget _buildCounterButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) => InkWell(
    onTap: onPressed,
    child: Container(
      height: 26,
      width: 32,
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Icon(icon, size: 20, color: Theme.of(context).shadowColor),
    ),
  );
}
