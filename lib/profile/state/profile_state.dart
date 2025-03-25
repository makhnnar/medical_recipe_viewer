import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:medical_recipe_viewer/page_view/page_view.dart';
import 'package:medical_recipe_viewer/profile/model/profile.dart';
import 'package:medical_recipe_viewer/profile/repository/profile_repository.dart';
import 'package:medical_recipe_viewer/profile/ui/profile_view.dart';

import '../../repository/data_source_repository.dart';

class ProfileState extends ProviderHelper {

  late DataSourceRepository dataSourceRepository;

  ProfileRepository repository;

  ProfileState(
      this.repository,
      this.dataSourceRepository
  ){
    this.value = Container();
    getData();
  }

  @override
  void getData() {
    repository.getOwnedProfile(
        dataSourceRepository.getDocumentId()
    ).then((profile) => onDataReceived(profile))
        .onError((error, stackTrace) => {
            onDataReceived(
                Profile(
                    id: "",
                    name: "",
                    tipo: -1,
                    photo: "",
                    dir: ""
                )
            )
        });
  }

  void onDataReceived(Profile profile){
    print("profile data: ${profile.toString()}");
    if(!profile.isEmpty()){
      dataSourceRepository.setProfileType(profile!.tipo);
    }
    this.value = ProfileView(
        profile
    );
    notifyListeners();
  }

}