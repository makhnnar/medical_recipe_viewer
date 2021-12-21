import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_recipe_viewer/recipe_creation/recipe_creation_view.dart';

Widget createRecipeCreationViewScreen() =>
    MaterialApp(
        home: RecipeCreationView()
    );

void main() {
  group('creation recipe view test', () {

    // BEGINNING OF NEW CONTENT
    testWidgets(
        'Testing ProfileView structure',
            (tester) async {
          await tester.pumpWidget(createRecipeCreationViewScreen());
          await tester.pumpAndSettle();
          expect(find.byType(TextField), findsNWidgets(7));
          expect(find.byType(ElevatedButton), findsNWidgets(2));
        }
    );

  });
}

