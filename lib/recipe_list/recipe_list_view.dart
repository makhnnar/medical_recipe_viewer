import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/data/recipe.dart';
import 'package:medical_recipe_viewer/qr_reader/qr_reader.dart';
import 'package:medical_recipe_viewer/recipe_creation/recipe_creation_view.dart';
import 'package:medical_recipe_viewer/recipe_list/recipe_item_view.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:qrscan/qrscan.dart' as scanner;

class RecipeListView extends StatelessWidget {

  List<Recipe> recipeList;

  RecipeListView(this.recipeList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          children: getList(recipeList)
      ),
      floatingActionButton:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeCreationView(),
                    ),
                  );
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.add),
              ),
              FloatingActionButton(
                onPressed: () {
                  scan();
                },
                child: Icon(Icons.search),
              )
            ],
          )
      )
    );
  }

  Future scan() async {
    await Permission.camera.request();
    String? barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      print(barcode);
    }
  }

  List<Widget> getList(List<Recipe> recipes) {
    List<Widget> list = [];
    for (Recipe recipe in recipes) {
      list.add(
          RecipeItemView(
              recipe
          )
      );
    }
    return list;
  }


}