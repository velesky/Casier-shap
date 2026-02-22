import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/inventory_provider.dart';
import '../../../shared/models/product.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(filteredInventoryProvider);
    final selectedCategory = ref.watch(categoryFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Produits'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) =>
                        ref.read(searchQueryProvider.notifier).state = val,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un produit...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _FilterButton(
                  isSelected: selectedCategory != null,
                  onTap: () => _showCategoryPicker(context, ref),
                ),
              ],
            ),
          ),
        ),
      ),
      body: products.isEmpty
          ? _EmptyInventory(
              onSeed: () =>
                  ref.read(inventoryProvider.notifier).seedInitialData(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _ProductCard(product: products[index]);
              },
            ),
    );
  }

  void _showCategoryPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final categories = ['Tout', 'Bière', 'Soda', 'Eau', 'Autre'];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: categories.map((cat) {
              return ListTile(
                title: Text(cat),
                onTap: () {
                  ref.read(categoryFilterProvider.notifier).state =
                      cat == 'Tout' ? null : cat;
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final isCritical = product.stockQuantity <= product.criticalThreshold;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Image du produit (Icône par défaut)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.local_drink_rounded,
                color: AppColors.primaryOrange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    product.category,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.salePrice.toInt()} FCFA',
                    style: const TextStyle(
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isCritical)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.critical.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'ALERTE',
                      style: TextStyle(
                        color: AppColors.critical,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  '${product.stockQuantity}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isCritical ? AppColors.critical : AppColors.success,
                  ),
                ),
                const Text(
                  'en stock',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterButton({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.filter_list_rounded,
          color: isSelected ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _EmptyInventory extends StatelessWidget {
  final VoidCallback onSeed;
  const _EmptyInventory({required this.onSeed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Aucun produit trouvé',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onSeed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
            ),
            child: const Text(
              'Importer démo',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
