import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_text_styles.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("D e m o", style: AppTextStyles.headlineLarge)),
    );
  }
}
