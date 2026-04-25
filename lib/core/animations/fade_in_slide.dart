import 'package:flutter/material.dart';
import 'package:tech_nest/core/animations/app_animations.dart';

enum FadeInSlideDirection { btt, ttb, ltr, rtl }

class FadeInSlide extends StatefulWidget {
  final Widget child;
  final Duration? duration;
  final Duration delay;
  final FadeInSlideDirection direction;
  final double? offset;
  final Curve curve;

  const FadeInSlide({
    required this.child,
    this.duration,
    this.delay = Duration.zero,
    this.direction = FadeInSlideDirection.btt,
    this.offset,
    this.curve = AppAnimations.standardCurve,
    super.key,
  });

  @override
  State<FadeInSlide> createState() => _FadeInSlideState();
}

class _FadeInSlideState extends State<FadeInSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? AppAnimations.medium,
    );

    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    final double offsetValue = widget.offset ?? AppAnimations.slideOffset;
    Offset startOffset;

    switch (widget.direction) {
      case FadeInSlideDirection.btt:
        startOffset = Offset(0, offsetValue);
        break;
      case FadeInSlideDirection.ttb:
        startOffset = Offset(0, -offsetValue);
        break;
      case FadeInSlideDirection.ltr:
        startOffset = Offset(-offsetValue, 0);
        break;
      case FadeInSlideDirection.rtl:
        startOffset = Offset(offsetValue, 0);
        break;
    }

    _offset = Tween<Offset>(
      begin: startOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(offset: _offset.value, child: child),
        );
      },
      child: widget.child,
    );
  }
}
