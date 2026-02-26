import 'package:flutter/material.dart';

class SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  SearchHeaderDelegate(this.child);

  @override
  double get minExtent => 300;

  @override
  double get maxExtent => 500;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
