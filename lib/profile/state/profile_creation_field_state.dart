import 'package:flutter/cupertino.dart';

import '../../utils/data_validations.dart';
import '../../values/contanst.dart';

class ProfileCreationFieldState extends ChangeNotifier{

  String foto = "";

  String _privAddr = "";
  set privAddr(String value){
    if(validateValueWithRexExpression(value, RegularExpressions.privAddr)){
      _privAddr = value;
    }
  }
  String get privAddr => _privAddr;

  String _numeroIdentidad = "";
  set numeroIdentidad(String value){
    if(validateValueWithRexExpression(value, RegularExpressions.numeroIdentidad)){
      _numeroIdentidad = value;
    }
  }
  String get numeroIdentidad => _numeroIdentidad;

  bool isLoading = false;

  void setLoading(bool value){
    isLoading = value;
    notifyListeners();
  }

}