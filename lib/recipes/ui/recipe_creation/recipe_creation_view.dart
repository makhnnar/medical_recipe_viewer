import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/widgets/custom_text_field.dart';

class RecipeCreationView extends StatelessWidget {

  RecipeCreationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
        children: [
          CustomTextField(
            "medicamento",
            (text){
              print('$text');
            }
          ),
          CustomTextField(
            "dosis",
            (text){
              print('$text');
            }
          ),
          CustomTextField(
            "frecuencia",
            (text){
              print('$text');
            }
          ),
          CustomTextField(
            "lapso",
            (text){
              print('$text');
            }
          ),
          CustomTextField(
            "descripcion",
            (text){
              print('$text');
            }
          ),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16
              ),
              child:ElevatedButton(
                  onPressed: ()=>{

                  },
                  child: Text("Crear")
              )
          )
        ]
      )
    );
  }

}