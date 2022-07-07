import 'package:flutter/cupertino.dart';
import 'package:medical_recipe_viewer/blockchain/contract_resolver.dart';
import 'package:medical_recipe_viewer/blockchain/wallet_conector.dart';
import 'package:medical_recipe_viewer/blockchain/web3_cliente_provider.dart';
import 'package:medical_recipe_viewer/page_view/page_view.dart';
import 'package:medical_recipe_viewer/profile/model/profile.dart';
import 'package:medical_recipe_viewer/profile/repository/profile_repository.dart';
import 'package:medical_recipe_viewer/profile/ui/profile_view.dart';

class ProfileState extends ProviderHelper {

  late ProfileRepository repository;

  ProfileState(){
    this.value = Container();
    _init();
  }

  void _init(){
    var client = Web3ClientProviderImpl();
    repository = ProfileRepository(
        client,
        WalletConectorImpl(
            client,
            "5f5761ec0e6ae960332bccd71312e2b15a710f2b1b4530c3276435fde245f417"
        ),
        ContracResolverImpl(
            "src/abis/Profiles.json",
            "Profiles"
        )
    );
    getData();
  }

  @override
  void getData() {
    repository.getOwnedProfile()
        .then(
            (profile) => onDataReceived(profile)
        ).onError((error, stackTrace) => {
            onDataReceived(
                Profile(
                    id: "id",
                    name: "name",
                    lastName: "lastName",
                    photo: "assets/img/girl.jpg",
                    dir: "adbf342345bcdab453"
                )
            )
        });
  }

  void onDataReceived(Profile profile){
    print("profile data: ${profile.toString()}");
    this.value = ProfileView(
        profile
    );
    notifyListeners();
  }

}