import 'package:flutter/cupertino.dart';
import 'package:medical_recipe_viewer/blockchain/contract_resolver.dart';
import 'package:medical_recipe_viewer/blockchain/wallet_conector.dart';
import 'package:medical_recipe_viewer/blockchain/web3_cliente_provider.dart';
import 'package:medical_recipe_viewer/profile/repository/profile_repository.dart';
import 'package:medical_recipe_viewer/recipes/repository/recipes_repository.dart';
import 'package:medical_recipe_viewer/splash/data_source_repository.dart';

class WalletReposProvider{

  ProfileRepository? _profileRepository;

  RecipesRepository? _recipesRepository;

  WalletConectorImpl? walletConectorImpl;

  Web3ClientProviderImpl client = Web3ClientProviderImpl();

  ContracResolverImpl _contractProfileResolver = ContracResolverImpl(
      "src/abis/Profiles.json",
      "Profiles"
  );

  ContracResolverImpl _contractRecipesResolver = ContracResolverImpl(
      "src/abis/Recipes.json",
      "Recipes"
  );

  DataSourceRepository dataSourceRepository;

  WalletReposProvider(
      this.dataSourceRepository
  );

  void _initWalletConector() {
    if(walletConectorImpl==null) {
      walletConectorImpl = WalletConectorImpl(
          client,
          dataSourceRepository.getWalletAdr()
      );
    }
  }

  ProfileRepository? getDeployedProfileRepository() {
    if(dataSourceRepository.getWalletAdr().isNotEmpty){
      _initWalletConector();
      if(_profileRepository==null){
        _profileRepository = ProfileRepository(
            client,
            walletConectorImpl!,
            _contractProfileResolver
        );
      }
      return _profileRepository;
    }
    return null;
  }

  RecipesRepository? getDeployedRecipesRepository() {
    if(dataSourceRepository.getWalletAdr().isNotEmpty){
      _initWalletConector();
      if(_profileRepository==null){
        _recipesRepository = RecipesRepository(
            client,
            walletConectorImpl!,
            _contractRecipesResolver
        );
      }
      return _recipesRepository;
    }
    return null;
  }

  ProfileRepository getProfileRepository() {
    return getDeployedProfileRepository() ?? ProfileRepository(
        client,
        walletConectorImpl!,
        _contractProfileResolver
    );
  }

  RecipesRepository getRecipesRepository() {
    return getDeployedRecipesRepository() ?? RecipesRepository(
        client,
        walletConectorImpl!,
        _contractRecipesResolver
    );
  }

}