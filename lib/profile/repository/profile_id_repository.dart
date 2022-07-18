import 'package:medical_recipe_viewer/profile/model/profile.dart';

class ProfileIdRepository{

  Profile checkIfIdProfileExists(String id) {
    return Profile(id: "id", name: "name", tipo: 1, photo: "", dir: "");
  }

}