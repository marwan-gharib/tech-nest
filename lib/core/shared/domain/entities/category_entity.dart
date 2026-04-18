import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String imgUrl;

  const CategoryEntity({required this.id, required this.name, required this.imgUrl});

  const CategoryEntity.empty() : id = -1, name = "", imgUrl = "";

  @override
  List<Object?> get props => [id, name, imgUrl];
}
