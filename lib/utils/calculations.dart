import 'package:medical_recipe_viewer/recipes/model/recipe.dart';

int getTotalDosis(Recipe recipe){
  try{
    final multiplier = getTimeUnitMultiplier(getTimeUnits(recipe.descripcion!));
    return int.parse(recipe.frecuencia!) * int.parse(recipe.lapso!) * multiplier;
  }catch(e){
    print("error: $e");
    return 0;
  }
}

List<String> getTimeUnits(String desciption){
  List<String> _capitalizedWords = [];
  final text = desciption.split("tratamiento:")[1];
  final words = text.split(RegExp(r'\s+')); // Split by any whitespace
  for (final word in words) {
    if (word.isNotEmpty && word == word.toUpperCase()) {
      _capitalizedWords.add(word);
    }
  }
  return _capitalizedWords;
}

int getTimeUnitMultiplier(List<String> timeUnits){
  if(timeUnits[0] == "DIA" && timeUnits[1] == "SEMANA"){
    return 7;
  }
  //case dia and month
  if(timeUnits[0] == "DIA" && timeUnits[1] == "MES"){
    return 30;
  }
  // case for semana and month
  if(timeUnits[0] == "SEMANA" && timeUnits[1] == "MES"){
    return 4;
  }
  return 1;
}