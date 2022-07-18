
import 'package:flutter/cupertino.dart';
import 'package:medical_recipe_viewer/values/contanst.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataSourceRepository{

  SharedPreferences? prefs;

  DataSourceRepository() {
    init();
  }

  Future<void> init() async {
    if(prefs==null){
      prefs = await SharedPreferences.getInstance();
    }
  }

  String getWalletAdr(){
    init();
    print("prefs is null? ${prefs==null}");
    return prefs?.getString(PrefKeys.WALLET_ADR.name) ?? "";
  }

  void setWalletAdr(String walletAdr) {
    init();
    prefs!.setString(PrefKeys.WALLET_ADR.name, walletAdr);
  }

}