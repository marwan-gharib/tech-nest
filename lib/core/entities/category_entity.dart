class CategoryEntity {
  final int id;
  final String name;
  final String imgUrl;

  CategoryEntity({required this.id, required this.name, required this.imgUrl});

  CategoryEntity.empty() : id = -1, name = "", imgUrl = "";
}
