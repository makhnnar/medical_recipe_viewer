import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/data/recipe.dart';
import 'package:medical_recipe_viewer/recipe_detail/recipe_detail_view.dart';
import 'package:medical_recipe_viewer/recipe_detail/state/code_state.dart';
import 'package:medical_recipe_viewer/values/app_colors.dart';
import 'package:provider/provider.dart';

class RecipeItemView extends StatelessWidget {

  Recipe recipeItem;

  RecipeItemView(this.recipeItem);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
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
                    child: RecipeDetailView(recipeItem),
                  ),
            ),
          );
        },
        child:Container(
        height: 50.0,
        margin: EdgeInsets.only(
            bottom: 3.0,
            left: 2.0,
            right: 2.0
        ),
        child: Material(
            elevation: 5,
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                        recipeItem.id,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: tableColors['tColorContent']
                        ),
                    )
                ),
                Expanded(
                    flex: 4,
                    child: Text(
                        recipeItem.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: tableColors['tColorContent']
                        ),
                    )
                ),
                Expanded(
                    flex: 1,
                    child: Text(
                        "more",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: tableColors['tColorContent']
                        ),
                    )
                ),
              ],
            )
        )
      )
    );
  }

}