import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../shared/models/daily_sale.dart';
import '../../../shared/models/product.dart';
import '../../inventory/providers/inventory_provider.dart';

class SalesNotifier extends StateNotifier<Map<String, int>> {
  final Ref _ref;

  SalesNotifier(this._ref) : super({});

  void updateQuantity(String productId, int delta) {
    final current = state[productId] ?? 0;
    final newValue = current + delta;
    if (newValue <= 0) {
      final newState = Map<String, int>.from(state)..remove(productId);
      state = newState;
    } else {
      state = {...state, productId: newValue};
    }
  }

  double calculateTotalCaisse() {
    final products = _ref.read(inventoryProvider);
    double total = 0;
    state.forEach((id, qty) {
      final product = products.firstWhere((p) => p.id == id);
      total += product.salePrice * qty;
    });
    return total;
  }

  double calculateTotalMarge() {
    final products = _ref.read(inventoryProvider);
    double total = 0;
    state.forEach((id, qty) {
      final product = products.firstWhere((p) => p.id == id);
      total += (product.salePrice - product.purchasePrice) * qty;
    });
    return total;
  }

  Future<void> saveSales() async {
    if (state.isEmpty) return;

    final date = DateTime.now();
    final saleId = DateFormat('yyyyMMdd').format(date);
    final totalCaisse = calculateTotalCaisse();
    final totalMarge = calculateTotalMarge();

    final dailySale = DailySale(
      id: saleId,
      date: date,
      productSales: Map<String, int>.from(state),
      totalCaisse: totalCaisse,
      totalMarge: totalMarge,
    );

    // Persist to Hive (use put to update existing day or create new)
    final box = Hive.box<DailySale>('sales');
    final existing = box.get(saleId);

    if (existing != null) {
      // Merge sales if same day?
      // For simplicity in this MVP, we replace or append.
      // The user usually does one big report.
      await box.put(saleId, dailySale);
    } else {
      await box.put(saleId, dailySale);
    }

    // Decrement inventory stock
    final inventoryNotifier = _ref.read(inventoryProvider.notifier);
    final inventory = _ref.read(inventoryProvider);
    for (final entry in state.entries) {
      final product = inventory.firstWhere((p) => p.id == entry.key);
      final updatedProduct = Product(
        id: product.id,
        name: product.name,
        category: product.category,
        purchasePrice: product.purchasePrice,
        salePrice: product.salePrice,
        stockQuantity: product.stockQuantity - entry.value,
        criticalThreshold: product.criticalThreshold,
        imageUrl: product.imageUrl,
      );
      await inventoryNotifier.updateProduct(updatedProduct);
    }

    // Clear current sales state
    state = {};
  }

  Future<void> saveAndShare() async {
    if (state.isEmpty) return;

    final date = DateTime.now();
    final totalCaisse = calculateTotalCaisse();

    // Prepare WhatsApp Message before clearing state
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    String message = '*RAPPORT DE VENTES - $formattedDate* 🍻\n\n';

    final products = _ref.read(inventoryProvider);
    state.forEach((id, qty) {
      final product = products.firstWhere((p) => p.id == id);
      message += '• ${product.name} : $qty\n';
    });

    message += '\n💰 *TOTAL CAISSE : ${totalCaisse.toInt()} FCFA*';

    // Save data
    await saveSales();

    // Share
    await Share.share(message);
  }
}

final salesProvider = StateNotifierProvider<SalesNotifier, Map<String, int>>((
  ref,
) {
  return SalesNotifier(ref);
});
