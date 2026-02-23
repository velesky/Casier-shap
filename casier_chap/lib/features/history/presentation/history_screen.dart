import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../inventory/providers/inventory_provider.dart';
import '../../../shared/models/product.dart';
import '../../../shared/models/daily_sale.dart';
import '../../../shared/widgets/glass_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(inventoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Historique')),
      body: ValueListenableBuilder<Box<DailySale>>(
        valueListenable: Hive.box<DailySale>('sales').listenable(),
        builder: (context, box, _) {
          final now = DateTime.now();
          final sevenDaysAgo = now.subtract(const Duration(days: 7));

          final sales = box.values
              .where(
                (s) =>
                    s.date.isAfter(sevenDaysAgo) ||
                    DateFormat('yyyyMMdd').format(s.date) ==
                        DateFormat('yyyyMMdd').format(sevenDaysAgo),
              )
              .toList()
              .reversed
              .toList();

          if (sales.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucun historique de vente',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: sales.length,
            itemBuilder: (context, index) {
              final sale = sales[index];
              final formattedDate = DateFormat(
                'dd MMMM yyyy',
                'fr_FR',
              ).format(sale.date);

              return Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.primaryOrange,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${sale.totalCaisse.toInt()} FCFA',
                              style: const TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32, color: AppColors.borderGlass),
                      for (final entry in sale.productSales.entries)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                products
                                    .firstWhere(
                                      (p) => p.id == entry.key,
                                      orElse: () => Product(
                                        id: entry.key,
                                        name: 'Produit #${entry.key}',
                                        category: '',
                                        purchasePrice: 0,
                                        salePrice: 0,
                                        stockQuantity: 0,
                                        criticalThreshold: 0,
                                      ),
                                    )
                                    .name,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                'x${entry.value}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.analytics_outlined,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Marge : ${sale.totalMarge.toInt()} FCFA',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
