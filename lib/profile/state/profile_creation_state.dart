import 'package:flutter/cupertino.dart';
import 'package:medical_recipe_viewer/blockchain/wallet_conector.dart';
import 'package:medical_recipe_viewer/di/module.dart';
import 'package:medical_recipe_viewer/profile/model/profile.dart';
import 'package:medical_recipe_viewer/profile/repository/profile_id_repository.dart';
import 'package:medical_recipe_viewer/profile/ui/profile_creation_view.dart';
import 'package:medical_recipe_viewer/repository/data_source_repository.dart';

class ProfileCreationState extends ChangeNotifier {

  late DataSourceRepository dataSourceRepository;
  late WalletReposProvider walletReposProvider;
  late ProfileIdRepository profileIdRepository;
  Profile? _profile;

  Widget view = CheckProfileIdView();

  bool goToRoot = false;

  bool showAlert = false;

  String alertMsg  = "";

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
    print("privateKey: $privateKey");
    dataSourceRepository.setWalletAdr(privateKey);
  }

  void checkIfIdProfileExists(String id) async{
    _profile = await profileIdRepository.checkIfIdProfileExists(id);
    print("profile from firebase: ${_profile.toString()}");
    if(!_profile!.isEmpty()){
      showAlert = false;
      alertMsg = "";
      view = EnterWalletAddressView();
    }else{
      showAlert = true;
      alertMsg = "Documento de identidad no valido";
    }
    notifyListeners();
  }

  void createProfile(){
    if(!_profile!.isEmpty()) {
      _connectWalletWithTheNewAddress();
      walletReposProvider.getDeployedProfileRepository()!.getOwnedProfile()
          .then((value){
              print("getOwnedProfile result: $value");
              if(value.isEmpty()){
                walletReposProvider.getDeployedProfileRepository()!.createProfile(
                    _profile!.id,
                    _profile!.name,
                    _profile!.tipo
                ).then((value) {
                  print("createProfile result: $value");
                  if(value=="success"){
                    dataSourceRepository.setProfileType(_profile!.tipo);
                    goToRoot = true;
                  }else{
                    showAlert = true;
                    alertMsg = "Error creando su perfil. $value";
                  }
                  notifyListeners();
                }).onError((error, stackTrace) {
                  print("createProfile error: $error");
                });
              }else{
                goToRoot = true;
                notifyListeners();
              }
          }).onError((error, stackTrace) {
            showAlert = true;
            alertMsg = "Error al conectar su wallet. Intente nuevamente. ";
            notifyListeners();
            print("getOwnedProfile error: $error");
          });
    }
  }

}