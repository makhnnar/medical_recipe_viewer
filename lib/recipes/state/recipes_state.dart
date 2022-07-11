import 'package:flutter/cupertino.dart';
import 'package:medical_recipe_viewer/blockchain/contract_resolver.dart';
import 'package:medical_recipe_viewer/blockchain/wallet_conector.dart';
import 'package:medical_recipe_viewer/blockchain/web3_cliente_provider.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:medical_recipe_viewer/page_view/page_view.dart';
import 'package:medical_recipe_viewer/recipes/repository/recipes_repository.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_creation/recipe_creation_view.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_list/recipe_list_view.dart';

class RecipesState extends ProviderHelper {

  late RecipesRepository repository;

  RecipesState(){
    this.value = Container();
    _init();
  }

  void _init(){
    var client = Web3ClientProviderImpl();
    repository =  RecipesRepository(
        client,
        WalletConectorImpl(
            client,
            "5f5761ec0e6ae960332bccd71312e2b15a710f2b1b4530c3276435fde245f417"
        ),
        ContracResolverImpl(
            "src/abis/Recipes.json",
            "Recipes"
        )
    );
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