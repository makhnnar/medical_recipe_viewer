import 'package:medical_recipe_viewer/data/recipe.dart';
import 'package:medical_recipe_viewer/page_view/page_view.dart';
import 'package:medical_recipe_viewer/recipe_list/recipe_list_view.dart';

class MockProfileProvider extends ProviderHelper {

  @override
  void getData() {
    this.value = RecipeListView([
      Recipe(id: "1", name: "Recipe 1"),
      Recipe(id: "2", name: "Recipe 2"),
      Recipe(id: "3", name: "Recipe 3")
    ]);
  }

}