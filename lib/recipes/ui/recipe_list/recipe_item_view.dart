import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_detail/send_dialog.dart';
import 'package:medical_recipe_viewer/recipes/state/code_state.dart';
import 'package:medical_recipe_viewer/utils/calculations.dart';
import 'package:medical_recipe_viewer/utils/navigation_actions.dart';
import 'package:medical_recipe_viewer/values/app_colors.dart';
import 'package:provider/provider.dart';

class RecipeItemView extends StatelessWidget implements SendActionListener{

  Recipe recipeItem;

  late CodeState _provider;

  RecipeItemView(this.recipeItem);

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<CodeState>(context);
    return Container(
        margin: EdgeInsets.only(
            bottom: 3.0,
            left: 2.0,
            right: 2.0
        ),
        child: Material(
            elevation: 5,
            child:ExpansionTile(
              title: Text(
                recipeItem.nombre!,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: tableColors['tColorContent']
                ),
              ) ,
              subtitle: Text(
                "Necesita ${getTotalDosis(recipeItem)} de ${recipeItem.dosis!} ${recipeItem.unidad!}",
                style: TextStyle(
                    color: tableColors['tColorContent']
                ),
              ),
              children: <Widget>[
                ListTile(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: (){
                              showQRDialog(context,recipeItem.toJson());
                            },
                            child:Container(
                                margin: EdgeInsets.only(
                                      left: 8.0,
                                      right: 4.0
                                  ),
                                  child:Expanded(
                                    flex: 1,
                                    child: const Icon(Icons.qr_code)
                                ),
                            )
                          ),
                          InkWell(
                            onTap: (){
                              showSendDialog(
                                  context,
                                  _provider,
                                  this
                              );
                            },
                            child:Container(
                                margin: EdgeInsets.only(
                                      left: 8.0,
                                      right: 4.0
                                  ),
                                  child:Expanded(
                                    flex: 1,
                                    child: const Icon(Icons.send)
                                ),
                            )
                          ),
                          InkWell(
                            onTap: (){
                              goToRecipeDetail(context, recipeItem,_provider);
                            },
                            child:Container(
                                margin: EdgeInsets.only(
                                    left: 4.0,
                                    right: 8.0
                                ),
                                child:Expanded(
                                  flex: 1,
                                  child: const Icon(Icons.read_more)
                              ),
                            )
                          ),
                        ],
                    )
                ),
              ],
            )
        )
    );
  }

  @override
  void sendRecipe() {
  }

}