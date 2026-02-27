import 'package:flutter/material.dart';

class SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  SearchHeaderDelegate({required this.child});

  @override
  double get minExtent => 65;

  @override
  double get maxExtent => 20;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent ||
        oldDelegate.minExtent != minExtent;
  }
}
