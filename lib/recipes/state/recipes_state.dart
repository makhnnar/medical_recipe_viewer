import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical_recipe_viewer/di/module.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:medical_recipe_viewer/page_view/page_view.dart';
import 'package:medical_recipe_viewer/recipes/repository/recipes_repository.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_list/recipe_list_view.dart';
import 'package:medical_recipe_viewer/values/contanst.dart';

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

  //todo: cambiar a future
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
          (value) {
            print("createRecipe result: $value");
            //todo: agregar validacion del success
            Fluttertoast.showToast(
                msg: "Su recipe ha sido creado",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
            //todo: agregar proceso que muestre que ya se logro crear un recipe
          }
    ).onError(
          (error, stackTrace){
              print("createRecipe error: $error");
          }
    );
  }

  void sendRecipeToAddress(
      String addressReceiver,
      BigInt id
  ){
    print("sendRecipeToAddress id $id addressReceiver $addressReceiver ");
    repository.sendRecipeToAddress(
        addressReceiver,
        id
    ).then(
        (value) {
            print("sendRecipeToAddress result: $value");
            if(value==ContractResponse.SUCCESS){
              //todo: disparar actualizacion de lista de recipes
              Fluttertoast.showToast(
                  msg: "Su recipe ha sido enviado.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }else{
              Fluttertoast.showToast(
                  msg: "Ocurrio un error al enviar su recipe.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
        }
    ).onError(
        (error, stackTrace) {
          print("sendRecipeToAddress error: $error");
        }
    );
  }

}