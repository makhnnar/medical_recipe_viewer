import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/profile/repository/profile_repository.dart';
import 'package:medical_recipe_viewer/profile/state/profile_state.dart';
import 'package:medical_recipe_viewer/profile/ui/profile_page.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:medical_recipe_viewer/recipes/repository/recipes_repository.dart';
import 'package:medical_recipe_viewer/recipes/state/code_state.dart';
import 'package:medical_recipe_viewer/recipes/state/recipes_creation_field_state.dart';
import 'package:medical_recipe_viewer/recipes/state/recipes_state.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_creation/recipe_creation_view.dart';
import 'package:medical_recipe_viewer/recipes/ui/recipe_list/recipe_list_page.dart';
import 'package:medical_recipe_viewer/utils/data_validations.dart';
import 'package:medical_recipe_viewer/utils/navigation_actions.dart';
import 'package:medical_recipe_viewer/utils/qr_reader.dart';
import 'package:medical_recipe_viewer/values/app_colors.dart';
import 'package:provider/provider.dart';

import '../blockchain/contract_resolver.dart';
import '../di/module.dart';
import '../recipes/ui/recipe_detail/recipe_detail_view.dart';
import '../recipes/ui/recipe_list/recipe_list_view.dart';
import '../repository/data_source_repository.dart';
import '../values/contanst.dart';

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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => RecipesState(
                  Provider.of<RecipesRepository>(context,listen: false)
              )
          ),
          ChangeNotifierProvider(
              create: (_) => ProfileState(
                Provider.of<ProfileRepository>(context,listen: false),
                Provider.of<DataSourceRepository>(context,listen: false),
              )
          )
        ],
        child:MaterialApp(
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
                          create: (_) => CodeState()
                      ),
                    ],
                    child:RecipeListPage(),
                  ),
                  MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                          create: (_) => RecipesCreationFieldState()
                      ),
                      Provider<ContracResolverImpl>(create: (_) => Provider.of<WalletReposProvider>(context, listen: false).contractProfileResolver)
                    ],
                    child: RecipeCreationView(),
                  ),
                  ProfilePage()
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
                            tooltip: 'lista',
                            icon: const Icon(Icons.menu),
                            onPressed: () {
                              controller.jumpToPage(0);
                            },
                          )
                      ),
                      if(Provider.of<DataSourceRepository>(context,listen: false).getProfileType()==0)
                        Expanded(
                          flex: 1,
                          child:IconButton(
                            tooltip: 'agregar',
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              controller.jumpToPage(1);
                            },
                          )
                        ),
                      Expanded(
                          flex: 1,
                          child:IconButton(
                            tooltip: 'leer',
                            icon: const Icon(Icons.qr_code_scanner_rounded),
                            onPressed: () {
                              scanQR().then((value) {
                                if(validateValueWithRexExpression(value, RegularExpressions.json1)){
                                  var notifiers = [
                                    ChangeNotifierProvider<CodeState>.value(value: CodeState()),
                                    ChangeNotifierProvider<RecipesState?>.value(value: null)
                                  ];
                                  try{
                                    Map<String, dynamic> jsonData = jsonDecode(value);
                                    if(isListOfRecipes(jsonData)){
                                      goToPage(
                                          context,
                                          RecipeListView(
                                              recipeList: RecipeList.fromJson(jsonData),
                                              allowShareAndSend: false
                                          ),
                                          notifiers
                                      );
                                    } else {
                                      goToPage(
                                          context,
                                          RecipeDetailView(
                                              Recipe.fromJson(jsonData)
                                          ),
                                          notifiers
                                      );
                                    }
                                  }catch(error){
                                    print("error displaying the detail: $error");
                                  }
                                }
                              });
                            },
                          )
                      ),
                      Expanded(
                          flex: 1,
                          child:IconButton(
                            tooltip: 'perfil',
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
        )
    );
  }

}
