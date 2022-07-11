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
      body: ListView(
          children: getList(recipeList.listOfRecipes!)
      ),
      floatingActionButton:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                heroTag: "btn1",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider<RecipesState>.value(
                              value: _recipesState
                            ),
                            ChangeNotifierProvider(
                                create: (_) => RecipesCreationFieldState()
                            ),
                          ],
                          child: RecipeCreationView(),
                      )
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
              FloatingActionButton(
                heroTag: "btn2",
                onPressed: () {
                  scanQR().then(
                        (value) {
                            Map<String, dynamic> jsonData = jsonDecode(value);
                            var formattedResponse = Recipe.fromJson(jsonData);
                            goToRecipeDetail(
                                context,
                                formattedResponse,
                                _provider,
                                null
                            );
                        }
                  );
                },
                child: Icon(Icons.search),
              ),
              FloatingActionButton(
                heroTag: "btn3",
                onPressed: () {
                    showQRDialog(context, recipeList.toJson());
                },
                child: Icon(Icons.share),
              )
            ],
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