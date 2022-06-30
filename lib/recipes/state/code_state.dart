import 'package:flutter/cupertino.dart';

class CodeState extends ChangeNotifier{

  String _code = "";

  void setCode(String code){
    this._code = code;
    notifyListeners();
  }

  String getCode(){
    return _code;
  }

}