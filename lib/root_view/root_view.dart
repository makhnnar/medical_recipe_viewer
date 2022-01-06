import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/page_view/MockProvider.dart';
import 'package:medical_recipe_viewer/profile/profile_page.dart';
import 'package:medical_recipe_viewer/recipe_list/recipe_list_page.dart';
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
    return Scaffold(
        backgroundColor: Colors.white,
        body:PageView(
          scrollDirection: Axis.horizontal,
          controller: controller,
          children: <Widget>[
            MultiProvider(
              providers: [
                ChangeNotifierProvider(
                    create: (_) => MockProvider()
                ),
              ],
              child:RecipeListPage(),
            ),
            MultiProvider(
              providers: [
                ChangeNotifierProvider(
                    create: (_) => MockProvider()
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
    );
  }

}
