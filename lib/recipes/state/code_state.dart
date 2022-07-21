import 'package:flutter/cupertino.dart';

class CodeState extends ChangeNotifier{

  String _code = "";

  String jsonRegx = "[\{](.|\n)*[\}]";
  //[\{]("|\w+|\s*|:|\n|,|\[|\]|\{|\})+[\}]
  String jsonRegxComplete = "[\{](\"|\w+|\s*|:|\n|,|\[|\]|\{|\})+[\}]";

  void setCode(String code){
    this._code = code;
    notifyListeners();
  }

  String getCode(){
    return _code;
  }

}