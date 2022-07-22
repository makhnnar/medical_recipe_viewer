import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/profile/repository/profile_id_repository.dart';
import 'package:medical_recipe_viewer/profile/repository/profile_repository.dart';
import 'package:medical_recipe_viewer/profile/state/profile_creation_field_state.dart';
import 'package:medical_recipe_viewer/profile/state/profile_creation_state.dart';
import 'package:medical_recipe_viewer/profile/ui/profile_creation_view.dart';
import 'package:medical_recipe_viewer/recipes/repository/recipes_repository.dart';
import 'package:medical_recipe_viewer/root_view/root_view.dart';
import 'package:medical_recipe_viewer/repository/data_source_repository.dart';
import 'package:medical_recipe_viewer/splash/splash_state.dart';
import 'package:medical_recipe_viewer/splash/splash_view.dart';
import 'package:provider/provider.dart';
import 'di/module.dart';


//si necesito reaccionar al cambio de estado, usar aquellos que tienen el
// nombre change<algo>
class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:_firebaseApp,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return MultiProvider(
              providers: [
                Provider(
                  create: (_) => DataSourceRepository(),
                ),
                ProxyProvider<DataSourceRepository, WalletReposProvider>(
                  update: (
                      context,
                      dataSourceRepository,
                      walletReposProvider
                      ) => WalletReposProvider(dataSourceRepository),
                ),
                Provider<ProfileIdRepository>(
                    create: (_) => ProfileIdRepository()
                ),
              ],
              child: MaterialApp(
                title: 'MedicalRecipeApp',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  brightness: Brightness.dark,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  backgroundColor: Colors.white,
                  hoverColor: Colors.black26,
                  textTheme: TextTheme(
                    titleLarge: TextStyle(
                      color: Colors.black,
                    ),
                    bodyMedium: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ),
                initialRoute: '/',
                routes: {
                  '/': (context) => Provider(
                    create: (context) => SplashState(),
                    child: SplashView(),
                  ),//change this for a splash, in splash decide go to home or login
                  '/root': (context) => MultiProvider(
                      providers: [
                        Provider<ProfileRepository>(create: (_) => Provider.of<WalletReposProvider>(context, listen: false).getProfileRepository()),
                        Provider<RecipesRepository>(create: (_) => Provider.of<WalletReposProvider>(context, listen: false).getRecipesRepository())
                      ],
                      child:RootView()
                  ),
                  '/profileCreation': (context) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                            create: (_) => ProfileCreationFieldState()
                        ),
                        ChangeNotifierProvider(
                            create: (_) => ProfileCreationState(
                              Provider.of<DataSourceRepository>(context, listen: false),
                              Provider.of<WalletReposProvider>(context, listen: false),
                              Provider.of<ProfileIdRepository>(context, listen: false),
                            )
                        ),
                      ],
                      child: ProfileCreationView()
                  ),
                },
              ),
            );
          }
          return Container();
        }
    );
  }
}