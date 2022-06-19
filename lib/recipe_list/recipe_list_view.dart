import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/data/recipe.dart';
import 'package:medical_recipe_viewer/recipe_list/recipe_item_view.dart';

class RecipeListView extends StatelessWidget {

  List<Recipe> recipeList;

  RecipeListView(this.recipeList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          children: getList(recipeList)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.note_add_rounded),
      ),
    );
  }

  List<Widget> getList(List<Recipe> recipes) {
    List<Widget> list = [];
    for (Recipe recipe in recipes) {
      list.add(
          RecipeItemView(
              recipe
          )
      );
    }
    return list;
  }


}