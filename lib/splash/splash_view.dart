

import 'package:flutter/cupertino.dart';
import 'package:medical_recipe_viewer/splash/splash_state.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashView createState() => _SplashView();
}

class _SplashView extends State<SplashView> {

  SplashState _state = SplashState(
      (msg)=>{
          print(msg)
      }
  );

  @override
  Widget build(BuildContext context) {
    return Container();
  }

}