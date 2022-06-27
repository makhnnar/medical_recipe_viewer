class Recipe {

  String? id;
  String? name;
  String? dosis;
  String? frecuencia;
  String? lapso;
  String? descripcion;

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
    return toJson().toString();
  }

  Recipe.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    dosis = json['dosis'];
    frecuencia = json['frecuencia'];
    lapso = json['lapso'];
    descripcion = json['descripcion'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['dosis'] = dosis;
    map['frecuencia'] = frecuencia;
    map['lapso'] = lapso;
    map['descripcion'] = descripcion;
    return map;
  }

}