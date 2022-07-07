import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/page_view/mock_list_provider.dart';
import 'package:medical_recipe_viewer/page_view/mock_profile_provider.dart';
import 'package:medical_recipe_viewer/profile/state/profile_state.dart';
import 'package:medical_recipe_viewer/profile/ui/profile_page.dart';
import 'package:medical_recipe_viewer/recipes/state/code_state.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_list/recipe_list_page.dart';
import 'package:medical_recipe_viewer/values/app_colors.dart';
import 'package:provider/provider.dart';

class RootView extends StatefulWidget {
  @override
  _RootView createState() => _RootView();
}

class _RootView extends State<RootView> {
  @override
  Widget build(BuildContext context) {
    return myView();
  }

  Widget myView() {
    final PageController controller = PageController(initialPage: 0);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          body:PageView(
            scrollDirection: Axis.horizontal,
            controller: controller,
            children: <Widget>[
              MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (_) => MockListProvider()
                  ),
                  ChangeNotifierProvider(
                      create: (_) => CodeState()
                  ),
                ],
                child:RecipeListPage(),
              ),
              MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (_) => ProfileState()
                  )
                ],
                child:ProfilePage(),
              ),
            ],
          ),
          bottomNavigationBar:BottomAppBar(
            color: mainColors['dPurpleL1'],
            child: IconTheme(
              data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:IconButton(
                        tooltip: 'Open navigation menu',
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          controller.jumpToPage(0);
                        },
                      )
                  ),
                  Expanded(
                      flex: 1,
                      child:IconButton(
                        tooltip: 'Favorite',
                        icon: const Icon(Icons.person_rounded),
                        onPressed: () {
                          controller.jumpToPage(2);
                        },
                      )
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

}
