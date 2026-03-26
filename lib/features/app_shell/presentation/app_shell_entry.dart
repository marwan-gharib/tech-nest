import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavBar(
        navigationShell: widget.navigationShell,
        onTap: _goBranch,
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
