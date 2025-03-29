import 'package:flutter/cupertino.dart';

import '../../utils/data_validations.dart';
import '../../values/contanst.dart';

class CodeState extends ChangeNotifier{

  String _code = "";

  void setCode(String value){
    if(validateValueWithRexExpression(value, RegularExpressions.privAddr)){
      this._code = value;
    }else{
      this._code = "";
    }
    notifyListeners();
  }

  String getCode(){
    return _code;
  }

}