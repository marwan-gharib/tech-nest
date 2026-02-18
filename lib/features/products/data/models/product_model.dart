import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';

class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final int categoryId;
  final String imgUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.categoryId,
    required this.imgUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: int.parse(json[ApiKeys.id].toString()),
      name: json[ApiKeys.name],
      description: json[ApiKeys.description],
      price: (json[ApiKeys.price] as num).toDouble(),
      stock: json[ApiKeys.stock],
      categoryId: json[ApiKeys.categoryID],
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
      ApiKeys.categoryID: categoryId,
      ApiKeys.imgUrl: imgUrl,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      stock: stock,
      categoryId: categoryId,
      imgUrl: imgUrl,
    );
  }
}
