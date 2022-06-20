import 'package:medical_recipe_viewer/data/recipe.dart';
import 'package:medical_recipe_viewer/page_view/page_view.dart';
import 'package:medical_recipe_viewer/recipe_list/recipe_list_view.dart';

class MockListProvider extends ProviderHelper {

  @override
  void getData() {
    this.value = RecipeListView([
      Recipe(id: "1", name: "Recipe 1",dosis: "500 mg",frecuencia:"cada 8h",lapso: "7 dias",descripcion: "antibiotico"),
      Recipe(id: "2", name: "Recipe 2",dosis: "50 mg",frecuencia:"cada 4h",lapso: "3 dias",descripcion: "relajante"),
      Recipe(id: "3", name: "Recipe 3",dosis: "5 mg",frecuencia:"cada 12h",lapso: "15 dias",descripcion: "antidrepesivo")
    ]);
  }

}