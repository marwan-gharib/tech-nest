import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/domain/entities/category_entity.dart';

class CategoryModel {
  final int id;
  final String name;
  final String imgUrl;

  CategoryModel({required this.id, required this.name, required this.imgUrl});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      imgUrl: json[ApiKeys.imgUrl] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {ApiKeys.id: id, ApiKeys.name: name, ApiKeys.imgUrl: imgUrl};
  }

  Category toEntity() {
    return Category(id: id, name: name, imgUrl: imgUrl);
  }
}
