import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:medical_recipe_viewer/recipes/state/recipes_creation_field_state.dart';
import 'package:medical_recipe_viewer/recipes/state/recipes_state.dart';
import 'package:medical_recipe_viewer/repository/data_source_repository.dart';
import 'package:medical_recipe_viewer/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../../blockchain/contract_resolver.dart';

class RecipeCreationView extends StatelessWidget {

  late RecipesState _state;
  late RecipesCreationFieldState _stateCreationFields;
  late DataSourceRepository _dataSourceRepository;

  RecipeCreationView();

  @override
  Widget build(BuildContext context) {
    _state = Provider.of<RecipesState>(context);
    _stateCreationFields = Provider.of<RecipesCreationFieldState>(context);
    _dataSourceRepository =  Provider.of<DataSourceRepository>(context,listen: false);
    return Scaffold(
        body:Stack(
            children: [
              ListView(
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
                        buildExpanded(
                            DropdownButtonWidget<UnitType>(
                                value: _stateCreationFields.unitType,
                                onChanged: (UnitType? newValue) {
                                  _stateCreationFields.setOptionsToChoose(newValue!);
                                },
                                items: buildItemList<UnitType>(
                                    UnitType.values,
                                        (UnitType value) => value.name
                                )
                            )
                        ),
                        buildExpanded(
                            DropdownButtonWidget<UnitOption>(
                                value: _stateCreationFields.unitOption,
                                onChanged: (UnitOption? newValue) {
                                  print("newValue: $newValue");
                                  _stateCreationFields.unidad = newValue!.name;
                                  _stateCreationFields.setUnitOption(newValue!);
                                },
                                items: buildItemList(
                                    _stateCreationFields.unidades[_stateCreationFields.unitType]??[],
                                        (UnitOption value) => value.name
                                )
                            )
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        buildExpanded(
                            CustomTextField(
                                "Cantidad de veces",
                                    (text){
                                  print('$text');
                                  _stateCreationFields.frecuencia = text;
                                },
                                typeOfKeyBoard: TextInputType.number,
                                initValue: _stateCreationFields.frecuencia
                            )
                        ),
                        buildExpanded(
                            DropdownButtonWidget<TimeUnit>(
                                value: _stateCreationFields.timeFrequency,
                                onChanged: (TimeUnit? newValue) {
                                  _stateCreationFields.setTimeFrequency(newValue!);
                                },
                                items: buildItemList(
                                    TimeUnit.values,
                                        (TimeUnit value) => value.name
                                )
                            )
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        buildExpanded(
                            CustomTextField(
                                "Durante",
                                    (text){
                                  print('$text');
                                  _stateCreationFields.lapso = text;
                                },
                                typeOfKeyBoard: TextInputType.number,
                                initValue: _stateCreationFields.lapso
                            )
                        ),
                        buildExpanded(
                            DropdownButtonWidget<TimeUnit>(
                                value: _stateCreationFields.timeLapse,
                                onChanged: (TimeUnit? newValue) {
                                  _stateCreationFields.setTimeLapse(newValue!);
                                },
                                items: buildItemList(
                                    TimeUnit.values,
                                        (TimeUnit value) => value.name
                                )
                            )
                        ),
                      ],
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
                        child:DropdownButtonWidget<RecipeType>(
                            value: _stateCreationFields.getRecipeType(),
                            onChanged: (RecipeType? newValue) {
                              _stateCreationFields.tipo = newValue!.index;
                              _stateCreationFields.setRecipeType(newValue);
                            },
                            items: buildItemList(
                                RecipeType.values,
                                    (RecipeType value) => value.name
                            )
                        )
                    ),
                    CustomTextField(
                      "GWei(Costo Transaccion)",
                          (text){
                        print('$text');
                        _stateCreationFields.gWei = text;
                      },
                      initValue: _stateCreationFields.gWei,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 16
                        ),
                        child:ElevatedButton(
                            onPressed: () => {
                              _stateCreationFields.setLoading(true),
                              _state.createRecipe(
                                  _stateCreationFields.createRecipe(
                                    _dataSourceRepository.getDocumentId()??"",
                                  ),
                                  int.tryParse(_stateCreationFields.gWei)??0,
                                  Provider.of<ContracResolverImpl>(context,listen: false)
                              ).then((value) {
                                if(value){
                                  _stateCreationFields.cleanFields();
                                }
                                _stateCreationFields.setLoading(false);
                              })
                            },
                            child: Text("Crear")
                        )
                    )
                  ]
              ),
              if (_stateCreationFields.isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.5), // Semi-transparent black background
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
            ]
        )
    );
  }

  List<DropdownMenuItem<T>> buildItemList<T>(
      List<T> dropValues,
      String Function(T) getText
  ) {
    return dropValues.map<DropdownMenuItem<T>>((T value) {
      return DropdownMenuItem<T>(
        value: value,
        child: Text(
          getText(value),
          textAlign: TextAlign.center,
        ),
      );
    }).toList();
  }

  Widget buildExpanded(
      Widget childItem,
  ) {
    return Expanded(
          flex: 1,
          child:Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16
              ),
              child:childItem
        )
    );
  }

}

class DropdownButtonWidget<T> extends StatelessWidget {

  final T value;
  final Function(T?) onChanged;
  final List<DropdownMenuItem<T>> items;

  const DropdownButtonWidget({
    required this.value,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      elevation: 16,
      style: const TextStyle(color: Colors.lightBlue),
      underline: Container(
        height: 2,
        color: Colors.lightBlueAccent,
      ),
      onChanged: onChanged,
      items: items,
    );
  }
}

