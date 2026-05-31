import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/features/onboarding/presentation/models/onboarding_page_data.dart';

void main() {
  group('OnboardingPageData', () {
    test('stores constructor values correctly', () {
      const color = Colors.blue;

      final model = OnboardingPageData(
        title: 'Title',
        description: 'Description',
        icon: Icons.home,
        color: color,
      );

      expect(model.title, 'Title');
      expect(model.description, 'Description');
      expect(model.icon, Icons.home);
      expect(model.color, color);
    });

    test('supports empty text values while preserving type safety', () {
      final model = OnboardingPageData(
        title: '',
        description: '',
        icon: Icons.info,
        color: Colors.red,
      );

      expect(model.title, isA<String>());
      expect(model.description, isA<String>());
      expect(model.title, isEmpty);
      expect(model.description, isEmpty);
    });
  });
}
