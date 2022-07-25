import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:medical_recipe_viewer/recipes/state/recipes_creation_field_state.dart';
import 'package:medical_recipe_viewer/recipes/state/recipes_state.dart';
import 'package:medical_recipe_viewer/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class RecipeCreationView extends StatelessWidget {

  late RecipesState _state;
  late RecipesCreationFieldState _stateCreationFields;

  RecipeCreationView();

  @override
  Widget build(BuildContext context) {
    _state = Provider.of<RecipesState>(context);
    _stateCreationFields = Provider.of<RecipesCreationFieldState>(context);
    return Scaffold(
        body: ListView(
        children: [
          CustomTextField(
            "medicamento",
            (text){
              print('$text');
              _stateCreationFields.nombre = text;
            },
            initValue: _stateCreationFields.nombre
          ),
          CustomTextField(
            "dosis",
            (text){
              print('$text');
              _stateCreationFields.dosis = text;
            },
            typeOfKeyBoard: TextInputType.number,
            initValue: _stateCreationFields.dosis
          ),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child:Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 16
                      ),
                      child:DropdownButton<UnitType>(
                      value: _stateCreationFields.unitType,
                      elevation: 16,
                      style: const TextStyle(color: Colors.lightBlue),
                      underline: Container(
                        height: 2,
                        color: Colors.lightBlueAccent,
                      ),
                      onChanged: (UnitType? newValue) {
                        _stateCreationFields.setOptionsToChoose(newValue!);
                      },
                      items: <UnitType>[ UnitType.MASA,UnitType.VOL ]
                          .map<DropdownMenuItem<UnitType>>((UnitType value) {
                        return DropdownMenuItem<UnitType>(
                          value: value,
                          child: Text(
                            value.name,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }).toList(),
                    )
                )
              ),
              Expanded(
                  flex: 1,
                  child:Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 16
                      ),
                      child:DropdownButton<UnitOption>(
                      value: _stateCreationFields.unitOption,
                      elevation: 16,
                      style: const TextStyle(color: Colors.lightBlue),
                      underline: Container(
                        height: 2,
                        color: Colors.lightBlueAccent,
                      ),
                      onChanged: (UnitOption? newValue) {
                        _stateCreationFields.unidad = newValue!.name;
                        _stateCreationFields.setUnitOption(newValue!);
                      },
                      items: _stateCreationFields.unitOptions
                          .map<DropdownMenuItem<UnitOption>>((UnitOption value) {
                        return DropdownMenuItem<UnitOption>(
                          value: value,
                          child: Text(
                            value.name,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }).toList(),
                    )
                )
              )
            ],
          ),
          CustomTextField(
            "frecuencia",
            (text){
              print('$text');
              _stateCreationFields.frecuencia = text;
            },
            typeOfKeyBoard: TextInputType.number,
            initValue: _stateCreationFields.frecuencia
          ),
          CustomTextField(
            "lapso",
            (text){
              print('$text');
              _stateCreationFields.lapso = text;
            },
            typeOfKeyBoard: TextInputType.number,
            initValue: _stateCreationFields.lapso
          ),
          CustomTextField(
            "descripcion",
            (text){
              print('$text');
              _stateCreationFields.descripcion = text;
            },
            initValue: _stateCreationFields.descripcion
          ),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16
              ),
              child:DropdownButton<RecipeType>(
                value: _stateCreationFields.getRecipeType(),
                elevation: 16,
                style: const TextStyle(color: Colors.lightBlue),
                underline: Container(
                  height: 2,
                  color: Colors.lightBlueAccent,
                ),
                onChanged: (RecipeType? newValue) {
                  _stateCreationFields.tipo = newValue!.index;
                  _stateCreationFields.setRecipeType(newValue);
                },
                items: <RecipeType>[ RecipeType.VERDE,RecipeType.AMARILLO,RecipeType.MORADO ]
                    .map<DropdownMenuItem<RecipeType>>((RecipeType value) {
                  return DropdownMenuItem<RecipeType>(
                    value: value,
                    child: Expanded(
                      flex: 1,
                      child:Text(
                          value.name,
                          textAlign: TextAlign.center,
                      )
                    ),
                  );
                }).toList(),
              )
          ),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16
              ),
              child:ElevatedButton(
                  onPressed: ()=>{
                    _state.createRecipe(
                        _stateCreationFields.nombre,
                        _stateCreationFields.dosis,
                        _stateCreationFields.unidad,
                        _stateCreationFields.frecuencia,
                        _stateCreationFields.lapso,
                        _stateCreationFields.descripcion,
                        _stateCreationFields.tipo,
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