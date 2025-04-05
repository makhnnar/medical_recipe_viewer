import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:medical_recipe_viewer/recipes/state/recipes_state.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_detail/send_dialog.dart';
import 'package:medical_recipe_viewer/recipes/state/code_state.dart';
import 'package:medical_recipe_viewer/utils/calculations.dart';
import 'package:medical_recipe_viewer/utils/navigation_actions.dart';
import 'package:medical_recipe_viewer/values/app_colors.dart';
import 'package:provider/provider.dart';

import '../recipe_detail/recipe_detail_view.dart';

class RecipeItemView extends StatelessWidget implements SendActionListener{

  Recipe recipeItem;

  bool allowShareAndSend;

  late CodeState _provider;
  late RecipesState? _recipeState;

  RecipeItemView({
    required this.recipeItem,
    this.allowShareAndSend = true
  });

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<CodeState>(context);
    _recipeState = Provider.of<RecipesState?>(context);
    return Container(
        color: tableColors['bgValue'],
        margin: EdgeInsets.only(
            bottom: 3.0,
            left: 2.0,
            right: 2.0
        ),
        child: Material(
            elevation: 5,
            color: tableColors['bgValue'],
            child: displayRowOrExpansionTile(context)
        )
    );
  }

  Widget displayRowOrExpansionTile(BuildContext context){
    if(allowShareAndSend){
      return buildExpansionTile(context);
    }
    return buildClickableRow(context);
  }

  Widget buildClickableRow(BuildContext context) {
    return InkWell(
        onTap: (){
          navigateToRowDetail(context);
        },
        child: Container(
            margin: EdgeInsets.only(
                left: 4.0,
            ),
            height: 70.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipeItem.nombre!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: tableColors['tColorContent']
                    ),
                  ),
                  Text(
                    "Necesita ${getTotalDosis(recipeItem)} de ${recipeItem.dosis} ${recipeItem.unidad}",
                    style: TextStyle(
                        color: tableColors['tColorContent']
                    ),
                  ),
                ]
            )
        )
    );
  }

  Widget buildExpansionTile(BuildContext context) {
    return ExpansionTile(
        title: Text(
          recipeItem.nombre!,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: tableColors['tColorContent']
          ),
        ) ,
        subtitle: Text(
          "Necesita ${getTotalDosis(recipeItem)} de ${recipeItem.dosis} ${recipeItem.unidad}",
          style: TextStyle(
              color: tableColors['tColorContent']
          ),
        ),
        children: <Widget>[
          ListTile(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    getIconButton(
                        Icons.qr_code,
                        (){ showQRDialog(context,recipeItem.toJson()); }
                    ),
                    getIconButton(
                        Icons.send,
                        (){ showSendDialog(context, _provider, this); }
                    ),
                    getIconButton(
                        Icons.remove_red_eye,
                        (){ navigateToRowDetail(context); }
                    ),
                  ],
              )
          ),
        ],
    );
  }

  Widget getIconButton(IconData icon, Function() onPressed){
    return InkWell(
        onTap: onPressed,
        child:Container(
          margin: EdgeInsets.only(
              left: 8.0,
              right: 4.0
          ),
          child: Icon(icon),
        )
    );
  }


  void navigateToRowDetail(BuildContext context) {
    goToPage(
        context,
        RecipeDetailView(recipeItem:recipeItem, allowShareAndSend: allowShareAndSend),
        [
          ChangeNotifierProvider<CodeState>.value(value: _provider),
          ChangeNotifierProvider<RecipesState?>.value(value: _recipeState)
        ]
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