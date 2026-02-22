import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/colors.dart';

class MainScaffold extends ConsumerWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current path to highlight correct navigation item
    final String location = GoRouterState.of(context).uri.path;

    int calculateSelectedIndex() {
      if (location == '/dashboard') return 0;
      if (location == '/inventory') return 1;
      if (location == '/history') return 3;
      if (location == '/profile') return 4;
      return 0;
    }

    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/sales'),
        label: const Text(
          'Déclarer ventes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.surface,
        shape: const CircularNotchedRectangle(),
        notchMargin: 12.0,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: Icons.grid_view_rounded,
                label: 'Accueil',
                isSelected: calculateSelectedIndex() == 0,
                onTap: () => context.go('/dashboard'),
              ),
              _NavBarItem(
                icon: Icons.inventory_2_rounded,
                label: 'Stock',
                isSelected: calculateSelectedIndex() == 1,
                onTap: () => context.go('/inventory'),
              ),
              const SizedBox(width: 80), // Space for FAB
              _NavBarItem(
                icon: Icons.history_rounded,
                label: 'Historique',
                isSelected: calculateSelectedIndex() == 3,
                onTap: () => context.go('/history'),
              ),
              _NavBarItem(
                icon: Icons.person_rounded,
                label: 'Profil',
                isSelected: calculateSelectedIndex() == 4,
                onTap: () => context.go('/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected
                ? AppColors.primaryOrange
                : AppColors.textSecondary,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppColors.primaryOrange
                  : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
