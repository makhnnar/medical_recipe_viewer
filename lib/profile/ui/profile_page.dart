import 'package:flutter/cupertino.dart';
import 'package:medical_recipe_viewer/page_view/page_view.dart';
import 'package:medical_recipe_viewer/profile/state/profile_state.dart';

class ProfilePage extends StatelessWidget with PageViewHelper<ProfileState> {

  @override
  Widget build(BuildContext context) {
    return this.getView(context);
  }

}