import 'package:tech_nest/core/domain/entities/category_entity.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final Category category;
  final String imgUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.imgUrl,
  });

  Product.empty()
    : id = -1,
      name = "",
      description = "",
      price = 0.0,
      stock = 0,
      category = Category.empty(),
      imgUrl = "";
}
