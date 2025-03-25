
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/profile/model/profile.dart';
import 'package:medical_recipe_viewer/profile/repository/profile_repository.dart';

import '../repository/data_source_repository.dart';

class SplashState {

  BuildContext? context;

  int switchTo = 0;

  void checkIfProfileExist(
      ProfileRepository? profileRepository,
      dynamic goToApp
  ) async {
    if(profileRepository!=null){
        DataSourceRepository dataSourceRepository = DataSourceRepository();
        Profile profile = await profileRepository.getOwnedProfile(
            dataSourceRepository.getDocumentId()
        );
        if(!profile.isEmpty()){
          print("profileRepository!=null? ${profileRepository!=null} !profile.isEmpty() ${!profile.isEmpty()} goToApp: 2");
          goToApp(1);
        }else{
          print("goToApp: 2");
          print("profileRepository!=null? ${profileRepository!=null} !profile.isEmpty() ${!profile.isEmpty()} goToApp: 2");
          goToApp(2);
        }
    }else{
      print("profileRepository!=null? ${profileRepository!=null} goToApp: 2");
      goToApp(2);
    }
  }

}