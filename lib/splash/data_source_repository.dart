
import 'package:medical_recipe_viewer/values/contanst.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataSourceRepository{

  late SharedPreferences prefs;

  DataSourceRepository() {
    init();
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  String getWalletAdr() {
    return prefs.getString(PrefKeys.WALLET_ADR.name) ?? "";
  }

  void setWalletAdr(String walletAdr) {
    prefs.setString(PrefKeys.WALLET_ADR.name, walletAdr);
  }

}