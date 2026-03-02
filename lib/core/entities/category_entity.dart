class Category {
  final int id;
  final String name;
  final String imgUrl;

  Category({required this.id, required this.name, required this.imgUrl});

  Category.empty() : id = -1, name = "", imgUrl = "";
}
