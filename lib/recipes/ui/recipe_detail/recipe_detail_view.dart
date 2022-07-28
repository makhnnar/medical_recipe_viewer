import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:medical_recipe_viewer/recipes/state/recipes_state.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_detail/send_dialog.dart';
import 'package:medical_recipe_viewer/recipes/state/code_state.dart';
import 'package:medical_recipe_viewer/utils/navigation_actions.dart';
import 'package:medical_recipe_viewer/values/app_colors.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';

class RecipeDetailView extends StatelessWidget implements SendActionListener{

  Recipe recipeItem;

  late CodeState _provider;
  late RecipesState? _recipeState;

  RecipeDetailView(this.recipeItem);

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<CodeState>(context);
    //todo: agregar logica para detectar provider nulo y cambiar la ui
    _recipeState = Provider.of<RecipesState?>(context);
    return Scaffold(
        body: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
            ),
            Expanded(
                flex: 1,
                child:Container(
                    height: 50.0,
                    margin: EdgeInsets.only(
                        top: 15.0,
                        left: 2.0,
                        right: 2.0
                    ),
                    child:Text(
                      "${recipeItem.nombre}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: tableColors['tColorContent']
                      ),
                    )
                )
            ),
            Expanded(
                flex: 5,
                child:Column(
                  children: [
                    Container(
                        height: 50.0,
                        margin: EdgeInsets.only(
                            top: 15.0,
                            left: 2.0,
                            right: 2.0
                        ),
                        child:Text(
                          "dosis: ${recipeItem.dosis}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: tableColors['tColorContent']
                          ),
                        )
                    ),
                    Container(
                        height: 50.0,
                        margin: EdgeInsets.only(
                            top: 15.0,
                            left: 2.0,
                            right: 2.0
                        ),
                        child:Text(
                          "frecuencia: ${recipeItem.frecuencia}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: tableColors['tColorContent']
                          ),
                        )
                    ),
                    Container(
                        height: 50.0,
                        margin: EdgeInsets.only(
                            top: 15.0,
                            left: 2.0,
                            right: 2.0
                        ),
                        child:Text(
                          "durante: ${recipeItem.lapso}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: tableColors['tColorContent']
                          ),
                        )
                    ),
                    Text(
                      "Address to be sended: ${_provider.getCode()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue
                      ),
                    ),
                  ],
                )
            ),
            Expanded(
              flex: 3,
              child: PrettyQr(
                size: 150,
                data: jsonEncode(recipeItem.toJson()),
                errorCorrectLevel: QrErrorCorrectLevel.M,
                typeNumber: null,
                roundEdges: true,
              ),
            ),
          ],
        ),
        floatingActionButton:Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                  showSendDialog(
                      context,
                      _provider,
                      this
                  );
              },
              child: Icon(Icons.search),
            )
        )
    );
  }

  @override
  void sendRecipe() {
    _recipeState?.sendRecipeToAddress(
        _provider.getCode(),
        recipeItem.id!
    );
  }

}