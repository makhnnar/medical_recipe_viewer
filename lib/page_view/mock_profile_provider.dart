import 'package:medical_recipe_viewer/data/profile.dart';
import 'package:medical_recipe_viewer/page_view/page_view.dart';
import 'package:medical_recipe_viewer/profile/profile_view.dart';

class MockProfileProvider extends ProviderHelper {

  @override
  void getData() {
    this.value = ProfileView(
      Profile(
        id: "id",
        name: "name",
        lastName: "lastName",
        photo: "assets/img/girl.jpg"
      )
    );
  }

}