
enum PrefKeys {
  WALLET_ADR,
  PROFILE_TYPE
}


class RegularExpressions{

  RegularExpressions._();

  static const String texto = "([a-zA-Z|0-9|\s])+";
  static const String numero = "([0-9])+";
  static const String unidad = "[gr|mg|ug|ng|ml|oz]";
  static const String privAddr = "([0x]|[a-f]|[A-F]|[0-9]){40,70}";
  static const String numeroIdentidad = "([a-f|0-9]){6}";
  static const String json1 = "[\{](.|\n)*[\}]";
  //[\{]("|\w+|\s*|:|\n|,|\[|\]|\{|\})+[\}]
  static const String json2 = "[\{](\"|\w+|\s*|:|\n|,|\[|\]|\{|\})+[\}]";

}