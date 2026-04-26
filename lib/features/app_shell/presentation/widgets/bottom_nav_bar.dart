import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/app_shell/presentation/widgets/cart_badge.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class BottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    required this.navigationShell,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        color: context.colors.surface,
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.shifting,
        currentIndex: navigationShell.currentIndex,
        onTap: onTap,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: context.colors.textSecondary,
        selectedLabelStyle: context.labelSmall.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: context.labelSmall,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home_rounded),
            label: context.t.nav.home,
          ),
          BottomNavigationBarItem(
            icon: const Stack(
              clipBehavior: Clip.none,
              children: [Icon(Icons.shopping_cart_outlined), CartBadge()],
            ),
            activeIcon: const Stack(
              clipBehavior: Clip.none,
              children: [Icon(Icons.shopping_cart_rounded), CartBadge()],
            ),
            label: context.t.nav.cart,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.category_outlined),
            activeIcon: const Icon(Icons.category_rounded),
            label: context.t.nav.categories,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long_outlined),
            activeIcon: const Icon(Icons.receipt_long_rounded),
            label: context.t.nav.orders,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings_rounded),
            label: context.t.nav.settings,
          ),
        ],
      ),
    );
  }
}
