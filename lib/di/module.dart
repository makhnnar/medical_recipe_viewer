import 'package:medical_recipe_viewer/blockchain/contract_resolver.dart';
import 'package:medical_recipe_viewer/blockchain/wallet_conector.dart';
import 'package:medical_recipe_viewer/blockchain/web3_cliente_provider.dart';
import 'package:medical_recipe_viewer/profile/repository/profile_repository.dart';
import 'package:medical_recipe_viewer/recipes/repository/recipes_repository.dart';
import 'package:medical_recipe_viewer/repository/data_source_repository.dart';
//the old values are for ganache on eth network

/**
 * BSC Testnet values
 * ipAddress: https://data-seed-prebsc-2-s1.binance.org:8545/
 * wsAddress: ws://data-seed-prebsc-2-s1.binance.org:8545/
 * chainId: 97
 *
 * Ganache values
 * ipAddress: http://192.168.15.162:7545
 * wsAddress: ws://192.168.15.162:7545/
 * chainId: 1337
 *
 * BSC Testnet
 * Profiles: 0x45852177f4cA53AB82D56F9BF0496708a9A39306
 * Recipes: 0x6850497a35036Da2735b7Ad8aEcD6fa099Fa4B9a
 *
 * Ganache
 * Profiles: 0x90426b8Ed46b5Fff329f68a392E58316dBE3a5f2
 * Recipes: 0x0093De75d19A19032473c4749C32e179B2102efe
 *
 * BSC testnet ABIS
 * Profiles: src/bsc-contracts/Profiles.json
 * Recipes: src/bsc-contracts/Recipes.json
 *
 * Ganache ABIS
 * Profiles: src/abis/Profiles.json
 * Recipes: src/abis/Recipes.json
 */
class WalletReposProvider{

  ProfileRepository? _profileRepository;

  RecipesRepository? _recipesRepository;

  WalletConectorImpl? walletConectorImpl;

  Web3ClientProviderImpl client = Web3ClientProviderImpl();

  //the old value was src/abis/Profiles.json
  //the old value was src/abis/Recipes.json

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
            getProfileContractResolver()
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
            getRecipeContractResolver()
        );
      }
      return _recipesRepository;
    }
    return null;
  }

  ContracResolverImpl getProfileContractResolver() {
    return ContracResolverImpl(
        dataSourceRepository.getProfileAbi(),
        "Profiles",
        dataSourceRepository.getProfileContract()
    );
  }

  ContracResolverImpl getRecipeContractResolver() {
    return ContracResolverImpl(
        dataSourceRepository.getRecipeAbi(),
        "Recipes",
        dataSourceRepository.getRecipeContract()
    );
  }

  ProfileRepository getProfileRepository() {
    return getDeployedProfileRepository() ?? ProfileRepository(
        client,
        walletConectorImpl!,
        getProfileContractResolver()
    );
  }

  RecipesRepository getRecipesRepository() {
    return getDeployedRecipesRepository() ?? RecipesRepository(
        client,
        walletConectorImpl!,
        getRecipeContractResolver()
    );
  }

}