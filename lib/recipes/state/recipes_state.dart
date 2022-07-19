import 'package:flutter/cupertino.dart';
import 'package:medical_recipe_viewer/di/module.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:medical_recipe_viewer/page_view/page_view.dart';
import 'package:medical_recipe_viewer/recipes/repository/recipes_repository.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_list/recipe_list_view.dart';

class RecipesState extends ProviderHelper {

  RecipesRepository repository;

  RecipesState(
      this.repository
  ){
    this.value = Container();
    getData();
  }

  @override
  void getData() {
    repository.getOwnedTokens()
      .then((recipeList) => onDataReceived(recipeList))
      .onError((error, stackTrace) => onDataReceived([]));
  }

  void onDataReceived(List<Recipe> recipeList){
    print("recipelist: ${recipeList.length}");
    this.value = RecipeListView(
        RecipeList(
            listOfRecipes:recipeList
        )
    );
    notifyListeners();
  }

  void createRecipe(
      String nombre,
      String dosis,
      String unidad,
      String frecuencia,
      String lapso,
      String descripcion,
      int tipo,
      String idCreator
  ){
    repository.createRecipe(
        nombre,
        dosis,
        unidad,
        frecuencia,
        lapso,
        descripcion,
        tipo,
        idCreator
    ).then(
          (value) => {
            print("createRecipe result: $value")
          }
    ).onError(
          (error, stackTrace) => {
              print("createRecipe error: $error")
          }
    );
  }

  void sendRecipeToAddress(
      String addressReceiver,
      BigInt id
  ){
    repository.sendRecipeToAddress(
        addressReceiver,
        id
    ).then(
        (value) => {
            print("sendRecipeToAddress result: $value")
        }
    ).onError(
        (error, stackTrace) => {
          print("sendRecipeToAddress error: $error")
        }
    );
  }

}