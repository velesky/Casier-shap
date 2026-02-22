import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final double purchasePrice;

  @HiveField(4)
  final double salePrice;

  @HiveField(5)
  final int stockQuantity;

  @HiveField(6)
  final int criticalThreshold;

  @HiveField(7)
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.purchasePrice,
    required this.salePrice,
    this.stockQuantity = 0,
    this.criticalThreshold = 10,
    this.imageUrl,
  });

  Product copyWith({
    String? name,
    String? category,
    double? purchasePrice,
    double? salePrice,
    int? stockQuantity,
    int? criticalThreshold,
    String? imageUrl,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      criticalThreshold: criticalThreshold ?? this.criticalThreshold,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
