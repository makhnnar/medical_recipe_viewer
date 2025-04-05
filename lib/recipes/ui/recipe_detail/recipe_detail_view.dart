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

import '../../../profile/model/profile.dart';
import '../../../profile/repository/profile_id_repository.dart';
import '../../../profile/ui/profile_view.dart';

class RecipeDetailView extends StatelessWidget implements SendActionListener{

  Recipe recipeItem;

  bool allowShareAndSend;

  late CodeState _provider;
  late RecipesState? _recipeState;
  late ProfileIdRepository _profileIdRepository;

  RecipeDetailView({
    required this.recipeItem,
    this.allowShareAndSend = true
  });

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<CodeState>(context);
    _recipeState = Provider.of<RecipesState?>(context);
    _profileIdRepository = Provider.of<ProfileIdRepository>(context);
    return Scaffold(
        body: ListView(
            children: [
              buildExpansionTile(
              "Detalle del Recipe",
                [
                  printRecipeDetail(context, recipeItem),
                ]
              ),
              buildExpansionTile(
                  "Medico que receta",
                  [
                    AsyncProfileCardLoader(
                        fetchProfile: () => _profileIdRepository.checkIfIdProfileExists(recipeItem.idCreador??"")
                    ),
                  ]
              ),
              Expanded(
                flex: 3,
                child: Column(
                    children:[
                      Text(
                        "Lee este QR para compartir el recipe",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue
                        ),
                      ),
                      PrettyQr(
                        size: 150,
                        data: jsonEncode(recipeItem.toJson()),
                        errorCorrectLevel: QrErrorCorrectLevel.M,
                        typeNumber: null,
                        roundEdges: true,
                      ),
                  ]
                )
              ),
            ],
          ),
        floatingActionButton: getFloatingButton(context, allowShareAndSend)
    );
  }

  Widget? getFloatingButton(BuildContext context, bool allowShareAndSend){
    if(allowShareAndSend){
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            heroTag: "btn3",
            onPressed: () {
              showSendDialog(
                  context,
                  _provider,
                  this
              );
            },
            child: Icon(Icons.send),
          )
      );
    }
    return null;
  }

  @override
  void sendRecipe() {
    _recipeState?.sendRecipeToAddress(
        _provider.getCode(),
        recipeItem.id!
    );
  }

  Widget buildExpansionTile(
      String title,
      List<Widget> childList,
  ) {
    return ExpansionTile(
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: tableColors['tColorContent']
          ),
        ) ,
        initiallyExpanded: true,
        children: childList
    );
  }

  Widget printRecipeDetail(BuildContext context, Recipe recipe){
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Nombre', '${recipe.nombre}'),
            _buildRow('Dosis', '${recipe.dosis} ${recipe.unidad}'),
            _buildRow('Frecuencia', '${recipe.frecuencia}'),
            _buildRow('Lapso', '${recipe.lapso}'),
            _buildRow('Descripción', '${recipe.descripcion}'),
            _buildRow('Tipo', '${recipe.tipo}'),
          ],
        ),
      ),
    );
  }

}

class AsyncProfileCardLoader extends StatelessWidget {

  final Future<Profile> Function() fetchProfile;

  const AsyncProfileCardLoader({Key? key, required this.fetchProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
      future: fetchProfile(),
      builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading profile: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return printDoctorProfile(context, snapshot.data!);
        } else {
          return Center(child: Text('No profile data available.'));
        }
      },
    );
  }

  Widget printDoctorProfile(BuildContext context, Profile profile){
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOpenRow(
              'Photo',
              CilcularImage(profile: profile)
            ),
            _buildRow('Name', profile.name),
            _buildRow('Type', '${profile.tipo}'),
            _buildRow('Wallet Address', profile.dir),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

Widget _buildRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$title:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          flex: 3,
          child: Text(value),
        ),
      ],
    ),
  );
}

Widget _buildOpenRow(String title, Widget value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$title:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          flex: 3,
          child: value,
        ),
      ],
    ),
  );
}