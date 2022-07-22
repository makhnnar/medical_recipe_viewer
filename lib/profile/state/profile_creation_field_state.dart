import 'package:flutter/cupertino.dart';

import '../../utils/forms.dart';
import '../../values/contanst.dart';

class ProfileCreationFieldState extends ChangeNotifier{

  String foto = "";

  String _privAddr = "";
  set privAddr(String value){
    if(validateValue(value, RegularExpressions.privAddr)){
      _privAddr = value;
    }
  }
  String get privAddr => _privAddr;

  String _numeroIdentidad = "";
  set numeroIdentidad(String value){
    if(validateValue(value, RegularExpressions.numeroIdentidad)){
      _numeroIdentidad = value;
    }
  }
  String get numeroIdentidad => _numeroIdentidad;

}