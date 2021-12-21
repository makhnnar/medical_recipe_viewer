import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/data/profile.dart';
import 'package:medical_recipe_viewer/data/recipe.dart';

class RecipeCreationView extends StatelessWidget {

  RecipeCreationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
        children: [
          TextField(),
          TextField(),
          TextField(),
          TextField(),
          TextField(),
          TextField(),
          TextField(),
          Row(
            children: [
              ElevatedButton(
                  onPressed: ()=>{

                  },
                  child: Text("")
              ),
              ElevatedButton(
                  onPressed: ()=>{

                  },
                  child: Text("")
              ),
            ],
          )
        ]
      )
    );
  }

}