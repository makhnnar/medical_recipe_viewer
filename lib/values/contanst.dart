
enum PrefKeys {
  WALLET_ADR,
  PROFILE_TYPE,
  PROFILE_ID,
  DOCUMENT_ID,
  IP_ADDRESS,
  WS_ADDRESS,
  CHAIN_ID,
  PROFILE_CONTRACT,
  RECIPE_CONTRACT,
  PROFILE_ABI,
  RECIPE_ABI,
}


//it is 1337 for ganache on Ethereum network and 97 for BSC testnet
final int CHAIN_ID = 97;

final String PROFILES_CONTRACT = "0x90426b8Ed46b5Fff329f68a392E58316dBE3a5f2";
final String RECIPES_CONTRACT = "0x0093De75d19A19032473c4749C32e179B2102efe";

final String PROFILES_ABI = "src/abis/Profiles.json";
final String RECIPES_ABI = "src/abis/Recipes.json";

int OP_DELAY = 10;

class RegularExpressions{

  RegularExpressions._();

  static const String texto = "\w*";
  static const String numero = "([0-9])+";
  static const String unidad = "(gr|mg|ug|ng|ml|oz)";
  static const String privAddr = "([0x]|[a-f]|[A-F]|[0-9]){40,70}";
  static const String numeroIdentidad = "([a-f|0-9]){6}";
  static const String json1 = "([\{](.|\n).*[\}])";
  //[\{]("|\w+|\s*|:|\n|,|\[|\]|\{|\})+[\}]
  static const String json2 = "[\{](\"|\w+|\s.*|:|\n|,|\[|\]|\{|\})+[\}]";

}

//todo: usar este objeto para retornar valores de logs e
// informacion extra al usario
class TransactionResponse{

  final String status;
  final String msg;

  TransactionResponse(
      this.status,
      this.msg
  );

}

class ContractResponse{

  ContractResponse._();

  static const String SUCCESS = "success";
  static const String FAILED = "failed";

}