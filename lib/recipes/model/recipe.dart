enum RecipeType {
  VERDE, AMARILLO, MORADO
}

class Recipe {

  BigInt? id;
  String? nombre;
  String? dosis;
  String? unidad;
  String? frecuencia;
  String? lapso;
  String? descripcion;
  String? tipo;
  String? idCreador;

  Recipe({
    required this.id,
    required this.nombre,
    required this.dosis,
    required this.unidad,
    required this.frecuencia,
    required this.lapso,
    required this.descripcion,
    required this.tipo,
    required this.idCreador
  });

  @override
  String toString() {
    return toJson().toString();
  }

  Recipe.fromJson(dynamic json) {
    id = BigInt.from(json['id']);
    nombre = json['nombre'];
    dosis = json['dosis'];
    unidad = json['unidad'];
    frecuencia = json['frecuencia'];
    lapso = json['lapso'];
    descripcion = json['descripcion'];
    tipo = json['tipo'];
    idCreador = json['id_creador'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id?.toInt();
    map['nombre'] = nombre;
    map['dosis'] = dosis;
    map['unidad'] = unidad;
    map['frecuencia'] = frecuencia;
    map['lapso'] = lapso;
    map['descripcion'] = descripcion;
    map['tipo'] = tipo;
    map['id_creador'] = idCreador;
    return map;
  }

}


class RecipeList {

  List<Recipe>? _listOfRecipes;

  List<Recipe>? get listOfRecipes => _listOfRecipes;

  RecipeList({
    List<Recipe>? listOfRecipes}){
    _listOfRecipes = listOfRecipes;
  }

  RecipeList.fromJson(dynamic json) {
    if (json['listOfRecipes'] != null) {
      _listOfRecipes = [];
      json['listOfRecipes'].forEach((v) {
        _listOfRecipes?.add(Recipe.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_listOfRecipes != null) {
      map['listOfRecipes'] = _listOfRecipes?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

