
import 'package:flutter/cupertino.dart';
import 'package:medical_recipe_viewer/blockchain/contract_resolver.dart';
import 'package:medical_recipe_viewer/blockchain/wallet_conector.dart';
import 'package:medical_recipe_viewer/blockchain/web3_cliente_provider.dart';
import 'package:medical_recipe_viewer/profile/model/profile.dart';
import 'package:medical_recipe_viewer/profile/repository/profile_repository.dart';
import 'package:medical_recipe_viewer/splash/data_source_repository.dart';
import 'package:medical_recipe_viewer/values/contanst.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashState extends ChangeNotifier {

  var goToApp;

  late ProfileRepository _profileRepository;
  Web3ClientProviderImpl _client = Web3ClientProviderImpl();
  late WalletConectorImpl _walletConectorImpl;
  ContracResolverImpl _contracResolverImpl = ContracResolverImpl(
      "src/abis/Profiles.json",
      "Profiles"
  );
  DataSourceRepository dataSourceRepository = DataSourceRepository();

  SplashState(
    this.goToApp
  ){
    _loadWallet();
  }

  _loadWallet() async {
    String wallerAdr = dataSourceRepository.getWalletAdr();
    if(wallerAdr.isNotEmpty){
        Profile profile = await getDeployedProfile(wallerAdr);
        if(!profile.isEmpty()){
          goToApp("some value");
        }
    }else{
      goToApp("other value");
    }
  }

  Future<Profile> getDeployedProfile(String wallerAdr) async {
    _walletConectorImpl = WalletConectorImpl(
        _client,
        wallerAdr
    );
    _profileRepository = ProfileRepository(
        _client,
        _walletConectorImpl,
        _contracResolverImpl
    );
    var profile = await _profileRepository.getOwnedProfile();
    return profile;
  }

}