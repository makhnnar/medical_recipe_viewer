import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_detail/send_dialog.dart';
import 'package:medical_recipe_viewer/recipes/state/code_state.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_list/burn_dialog.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_list/qr_viewer_dialog.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void goToPage(
    BuildContext context,
    Widget page,
    List<SingleChildWidget> providers
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>MultiProvider(
        providers: providers,
        child:page,
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

void showBurnDialog(
    BuildContext context,
    dynamic acceptCallback
) {
  showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (_) => BurnDialog(
        acceptCallback
    ),
  );
}