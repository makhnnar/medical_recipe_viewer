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
    init();
  }

  void init(){
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
  }

  @override
  void getData() {
    repository.getOwnedProfile()
        .then(
            (profile) => onDataRecieved(profile)
        ).onError((error, stackTrace) => {

        });
  }

  void onDataRecieved(Profile profile){
    this.value = ProfileView(
        profile
    );
    notifyListeners();
  }

}