import 'package:tech_nest/core/shared/domain/entities/category_entity.dart';

class ProductEntity {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final CategoryEntity category;
  final String imgUrl;

  ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.imgUrl,
  });

  ProductEntity.empty()
    : id = -1,
      name = "",
      description = "",
      price = 0.0,
      stock = 0,
      category = CategoryEntity.empty(),
      imgUrl = "";
}
