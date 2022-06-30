import 'package:flutter/cupertino.dart';
import 'package:medical_recipe_viewer/page_view/mock_profile_provider.dart';
import 'package:medical_recipe_viewer/page_view/page_view.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget with PageViewHelper<MockProfileProvider> {

  @override
  Widget build(BuildContext context) {
    return this.getView(context);
  }

}