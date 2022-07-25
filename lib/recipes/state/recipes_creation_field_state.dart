import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:medical_recipe_viewer/utils/forms.dart';

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

class RecipesCreationFieldState extends ChangeNotifier{

  RecipeType _type = RecipeType.VERDE;

  UnitType unitType = UnitType.MASA;
  UnitOption unitOption = UnitOption.gr;

  String _nombre = "";
  set nombre(String value){
    if(validateValue(value, RegularExpressions.texto)){
      _nombre = value;
    }
  }
  String get nombre => _nombre;

  String _dosis = "";
  set dosis(String value){
    print("value: value");
    if(validateValue(value, RegularExpressions.numero)){
      _dosis = value;
    }
  }
  String get dosis => _dosis;

  String _unidad = "";
  set unidad(String value){
    if(validateValue(value, RegularExpressions.unidad)){
      _unidad = value;
    }
  }
  String get unidad => _unidad;

  String _frecuencia = "";
  set frecuencia(String value){
    print("value: value");
    if(validateValue(value, RegularExpressions.numero)){
      _frecuencia = value;
    }
  }
  String get frecuencia => _frecuencia;

  String _lapso = "";
  set lapso(String value){
    print("value: value");
    if(validateValue(value, RegularExpressions.numero)){
      _lapso = value;
    }
  }
  String get lapso => _lapso;

  String _descripcion = "";
  set descripcion(String value){
    if(validateValue(value, RegularExpressions.texto)){
      _descripcion = value;
    }
  }
  String get descripcion => _descripcion;

  int tipo = 0;

  Map<UnitType,List<UnitOption>> _unidades = {
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

  List<UnitOption> unitOptions = [];

  RecipesCreationFieldState(){
    unitOptions = _unidades[UnitType.MASA]!;
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
    unitOptions = _unidades[type]!;
    unitOption = _unidades[type]![0];
    notifyListeners();
  }

  void setUnitOption(UnitOption newValue) {
    unitOption = newValue;
    notifyListeners();
  }

}