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
        key: const ValueKey('appShell.bottomNav'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        onTap: onTap,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: context.colors.textSecondary,
        selectedLabelStyle: context.labelSmall.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: context.labelSmall,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined, key: ValueKey('nav.home')),
            activeIcon: const Icon(
              Icons.home_rounded,
              key: ValueKey('nav.home.active'),
            ),
            label: context.t.nav.home,
          ),
          BottomNavigationBarItem(
            icon: const Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.shopping_cart_outlined, key: ValueKey('nav.cart')),
                CartBadge(),
              ],
            ),
            activeIcon: const Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.shopping_cart_rounded,
                  key: ValueKey('nav.cart.active'),
                ),
                CartBadge(),
              ],
            ),
            label: context.t.nav.cart,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.category_outlined,
              key: ValueKey('nav.categories'),
            ),
            activeIcon: const Icon(
              Icons.category_rounded,
              key: ValueKey('nav.categories.active'),
            ),
            label: context.t.nav.categories,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.receipt_long_outlined,
              key: ValueKey('nav.orders'),
            ),
            activeIcon: const Icon(
              Icons.receipt_long_rounded,
              key: ValueKey('nav.orders.active'),
            ),
            label: context.t.nav.orders,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.notifications_outlined,
              key: ValueKey('nav.notifications'),
            ),
            activeIcon: const Icon(
              Icons.notifications_rounded,
              key: ValueKey('nav.notifications.active'),
            ),
            label: context.t.nav.notifications,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.settings_outlined,
              key: ValueKey('nav.settings'),
            ),
            activeIcon: const Icon(
              Icons.settings_rounded,
              key: ValueKey('nav.settings.active'),
            ),
            label: context.t.nav.settings,
          ),
        ],
      ),
    );
  }
}
