class Recipe {

  String id;
  String name;

  Recipe({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    return 'Recipe{id: $id, name: $name }';
  }
}