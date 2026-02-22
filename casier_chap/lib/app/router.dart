import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/dashboard/presentation/splash_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/inventory/presentation/inventory_screen.dart';
import '../features/inventory/presentation/add_edit_product_screen.dart';
import '../features/sales/presentation/sales_screen.dart';
import '../features/sales/presentation/summary_screen.dart';
import '../features/history/presentation/history_screen.dart';
import 'main_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/inventory',
            builder: (context, state) => const InventoryScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddEditProductScreen(),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) =>
                    AddEditProductScreen(productId: state.pathParameters['id']),
              ),
            ],
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Profil (À venir)'))),
          ),
        ],
      ),
      GoRoute(
        path: '/sales',
        builder: (context, state) => const SalesScreen(),
        routes: [
          GoRoute(
            path: 'summary',
            builder: (context, state) => const SummaryScreen(),
          ),
        ],
      ),
    ],
  );
});
