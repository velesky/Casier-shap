import 'package:hive/hive.dart';

part 'daily_sale.g.dart';

@HiveType(typeId: 1)
class DailySale extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final Map<String, int> productSales; // productId -> quantity

  @HiveField(3)
  final double totalCaisse;

  @HiveField(4)
  final double totalMarge;

  DailySale({
    required this.id,
    required this.date,
    required this.productSales,
    required this.totalCaisse,
    required this.totalMarge,
  });
}
