import 'package:flutter/material.dart';

/// A wrapper that ensures a list item animates only once when it appears
/// on screen for the first time. Scrolling away and coming back will
/// render the item instantly without triggering the animation again.
///
/// Under the hood, this uses [PageStorage] to track which items have
/// already animated without holding massive state in memory or requiring
/// external state managers.
class AnimateOnceWrapper extends StatefulWidget {
  /// A unique namespace for the list or screen to prevent ID collisions.
  final String namespace;

  /// Unique identifier for this item (e.g., product ID or list index).
  final String id;

  /// The static widget that should be displayed instantly after the
  /// animation has occurred once.
  final Widget child;

  /// A builder that returns the animated version of the child. This is
  /// only called if the item hasn't been animated yet.
  final Widget Function(BuildContext context, Widget child) animationBuilder;

  const AnimateOnceWrapper({
    required this.namespace,
    required this.id,
    required this.child,
    required this.animationBuilder,
    super.key,
  });

  @override
  State<AnimateOnceWrapper> createState() => _AnimateOnceWrapperState();
}

class _AnimateOnceWrapperState extends State<AnimateOnceWrapper> {
  bool _hasAnimated = false;
  late final String _storageKey;

  @override
  void initState() {
    super.initState();
    _storageKey = 'anim_once_${widget.namespace}_${widget.id}';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Read from PageStorage to check if this specific item has already
    // animated during the lifespan of the current route.
    if (!_hasAnimated) {
      final animatedInStorage = PageStorage.of(context).readState(
        context,
        identifier: _storageKey,
      ) as bool?;
      
      if (animatedInStorage == true) {
        _hasAnimated = true;
      } else {
        // If it hasn't animated yet, mark it for the future so it doesn't
        // animate again when scrolling back.
        PageStorage.of(context).writeState(
          context,
          true,
          identifier: _storageKey,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasAnimated) {
      return widget.child;
    }

    // Flag for local state just in case the widget isn't destroyed
    // but rebuilt for some reason (e.g. setState in a parent).
    _hasAnimated = true;
    
    return widget.animationBuilder(context, widget.child);
  }
}
