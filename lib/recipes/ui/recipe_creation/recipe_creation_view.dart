import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/recipes/state/recipes_state.dart';
import 'package:medical_recipe_viewer/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class RecipeCreationView extends StatelessWidget {

  late RecipesState _state;

  late String _nombre;
  late String _dosis;
  late String _unidad;
  late String _frecuencia;
  late String _lapso;
  late String _descripcion;
  late String _tipo;

  RecipeCreationView();

  @override
  Widget build(BuildContext context) {
    _state = Provider.of<RecipesState>(context);
    return Scaffold(
        body: ListView(
        children: [
          CustomTextField(
            "medicamento",
            (text){
              print('$text');
              _nombre = text;
            }
          ),
          CustomTextField(
            "dosis",
            (text){
              print('$text');
              _dosis = text;
            }
          ),
          CustomTextField(
            "unidad",
            (text){
              print('$text');
              _unidad = text;
            }
          ),
          CustomTextField(
            "frecuencia",
            (text){
              print('$text');
              _frecuencia = text;
            }
          ),
          CustomTextField(
            "lapso",
            (text){
              print('$text');
              _lapso = text;
            }
          ),
          CustomTextField(
            "descripcion",
            (text){
              print('$text');
              _descripcion = text;
            }
          ),
          CustomTextField(
            "tipo",
            (text){
              print('$text');
              _tipo = text;
            }
          ),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16
              ),
              child:ElevatedButton(
                  onPressed: ()=>{
                    _state.createRecipe(
                      _nombre,
                      _dosis,
                      _unidad,
                      _frecuencia,
                      _lapso,
                      _descripcion,
                      int.parse(_tipo),
                      "idCreator"
                    )
                  },
                  child: Text("Crear")
              )
          )
        ]
      )
    );
  }

}