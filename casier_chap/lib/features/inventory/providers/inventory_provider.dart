import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../shared/models/product.dart';

class InventoryNotifier extends StateNotifier<List<Product>> {
  final Box<Product> _box;

  InventoryNotifier(this._box) : super([]) {
    _loadProducts();
  }

  void _loadProducts() {
    state = _box.values.toList();
  }

  Future<void> addProduct(Product product) async {
    await _box.put(product.id, product);
    state = [...state, product];
  }

  Future<void> updateProduct(Product product) async {
    await _box.put(product.id, product);
    state = [
      for (final p in state)
        if (p.id == product.id) product else p,
    ];
  }

  Future<void> deleteProduct(String id) async {
    await _box.delete(id);
    state = state.where((p) => p.id != id).toList();
  }

  // Initialisation des produits de démo si la base est vide
  Future<void> seedInitialData() async {
    if (_box.isEmpty) {
      final initialProducts = [
        Product(
          id: '1',
          name: 'Bock 65cl',
          category: 'Bière',
          purchasePrice: 600,
          salePrice: 1000,
          stockQuantity: 120,
          criticalThreshold: 20,
        ),
        Product(
          id: '2',
          name: 'Guinness 33cl',
          category: 'Bière',
          purchasePrice: 700,
          salePrice: 1200,
          stockQuantity: 15,
          criticalThreshold: 20,
        ),
        Product(
          id: '3',
          name: 'Coca-Cola 30cl',
          category: 'Soda',
          purchasePrice: 400,
          salePrice: 600,
          stockQuantity: 45,
          criticalThreshold: 10,
        ),
      ];
      for (final p in initialProducts) {
        await addProduct(p);
      }
    }
  }
}

final productsBoxProvider = Provider<Box<Product>>((ref) {
  return Hive.box<Product>('products');
});

final inventoryProvider =
    StateNotifierProvider<InventoryNotifier, List<Product>>((ref) {
      final box = ref.watch(productsBoxProvider);
      return InventoryNotifier(box);
    });

final searchQueryProvider = StateProvider<String>((ref) => '');
final categoryFilterProvider = StateProvider<String?>((ref) => null);

final filteredInventoryProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(inventoryProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final category = ref.watch(categoryFilterProvider);

  return products.where((p) {
    final matchesSearch = p.name.toLowerCase().contains(query);
    final matchesCategory = category == null || p.category == category;
    return matchesSearch && matchesCategory;
  }).toList();
});
