import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:medical_recipe_viewer/page_view/page_view.dart';
import 'package:medical_recipe_viewer/recipes/repository/recipes_repository.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_list/recipe_list_view.dart';
import 'package:medical_recipe_viewer/values/contanst.dart';

import '../../blockchain/contract_resolver.dart';
import '../../repository/data_source_repository.dart';
import '../../utils/forms.dart';

class RecipesState extends ProviderHelper {

  RecipesRepository repository;

  CollectionReference documentos = FirebaseFirestore.instance.collection('documentos');
  DataSourceRepository dataSourceRepository = DataSourceRepository();

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
        recipeList: RecipeList(
            listOfRecipes:recipeList
        )
    );
    notifyListeners();
  }

  Future<bool> createRecipe(
      Recipe recipe,
      int gasLimit,
      ContracResolverImpl profileContract
  ) async {
    var contract = await profileContract.getDeployedContract();
    var response = await repository.createRecipe(
        recipe,
        gasLimit,
        contract.address
    );
    print("createRecipe result: $response");
    if(response==ContractResponse.SUCCESS){
      showToast("Su recipe ha sido creado");
      getData();
      return true;
    }
    showToast("Ocurrio un problema creando su recipe. Intente mas tarde");
    return false;
  }

  Future<void> sendRecipeToAddress(
      String addressReceiver,
      BigInt id
  ) async {
    print("sendRecipeToAddress id $id addressReceiver $addressReceiver ");
    var response = await repository.sendRecipeToAddress(
        addressReceiver,
        id
    );
    print("sendRecipeToAddress result: $response");
    if(response==ContractResponse.SUCCESS){
      showToast("Su recipe ha sido enviado.");
      getData();
      return;
    }
    showToast("Ocurrio un error al enviar su recipe. Intente mas tarde");
  }

  Future<void> burnRecipe(
      BigInt id
  ) async {
    print("burnRecipe id $id");
    var response = await repository.burnRecipe(
        id
    );
    print("burnRecipe result: $response");
    if(response==ContractResponse.SUCCESS){
      showToast("Su recipe ha sido eliminado.");
      getData();
      return;
    }
    showToast("Ocurrio un error al eliminar su recipe. Intente mas tarde");
  }

  Future<int> getProfileType() async {
    String id = dataSourceRepository.getDocumentId();
    DocumentSnapshot snapshot = await documentos.doc(id).get();
    return int.parse(snapshot['tipo']);
  }

}