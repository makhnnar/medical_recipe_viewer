import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:medical_recipe_viewer/recipes/state/recipes_state.dart';
import 'package:medical_recipe_viewer/recipes/state/code_state.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_list/recipe_item_view.dart';
import 'package:medical_recipe_viewer/utils/navigation_actions.dart';
import 'package:provider/provider.dart';

class RecipeListView extends StatelessWidget {

  RecipeList recipeList;

  bool allowShareAndSend;

  late CodeState _provider;
  late RecipesState? _recipesState;

  RecipeListView({
    required this.recipeList,
    this.allowShareAndSend = true
  });

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<CodeState>(context);
    _recipesState = Provider.of<RecipesState?>(context);
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            _recipesState?.getData();
          },
          child:ListView(
            children: getList(recipeList.listOfRecipes!, allowShareAndSend)
          ),
      ),
      floatingActionButton: getFloatingButton(context, allowShareAndSend),
    );
  }

  //create a function that returns the floating button or null if the user is not allowed to share or send
  Widget? getFloatingButton(BuildContext context, bool allowShareAndSend){
    if(allowShareAndSend){
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            heroTag: "btn3",
            onPressed: () {
              showQRDialog(context, recipeList.toJson());
            },
            child: Icon(Icons.share),
          )
      );
    }
    return null;
  }

  List<Widget> getList(List<Recipe> recipes, bool canShareAndSend) {
    List<Widget> list = [];
    if(recipes.isNotEmpty){
      for (Recipe recipe in recipes) {
        list.add(
            RecipeItemView(
                recipeItem: recipe,
                allowShareAndSend: canShareAndSend,
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