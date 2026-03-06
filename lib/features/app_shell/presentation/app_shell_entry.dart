import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShellEntry extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShellEntry({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        body: navigationShell,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          child: BottomNavigationBar(
            useLegacyColorScheme: false,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined, weight: 100),
                label: "Home",
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.shopping_cart_outlined),
                label: "Cart",
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.category_outlined),
                label: "Categories",
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_outlined),
                label: "Settings",
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                label: "Profile",
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
              ),
            ],
            onTap: _goBranch,
            currentIndex: navigationShell.currentIndex,
          ),
        ),
      ),
    );
  }

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
