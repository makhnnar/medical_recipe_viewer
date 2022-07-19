import 'package:flutter/cupertino.dart';
import 'package:medical_recipe_viewer/blockchain/wallet_conector.dart';
import 'package:medical_recipe_viewer/di/module.dart';
import 'package:medical_recipe_viewer/profile/model/profile.dart';
import 'package:medical_recipe_viewer/profile/repository/profile_id_repository.dart';
import 'package:medical_recipe_viewer/profile/ui/profile_creation_view.dart';
import 'package:medical_recipe_viewer/splash/data_source_repository.dart';

class ProfileCreationState extends ChangeNotifier {

  late DataSourceRepository dataSourceRepository;
  late WalletReposProvider walletReposProvider;
  late ProfileIdRepository profileIdRepository;
  Profile? _profile;

  Widget view = CheckProfileIdView();

  bool goToRoot = false;

  ProfileCreationState(
    DataSourceRepository dataSourceRepository,
    WalletReposProvider walletReposProvider,
    ProfileIdRepository profileIdRepository,
  ){
    this.dataSourceRepository = dataSourceRepository;
    this.walletReposProvider = walletReposProvider;
    this.profileIdRepository = profileIdRepository;
  }

  String getProfileName(){
    return _profile!.name;
  }

  void _connectWalletWithTheNewAddress(){
    walletReposProvider.walletConectorImpl = WalletConectorImpl(
        walletReposProvider.client,
        dataSourceRepository.getWalletAdr()
    );
  }

  void savePrivateKey(String privateKey){
    dataSourceRepository.setWalletAdr(privateKey);
  }

  void checkIfIdProfileExists(String id){
    _profile = profileIdRepository.checkIfIdProfileExists(id);
    if(!_profile!.isEmpty()){
      view = EnterWalletAddressView();
      notifyListeners();
    }
  }

  void createProfile(){
    if(!_profile!.isEmpty()) {
      _connectWalletWithTheNewAddress();
      walletReposProvider.getDeployedProfileRepository()!.createProfile(
          _profile!.id,
          _profile!.name,
          _profile!.tipo
      ).then((value) {
        print("createProfile result: $value");
        goToRoot = true;
      }).onError((error, stackTrace) {
        print("createProfile error: $error");
      });
    }
  }

}