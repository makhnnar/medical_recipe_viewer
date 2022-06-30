import 'package:flutter/cupertino.dart';
import 'package:medical_recipe_viewer/page_view/mock_list_provider.dart';
import 'package:medical_recipe_viewer/page_view/page_view.dart';

class RecipeListPage extends StatelessWidget with PageViewHelper<MockListProvider>{

  @override
  Widget build(BuildContext context) {
    return this.getView(context);
  }

}