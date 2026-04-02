import 'package:flutter/material.dart';

class DemoScreen extends StatelessWidget {
  final String label;

  const DemoScreen({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(label, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}
