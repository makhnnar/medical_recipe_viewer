import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/profile/ui/profile_creation_view.dart';
import 'package:medical_recipe_viewer/root_view/root_view.dart';
import 'package:medical_recipe_viewer/splash/data_source_repository.dart';
import 'package:medical_recipe_viewer/splash/splash_state.dart';
import 'package:medical_recipe_viewer/splash/splash_view.dart';
import 'package:provider/provider.dart';
import 'di/module.dart';


//si necesito reaccionar al cambio de estado, usar aquellos que tienen el
// nombre change<algo>
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        Provider(
          create: (context) => SplashState(),
        ),
      ],
      child: MaterialApp(
        title: 'MedicalRecipeApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
            '/': (context) => SplashView(),//change this for a splash, in splash decide go to home or login
            '/root': (context) => RootView(),
            '/profileCreation': (context) => ProfileCreationView(),
        },
      ),
    );
  }
}