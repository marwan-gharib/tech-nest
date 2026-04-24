import 'package:equatable/equatable.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';

class ProductEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final CategoryEntity category;
  final String imgUrl;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.imgUrl,
  });

  const ProductEntity.empty()
    : id = -1,
      name = "",
      description = "",
      price = 0.0,
      stock = 0,
      category = const CategoryEntity.empty(),
      imgUrl = "";

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    stock,
    category,
    imgUrl,
  ];
}
