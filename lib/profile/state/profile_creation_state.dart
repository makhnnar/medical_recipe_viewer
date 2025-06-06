import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical_recipe_viewer/blockchain/wallet_conector.dart';
import 'package:medical_recipe_viewer/di/module.dart';
import 'package:medical_recipe_viewer/profile/model/profile.dart';
import 'package:medical_recipe_viewer/profile/repository/profile_id_repository.dart';
import 'package:medical_recipe_viewer/profile/ui/profile_creation_view.dart';
import 'package:medical_recipe_viewer/repository/data_source_repository.dart';

import '../../utils/forms.dart';
import '../../values/contanst.dart';

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

  String getProfilePrivateKey(){
    return _profile!.privateKey;
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

  void saveDocumentId(String id, int tipo){
    print("documentId: $id");
    print("tipo: $tipo");
    dataSourceRepository.setDocumentId(id);
    dataSourceRepository.setProfileType(tipo);
  }

  Future<void> checkIfIdProfileExists(String id,dynamic successCallback) async {
    _profile = await profileIdRepository.checkIfIdProfileExists(id);
    print("profile from firebase: ${_profile.toString()}");
    if(!_profile!.isEmpty()){
      saveDocumentId(_profile!.id, _profile!.tipo);
      successCallback();
      return;
    }else{
      showToast("Documento de identidad no valido");
    }
  }

  Future<void> getOrCreateProfile(int gasLimit,dynamic successCallback, dynamic failedCallback) async{
    if(!_profile!.isEmpty()) {
      _connectWalletWithTheNewAddress();
      try{
        var hasProfileResponse = await walletReposProvider
            .getDeployedProfileRepository()!
            .getOwnedProfile(null);
        print("createProfile getOwnedProfile result: $hasProfileResponse");
        if(hasProfileResponse.status==ProfileCreationStatus.NEW){
          await createProfile(gasLimit,successCallback,failedCallback);
        }else{
          dataSourceRepository.setProfileType(hasProfileResponse.tipo);
          successCallback();
        }
      }catch(errorGettingProfile){
        showToast("Error al conectar su wallet. Intente nuevamente.");
        print("createProfile getOwnedProfile error: $errorGettingProfile");
      }
      return;
    }
    showToast("No puedes crear un perfil. Tus datos personales no existen");
  }

  Future<void> createProfile(int gasLimit,dynamic successCallback,dynamic failedCallback) async {
    try{
      var wasProfileCreted = await walletReposProvider
          .getDeployedProfileRepository()!
          .createProfile(
              _profile!.id,
              _profile!.name,
              _profile!.tipo,
              gasLimit
          );
      print("createProfile createProfile result: $wasProfileCreted");
      if(wasProfileCreted==ContractResponse.SUCCESS){
        dataSourceRepository.setProfileType(_profile!.tipo);
        successCallback();
      }else{
        showToast("Error creando su perfil. $wasProfileCreted");
        failedCallback();
      }
    }catch(errorCreatingProfile){
      print("createProfile createProfile error: $errorCreatingProfile");
      failedCallback();
    }
  }

}