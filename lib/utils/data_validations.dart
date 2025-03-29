
bool validateValueWithRexExpression(String value,String expression){
  String pattern = r"(^"+expression+"\$)";
  RegExp regExp = new RegExp(pattern);
  print("validateValue value:$value matches? ${regExp.hasMatch(value)}");
  return regExp.hasMatch(value);
}

bool isListOfRecipes(dynamic json){
  if (json['listOfRecipes'] != null) {
    return true;
  }
  return false;
}