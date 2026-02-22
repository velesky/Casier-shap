import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'shared/models/product.dart';
import 'shared/models/daily_sale.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(DailySaleAdapter());

  // Open boxes
  await Hive.openBox<Product>('products');
  await Hive.openBox<DailySale>('sales');
  await Hive.openBox('settings');

  runApp(const ProviderScope(child: CasierChapApp()));
}
