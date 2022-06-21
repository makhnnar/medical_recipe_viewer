import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/data/recipe.dart';
import 'package:medical_recipe_viewer/recipe_creation/recipe_creation_view.dart';
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
      floatingActionButton:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeCreationView(),
                    ),
                  );
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.add),
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.search),
              )
            ],
          )
      )
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