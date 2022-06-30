import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:medical_recipe_viewer/page_view/page_view.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_list/recipe_list_view.dart';

class RecipesState extends ProviderHelper {

  @override
  void getData() {
    this.value = RecipeListView(
        RecipeList(
            listOfRecipes:[
              Recipe(id: "1", nombre: "Recipe 1",dosis: "500",unidad:"mg",frecuencia:"8",lapso: "7",descripcion: "antibiotico",tipo: "tipo 1"),
              Recipe(id: "2", nombre: "Recipe 2",dosis: "50",unidad:"mg",frecuencia:"4",lapso: "3",descripcion: "relajante",tipo: "tipo 2"),
              Recipe(id: "3", nombre: "Recipe 3",dosis: "5",unidad:"mg",frecuencia:"12",lapso: "15",descripcion: "antidrepesivo",tipo: "tipo 3")
            ]
        )
    );
  }

}