import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/cubits/cart_cubit/cart_cubit.dart';

class AppShellEntry extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppShellEntry({required this.navigationShell, super.key});

  @override
  State<AppShellEntry> createState() => _AppShellEntryState();
}

class _AppShellEntryState extends State<AppShellEntry> {
  int cartItemsCount = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: widget.navigationShell,
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
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart_outlined),
                    _cartCountIcon(),
                  ],
                ),
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
            currentIndex: widget.navigationShell.currentIndex,
          ),
        ),
      ),
    );
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  Widget _cartCountLabel(int itemsCount) {
    return Text(
      itemsCount.toString(),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onTertiary,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _cartCountIcon() {
    return Positioned(
      right: -6,
      top: -6,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryFixed,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
        child: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {
            if (state is CartLoaded) {
              cartItemsCount = state.cart.items.length;
            }
          },
          builder: (context, state) {
            if (state is CartLoaded) {
              return _cartCountLabel(state.cart.items.length);
            }
            return _cartCountLabel(cartItemsCount);
          },
        ),
      ),
    );
  }
}
