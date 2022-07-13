import 'package:flutter/cupertino.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';

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

  String nombre = "";
  String dosis = "";
  String unidad = "";
  String frecuencia = "";
  String lapso = "";
  String descripcion = "";
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