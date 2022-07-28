import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:medical_recipe_viewer/recipes/state/recipes_state.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_detail/recipe_detail_view.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_detail/send_dialog.dart';
import 'package:medical_recipe_viewer/recipes/state/code_state.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_list/qr_viewer_dialog.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void goToListDetail(
    BuildContext context,
    Recipe data,
    CodeState codeState,
    RecipesState? recipesState,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>MultiProvider(
        providers: [
          ChangeNotifierProvider<CodeState>.value(value: codeState),
          ChangeNotifierProvider<RecipesState?>.value(value: recipesState)
        ],
        child:RecipeDetailView(data),
      ),
    )
  );
}

void goToRecipeDetail(
    BuildContext context,
    Recipe data,
    CodeState codeState,
    RecipesState? recipesState,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>MultiProvider(
        providers: [
          ChangeNotifierProvider<CodeState>.value(value: codeState),
          ChangeNotifierProvider<RecipesState?>.value(value: recipesState)
        ],
        child:RecipeDetailView(data),
      ),
    )
  );
}

void showSendDialog(
    BuildContext context,
    CodeState provider,
    SendActionListener listener
) {
  showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (_) => ChangeNotifierProvider<CodeState>.value(
      value: provider,
      child: SendDialog(
          listener
      ),
    ),
  );
}

void showQRDialog(
    BuildContext context,
    Map<String, dynamic> content
) {
  showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (_) => QRViewerDialog(
        jsonEncode(content)
    ),
  );
}