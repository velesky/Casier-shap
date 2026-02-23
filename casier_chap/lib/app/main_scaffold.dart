import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/colors.dart';
import '../shared/widgets/bouncy_tappable.dart';
import '../shared/widgets/pulsing_glow.dart';

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
      floatingActionButton: PulsingGlow(
        glowColor: AppColors.primaryOrange,
        child: BouncyTappable(
          onTap: () => context.push('/sales'),
          child: FloatingActionButton(
            onPressed: () => context.push('/sales'),
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(Icons.add_shopping_cart_rounded, size: 28),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.surface,
        shape: const CircularNotchedRectangle(),
        notchMargin: 12.0,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: Icons.home_rounded,
                label: 'Accueil',
                isSelected: calculateSelectedIndex() == 0,
                onTap: () => context.go('/dashboard'),
              ),
              _NavBarItem(
                icon: Icons.inventory_2_rounded,
                label: 'Produits',
                isSelected: calculateSelectedIndex() == 1,
                onTap: () => context.go('/inventory'),
              ),
              // Space for FAB area with label
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Ventes',
                    style: TextStyle(
                      color: location == '/sales'
                          ? AppColors.primaryOrange
                          : AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
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
    return BouncyTappable(
      onTap: onTap,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isSelected
                  ? AppColors.primaryOrange
                  : AppColors.textSecondary,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
