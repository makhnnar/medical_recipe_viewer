class Recipe {

  String id;
  String name;
  String dosis;
  String frecuencia;
  String lapso;
  String descripcion;

  Recipe({
    required this.id,
    required this.name,
    required this.dosis,
    required this.frecuencia,
    required this.lapso,
    required this.descripcion,
  });

  @override
  String toString() {
    return 'Recipe{id: $id, name: $name, dosis: $dosis, frecuencia: $frecuencia, lapso: $lapso, descripcion: $descripcion}';
  }
}