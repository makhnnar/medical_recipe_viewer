class Recipe {

  String id;
  String name;

  Recipe({
    this.id,
    this.name,
  });

  @override
  String toString() {
    return 'Recipe{id: $id, name: $name }';
  }
}