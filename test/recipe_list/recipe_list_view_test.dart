import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:medical_recipe_viewer/recipe_list/recipe_list_view.dart';

List<Recipe> recipes = [];

Widget createRecipeListViewScreen() =>
    MaterialApp(
        home: RecipeListView(recipes)
    );

void pupolateList(){
  recipes.add(
      Recipe(
          id: "id",
          nombre:"name",
          dosis:"name",
          frecuencia:"name",
          lapso:"name",
          descripcion:"name",
      )
  );
}

void main() {
  group('recipes list view test', () {

    // BEGINNING OF NEW CONTENT
    testWidgets(
        'Testing ListView with 0 elements',
            (tester) async {
          await tester.pumpWidget(createRecipeListViewScreen());
          await tester.pumpAndSettle();
          expect(find.byType(ListView), findsOneWidget);
          expect(find.byType(FloatingActionButton), findsOneWidget);
        }
    );

    testWidgets(
        'Testing ListView with 1 element or more',
            (tester) async {
          pupolateList();
          await tester.pumpWidget(createRecipeListViewScreen());
          await tester.pumpAndSettle();
          expect(find.byType(Text), findsOneWidget);
        }
    );


  });
}

