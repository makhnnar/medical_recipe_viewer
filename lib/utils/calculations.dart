import 'package:medical_recipe_viewer/recipes/model/recipe.dart';

int getTotalDosis(Recipe recipe){
  return (24/int.parse(recipe.frecuencia!)).toInt()*(int.parse(recipe.lapso!));
}
