import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';

import '../../utils/data_validations.dart';
import '../../values/contanst.dart';

enum UnitType{
  MASA,
  VOL
}

enum UnitOption{
  gr,
  mg,
  ug,
  ng,
  ml,
  oz,
}

enum TimeUnit{
  DIA,
  SEMANA,
  MES
}

class RecipesCreationFieldState extends ChangeNotifier{

  RecipeType _type = RecipeType.VERDE;

  UnitType unitType = UnitType.MASA;

  UnitOption unitOption = UnitOption.gr;

  TimeUnit timeFrequency = TimeUnit.DIA;

  TimeUnit timeLapse = TimeUnit.DIA;

  String _nombre = "";
  set nombre(String value){
      _nombre = value;
  }
  String get nombre => _nombre;

  String _dosis = "";
  set dosis(String value){
    print("value: value");
    if(validateValueWithRexExpression(value, RegularExpressions.numero)){
      _dosis = value;
    }
  }
  String get dosis => _dosis;

  String _unidad = "";
  set unidad(String value){
    print("value: $value");
    if(validateValueWithRexExpression(value, RegularExpressions.unidad)){
      _unidad = value;
    }
  }
  String get unidad => _unidad;

  String _frecuencia = "";
  set frecuencia(String value){
    print("value: value");
    if(validateValueWithRexExpression(value, RegularExpressions.numero)){
      _frecuencia = value;
    }
  }
  String get frecuencia => _frecuencia;

  String _lapso = "";
  set lapso(String value){
    print("value: value");
    if(validateValueWithRexExpression(value, RegularExpressions.numero)){
      _lapso = value;
    }
  }
  String get lapso => _lapso;

  String _descripcion = "";
  set descripcion(String value){
      _descripcion = value;
  }
  String get descripcion => _descripcion;

  int tipo = 0;

  int _gWei = 5;
  set gWei(String value){
    int intValue = int.tryParse(value)??0;
    if(intValue<5) {
      intValue = 5;
      return;
    };
    _gWei = intValue;
  }
  String get gWei => _gWei.toString();

  Map<UnitType,List<UnitOption>> unidades = {
    UnitType.MASA : [
      UnitOption.gr,
      UnitOption.mg,
      UnitOption.ug,
      UnitOption.ng
    ],
    UnitType.VOL : [
      UnitOption.ml,
      UnitOption.oz
    ],
  };

  bool isLoading = false;

  RecipesCreationFieldState();

  void setLoading(bool value){
    isLoading = value;
    notifyListeners();
  }

  void setRecipeType(RecipeType recipeType){
    this._type = recipeType;
    notifyListeners();
  }

  RecipeType getRecipeType(){
    return _type;
  }

  void setOptionsToChoose(UnitType type){
    unitType = type;
    unitOption = unidades[type]![0];
    notifyListeners();
  }

  void setUnitOption(UnitOption newValue) {
    unitOption = newValue;
    notifyListeners();
  }

  void setTimeFrequency(TimeUnit newValue) {
    timeFrequency = newValue;
    timeLapse = newValue;
    notifyListeners();
  }

  void setTimeLapse(TimeUnit newValue) {
    if(newValue.index<timeFrequency.index) return;
    timeLapse = newValue;
    notifyListeners();
  }

  void cleanFields(){
    _nombre = "";
    _dosis = "";
    _unidad = "";
    _frecuencia = "";
    _lapso = "";
    _descripcion = "";
    tipo = 0;
    unitType = UnitType.MASA;
    unitOption = unidades[UnitType.MASA]![0];
  }

  //createa a recipe with the current values and receive the id of the creator
  Recipe createRecipe(String idCreator){
    return Recipe(
      id: BigInt.from(0),
      nombre: nombre,
      dosis: dosis,
      unidad: unidad,
      frecuencia: frecuencia,
      lapso: lapso,
      descripcion: "${descripcion}, tratamiento: ${frecuencia} al ${timeFrequency.name} durante ${lapso} ${timeLapse.name}",
      tipo: tipo.toString(),
      idCreador: idCreator
    );
  }

}