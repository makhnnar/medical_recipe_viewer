import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_recipe_viewer/data/recipe.dart';
import 'package:medical_recipe_viewer/recipe_detail/recipe_detail_view.dart';

Widget createRecipeDetailViewScreen() =>
    MaterialApp(
        home: RecipeDetailView(
          Recipe(id: "id", name: "name", dosis: "dosis", frecuencia: "frecuencia", lapso: "lapso", descripcion: "descripcion")
        )
    );

void main() {
  group('detail recipe view test', () {

    // BEGINNING OF NEW CONTENT
    testWidgets(
        'Testing RecipeDetailView structure',
            (tester) async {
          await tester.pumpWidget(createRecipeDetailViewScreen());
          await tester.pumpAndSettle();
          expect(find.byType(Text), findsNWidgets(10));
          expect(find.byType(ElevatedButton), findsNWidgets(3));
        }
    );

  });
}

