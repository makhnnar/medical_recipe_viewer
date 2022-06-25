import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/data/recipe.dart';
import 'package:medical_recipe_viewer/recipe_detail/send_dialog.dart';
import 'package:medical_recipe_viewer/values/app_colors.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class RecipeDetailView extends StatelessWidget {

  Recipe recipeItem;

  RecipeDetailView(this.recipeItem);

  @override
  Widget build(BuildContext context) {
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
                      "${recipeItem.name}",
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
                  ],
                )
            ),
            Expanded(
              flex: 3,
              child: PrettyQr(
                size: 150,
                data: recipeItem.toString(),
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
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                        return SendDialog();
                    }
                );
              },
              child: Icon(Icons.search),
            )
        )
    );
  }

}