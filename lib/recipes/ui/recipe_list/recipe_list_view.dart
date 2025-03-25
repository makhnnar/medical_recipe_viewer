import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:medical_recipe_viewer/recipes/state/recipes_creation_field_state.dart';
import 'package:medical_recipe_viewer/recipes/state/recipes_state.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_creation/recipe_creation_view.dart';
import 'package:medical_recipe_viewer/recipes/state/code_state.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_list/recipe_item_view.dart';
import 'package:medical_recipe_viewer/utils/navigation_actions.dart';
import 'package:medical_recipe_viewer/utils/qr_reader.dart';
import 'package:provider/provider.dart';

class RecipeListView extends StatelessWidget {

  RecipeList recipeList;

  late CodeState _provider;
  late RecipesState _recipesState;

  RecipeListView(this.recipeList);

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<CodeState>(context);
    _recipesState = Provider.of<RecipesState>(context);
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            _recipesState.getData();
          },
          child:ListView(
            children: getList(recipeList.listOfRecipes!)
          ),
      ),
      floatingActionButton:Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            heroTag: "btn3",
            onPressed: () {
              showQRDialog(context, recipeList.toJson());
            },
            child: Icon(Icons.share),
          )
      )
    );
  }

  List<Widget> getList(List<Recipe> recipes) {
    List<Widget> list = [];
    if(recipes.isNotEmpty){
      for (Recipe recipe in recipes) {
        list.add(
            RecipeItemView(
                recipe
            )
        );
      }
      return list;
    }
    return [
      Container()
    ];
  }


}