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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body:Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        onPressed: () {
                          _stateCreationFields.setLoading(true);
                          _profileCreationState.checkIfIdProfileExists(
                              _stateCreationFields.numeroIdentidad,
                                  (){
                                _profileCreationState.savePrivateKey(_profileCreationState.getProfilePrivateKey());
                                _profileCreationState.getOrCreateProfile(
                                    5,
                                    ()=>{
                                      Navigator.of(context).pushReplacementNamed('/root')
                                    },
                                    (){
                                      _stateCreationFields.setLoading(false);
                                    }
                                );
                              }
                          );
                        },
                        child: Text("verificar identidad")
                    )
                ),
                if(_profileCreationState.showAlert)
                  BadDataAlert(profileCreationState: _profileCreationState)
              ],
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

}

class BadDataAlert extends StatelessWidget {
  const BadDataAlert({
    Key? key,
    required ProfileCreationState profileCreationState,
  }) : _profileCreationState = profileCreationState, super(key: key);

  final ProfileCreationState _profileCreationState;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){

        },
        child:Container(
          height: 60,
          color: Colors.black26,
          margin: EdgeInsets.only(
              left: 8.0,
              right: 8.0
          ),
          child:Expanded(
              flex: 1,
              child: Center(
                child: Text(
                    _profileCreationState.alertMsg,
                    textAlign: TextAlign.center,
                ),
              )
          ),
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
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                              _stateCreationFields.setLoading(true);
                              _profileCreationState.savePrivateKey(_profileCreationState.getProfilePrivateKey());
                              _profileCreationState.getOrCreateProfile(
                                  5,
                                      ()=>{
                                    Navigator.of(context).pushReplacementNamed('/root')
                                  },
                                      (){
                                    _stateCreationFields.setLoading(false);
                                  }
                              );
                            },
                            child: Text("Crear Usuario")
                        )
                    ),
                    if(_profileCreationState.showAlert)
                      BadDataAlert(profileCreationState: _profileCreationState)
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
            ])
    );
  }

}