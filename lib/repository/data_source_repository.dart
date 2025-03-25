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
    return prefs?.getString(PrefKeys.WALLET_ADR.name) ?? "";
  }

  void setWalletAdr(String walletAdr) {
    init();
    prefs!.setString(PrefKeys.WALLET_ADR.name, walletAdr);
  }

  int getProfileType(){
    init();
    return prefs?.getInt(PrefKeys.PROFILE_TYPE.name) ?? -1;
  }

  void setProfileType(int profileType) {
    init();
    prefs!.setInt(PrefKeys.PROFILE_TYPE.name, profileType);
  }

  String getProfileId(){
    init();
    return prefs?.getString(PrefKeys.PROFILE_ID.name) ?? "";
  }

  void setProfileId(String profileType) {
    init();
    prefs!.setString(PrefKeys.PROFILE_ID.name, profileType);
  }

  //create set and get methods for the profile id
  String getDocumentId(){
    init();
    return prefs?.getString(PrefKeys.DOCUMENT_ID.name) ?? "";
  }

  void setDocumentId(String documentId) {
    init();
    prefs!.setString(PrefKeys.DOCUMENT_ID.name, documentId);
  }

}