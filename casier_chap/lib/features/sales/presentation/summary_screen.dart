import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../inventory/providers/inventory_provider.dart';
import '../providers/sales_provider.dart';

class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(inventoryProvider);
    final salesState = ref.watch(salesProvider);
    final notifier = ref.read(salesProvider.notifier);

    final totalCaisse = notifier.calculateTotalCaisse();
    final totalMarge = notifier.calculateTotalMarge();
    final dateStr = DateFormat('dd MMMM yyyy', 'fr_FR').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Résumé du jour'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Ventes du $dateStr',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),

                // Summary Stats Card
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _StatRow(
                        label: 'Total Encaissé',
                        value: '${totalCaisse.toInt()} FCFA',
                        valueColor: AppColors.primaryOrange,
                        isBold: true,
                      ),
                      const Divider(color: Colors.white12, height: 32),
                      _StatRow(
                        label: 'Marge Estimée',
                        value: '${totalMarge.toInt()} FCFA',
                        valueColor: AppColors.success,
                      ),
                      const Divider(color: Colors.white12, height: 32),
                      _StatRow(
                        label: 'Articles Vendus',
                        value: '${salesState.values.fold(0, (a, b) => a + b)}',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                const Text(
                  'Détails par produit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),

                // Product list
                ...salesState.entries.map((entry) {
                  final product = products.firstWhere((p) => p.id == entry.key);
                  final itemTotal = product.salePrice * entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'x${entry.value}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryOrange,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        Text(
                          '${itemTotal.toInt()} F',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          // Action Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: () async {
                  await notifier.saveAndShare();
                  if (context.mounted) {
                    context.go('/dashboard');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.share_rounded),
                    SizedBox(width: 8),
                    Text(
                      'Partager sur WhatsApp',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _StatRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.textPrimary,
            fontSize: isBold ? 20 : 17,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
