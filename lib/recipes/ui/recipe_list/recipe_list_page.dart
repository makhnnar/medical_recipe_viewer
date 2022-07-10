import 'package:flutter/cupertino.dart';
import 'package:medical_recipe_viewer/page_view/page_view.dart';
import 'package:medical_recipe_viewer/recipes/state/recipes_state.dart';

class RecipeListPage extends StatelessWidget with PageViewHelper<RecipesState>{

  @override
  Widget build(BuildContext context) {
    return this.getView(context);
  }

}