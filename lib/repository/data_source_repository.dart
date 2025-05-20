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

  //create set and get methods for the IP_ADDRESS and WS_ADDRESS values
  String getIpAddress(){
    init();
    return prefs?.getString(PrefKeys.IP_ADDRESS.name) ?? "";
  }

  void setIpAddress(String ipAddress) {
    init();
    print("saving ipAddress: $ipAddress");
    prefs!.setString(PrefKeys.IP_ADDRESS.name, ipAddress);
  }

  String getWsAddress(){
    init();
    return prefs?.getString(PrefKeys.WS_ADDRESS.name) ?? "";
  }

  void setWsAddress(String wsAddress) {
    init();
    print("saving setWsAddress: $wsAddress");
    prefs!.setString(PrefKeys.WS_ADDRESS.name, wsAddress);
  }

  //create set and get methods for the chainId
  String getChainId(){
    init();
    return prefs?.getString(PrefKeys.CHAIN_ID.name) ?? "";
  }

  void setChainId(String chainId) {
    init();
    print("saving setWsAddress: $chainId");
    prefs!.setString(PrefKeys.CHAIN_ID.name, chainId);
  }

  //create the set and get for profile contract
  String getProfileContract(){
    init();
    return prefs?.getString(PrefKeys.PROFILE_CONTRACT.name) ?? "";
  }

  void setProfileContract(String profileContract) {
    init();
    print("saving setWsAddress: $profileContract");
    prefs!.setString(PrefKeys.PROFILE_CONTRACT.name, profileContract);
  }

  //create the set and get for recipe contract
  String getRecipeContract(){
    init();
    return prefs?.getString(PrefKeys.RECIPE_CONTRACT.name) ?? "";
  }

  void setRecipeContract(String recipeContract) {
    init();
    print("saving setWsAddress: $recipeContract");
    prefs!.setString(PrefKeys.RECIPE_CONTRACT.name, recipeContract);
  }

  //create the set and get for profile abi
  String getProfileAbi(){
    init();
    return prefs?.getString(PrefKeys.PROFILE_ABI.name) ?? "";
  }

  void setProfileAbi(String profileAbi) {
    init();
    print("saving setWsAddress: $profileAbi");
    prefs!.setString(PrefKeys.PROFILE_ABI.name, profileAbi);
  }

  //create the set and get for recipe abi
  String getRecipeAbi(){
    init();
    return prefs?.getString(PrefKeys.RECIPE_ABI.name) ?? "";
  }

  void setRecipeAbi(String recipeAbi) {
    init();
    print("saving setWsAddress: $recipeAbi");
    prefs!.setString(PrefKeys.RECIPE_ABI.name, recipeAbi);
  }

}