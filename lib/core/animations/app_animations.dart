import 'package:flutter/material.dart';

class AppAnimations {
  const AppAnimations._();

  // ── General durations ──────────────────────────────────────────────────────
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration extraSlow = Duration(milliseconds: 1000);

  // ── General curves ─────────────────────────────────────────────────────────
  static const Curve standardCurve = Curves.easeInOutCubic;
  static const Curve emphasizedCurve = Curves.easeInOutQuart;
  static const Curve decelerateCurve = Curves.decelerate;
  static const Curve bounceCurve = Curves.elasticOut;

  // ── Distances for slide animations ─────────────────────────────────────────
  static const double slideOffset = 24.0;
}
