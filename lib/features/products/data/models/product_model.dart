import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/entities/product_entity.dart';
import 'package:tech_nest/features/categories/data/models/category_model.dart';

class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final CategoryModel category;
  final String imgUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.imgUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: int.parse(json[ApiKeys.id].toString()),
      name: json[ApiKeys.name],
      description: json[ApiKeys.description],
      price: (json[ApiKeys.price] as num).toDouble(),
      stock: json[ApiKeys.stock],
      category: CategoryModel.fromJson(json[ApiKeys.category]),
      imgUrl: json[ApiKeys.imgUrl],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.name: name,
      ApiKeys.description: description,
      ApiKeys.price: price,
      ApiKeys.stock: stock,
      ApiKeys.category: category.toJson(),
      ApiKeys.imgUrl: imgUrl,
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      stock: stock,
      category: category.toEntity(),
      imgUrl: imgUrl,
    );
  }
}
