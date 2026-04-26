import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/app_shell/presentation/widgets/bottom_nav_bar.dart';

class AppShellEntry extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppShellEntry({required this.navigationShell, super.key});

  @override
  State<AppShellEntry> createState() => _AppShellEntryState();
}

class _AppShellEntryState extends State<AppShellEntry> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: context.colorScheme.primary, width: 2.5),
            ),
          ),
          child: BottomNavBar(
            navigationShell: widget.navigationShell,
            onTap: _goBranch,
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
}
