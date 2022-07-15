

import 'package:flutter/cupertino.dart';
import 'package:medical_recipe_viewer/blockchain/contract_resolver.dart';
import 'package:medical_recipe_viewer/blockchain/wallet_conector.dart';
import 'package:medical_recipe_viewer/blockchain/web3_cliente_provider.dart';
import 'package:medical_recipe_viewer/profile/repository/profile_repository.dart';
import 'package:medical_recipe_viewer/recipes/repository/recipes_repository.dart';
import 'package:medical_recipe_viewer/splash/data_source_repository.dart';

class InjectionProvider {


  late ProfileRepository _profileRepository;

  late RecipesRepository _recipesRepository;

  late WalletConectorImpl _walletConectorImpl;

  DataSourceRepository dataSourceRepository = DataSourceRepository();

  Web3ClientProviderImpl _client = Web3ClientProviderImpl();

  ContracResolverImpl _contractProfileResolver = ContracResolverImpl(
      "src/abis/Profiles.json",
      "Profiles"
  );

  ContracResolverImpl _recipesProfileResolver = ContracResolverImpl(
      "src/abis/Recipes.json",
      "Recipes"
  );


}