import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/profile/state/profile_creation_field_state.dart';
import 'package:medical_recipe_viewer/profile/state/profile_creation_state.dart';
import 'package:medical_recipe_viewer/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class ProfileCreationView extends StatelessWidget {

  late ProfileCreationFieldState _stateCreationFields;
  late ProfileCreationState _profileCreationState;

  @override
  Widget build(BuildContext context) {
    _profileCreationState = Provider.of<ProfileCreationState>(context);
    _stateCreationFields = Provider.of<ProfileCreationFieldState>(context);
    return _profileCreationState.view;
  }

}


class CheckProfileIdView extends StatelessWidget {

  late ProfileCreationFieldState _stateCreationFields;
  late ProfileCreationState _profileCreationState;

  @override
  Widget build(BuildContext context) {
    _profileCreationState = Provider.of<ProfileCreationState>(context);
    _stateCreationFields = Provider.of<ProfileCreationFieldState>(context);
    return Scaffold(
        body: ListView(
            children: [
              CustomTextField(
                  "Numero de Identidad",
                      (text){
                    print('$text');
                    _stateCreationFields.numeroIdentidad = text;
                  }
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16
                  ),
                  child:ElevatedButton(
                      onPressed: ()=>{
                        _profileCreationState.checkIfIdProfileExists(
                          _stateCreationFields.numeroIdentidad
                        )
                      },
                      child: Text("verificar identidad")
                  )
              )
            ]
        )
    );
  }

}

class EnterWalletAddressView extends StatelessWidget {

  late ProfileCreationFieldState _stateCreationFields;
  late ProfileCreationState _profileCreationState;

  @override
  Widget build(BuildContext context) {
    _profileCreationState = Provider.of<ProfileCreationState>(context);
    _stateCreationFields = Provider.of<ProfileCreationFieldState>(context);
    if(_profileCreationState.goToRoot){
      Navigator.of(context).pushReplacementNamed('/root');
    }
    return Scaffold(
        body: ListView(
            children: [
              Text("Bienvenido ${_profileCreationState.getProfileName()}"),
              Text("Ingrese la llave privada de su wallet:"),
              CustomTextField(
                  "llave privada",
                      (text){
                    print('$text');
                    _stateCreationFields.privAddr = text;
                  }
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16
                  ),
                  child:ElevatedButton(
                      onPressed: (){
                        _profileCreationState.savePrivateKey(_stateCreationFields.privAddr);
                        _profileCreationState.createProfile();
                      },
                      child: Text("Crear Usuario")
                  )
              )
            ]
        )
    );
  }

}