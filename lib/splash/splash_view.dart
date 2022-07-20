import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_recipe_viewer/di/module.dart';
import 'package:medical_recipe_viewer/splash/splash_state.dart';
import 'package:provider/provider.dart';

class SplashView  extends StatefulWidget {
  @override
  _SplashView  createState() => _SplashView ();
}

class _SplashView extends State<SplashView > {

  late SplashState splashState;
  late WalletReposProvider _walletReposProvider;

  Timer? _timer;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _timer = Timer(Duration(milliseconds: 7200), () {
      print("obteneindo el repositorio del perfil");
      splashState.checkIfProfileExist(
          _walletReposProvider.getDeployedProfileRepository(),
          (switchTo){
            if(switchTo==1){
              print("vamos a root");
              Navigator.of(context).pushReplacementNamed('/root');
            }
            if(switchTo==2){
              print("vamos a creacion");
              Navigator.of(context).pushReplacementNamed('/profileCreation');
            }
          }
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    splashState = Provider.of<SplashState>(context);
    _walletReposProvider = Provider.of<WalletReposProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Colors.white
          ),
          CircularProgressIndicator()
        ],
      )
    );
  }

}