import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/data/recipe.dart';
import 'package:medical_recipe_viewer/recipe_detail/recipe_detail_view.dart';
import 'package:medical_recipe_viewer/recipe_detail/send_dialog.dart';
import 'package:medical_recipe_viewer/recipe_detail/state/code_state.dart';
import 'package:medical_recipe_viewer/recipe_list/qr_viewer_dialog.dart';
import 'package:provider/provider.dart';

void goToRecipeDetail(
    BuildContext context,
    Recipe data,
    CodeState provider
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider<CodeState>.value(
        value: provider,
        child: RecipeDetailView(data),
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