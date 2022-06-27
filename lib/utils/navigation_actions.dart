import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/data/recipe.dart';
import 'package:medical_recipe_viewer/recipe_detail/recipe_detail_view.dart';
import 'package:medical_recipe_viewer/recipe_detail/state/code_state.dart';
import 'package:provider/provider.dart';

void goToRecipeDetail(
    BuildContext context,
    Recipe data
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (_) => CodeState()
              ),
            ],
            child: RecipeDetailView(data),
          ),
    ),
  );
}