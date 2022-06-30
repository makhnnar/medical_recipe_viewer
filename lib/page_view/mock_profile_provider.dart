import 'package:medical_recipe_viewer/profile/model/profile.dart';
import 'package:medical_recipe_viewer/page_view/page_view.dart';
import 'package:medical_recipe_viewer/profile/ui/profile_view.dart';

class MockProfileProvider extends ProviderHelper {

  @override
  void getData() {
    this.value = ProfileView(
      Profile(
        id: "id",
        name: "name",
        lastName: "lastName",
        photo: "assets/img/girl.jpg",
        dir: "adbf342345bcdab453"
      )
    );
  }

}