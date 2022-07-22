

bool validateValue(String value,String expression){
  String pattern = r"(^"+expression+"\$)";
  RegExp regExp = new RegExp(pattern);
  if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}