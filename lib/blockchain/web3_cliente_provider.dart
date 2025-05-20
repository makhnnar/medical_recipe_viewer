import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:medical_recipe_viewer/repository/data_source_repository.dart';
import 'package:medical_recipe_viewer/values/contanst.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
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
 * */
class Web3ClientProviderImpl implements IWeb3ClientProvider{

  CollectionReference documentos = FirebaseFirestore.instance.collection('serverDir');

  final String _rpcUrl = "http://192.168.15.162:7545";
  final String _wsUrl = "ws://192.168.15.162:7545/";

  Web3Client? _client;
  IOWebSocketChannel? socketChannel;

  DataSourceRepository dataSourceRepository = DataSourceRepository();

  Future<bool> resolveServerDirs() async {
    DocumentSnapshot snapshot = await documentos.doc("values").get();
    print("resolveServerDirs document: ${snapshot}");
    if (snapshot.exists) {
      dataSourceRepository.setIpAddress(snapshot['ipAddress']??_rpcUrl);
      dataSourceRepository.setWsAddress(snapshot['wsAddress']??_wsUrl);
      dataSourceRepository.setChainId(snapshot['chainId']??CHAIN_ID.toString());
      dataSourceRepository.setProfileContract(snapshot['profileContract']??PROFILES_CONTRACT);
      dataSourceRepository.setRecipeContract(snapshot['recipeContract']??RECIPES_CONTRACT);
      dataSourceRepository.setProfileAbi(snapshot['profileAbis']??PROFILES_ABI);
      dataSourceRepository.setRecipeAbi(snapshot['recipeAbis']??RECIPES_ABI);
      return true;
    }
    return false;
  }

  Web3ClientProviderImpl(){
    resolveServerDirs().then((value) {
      if(value){
        print("Server dirs resolved");
      } else{
        print("Server dirs not resolved");
      }
    });
  }

  @override
  Web3Client? getClient() {
    if(_client==null){
      IOWebSocketChannel? socket = getSocketChannel();
      _client = Web3Client(
          dataSourceRepository.getIpAddress(),
          Client(),
          socketConnector: () {
            return socket!.cast<String>();
          }
      );
    }
    return _client;
  }

  IOWebSocketChannel? getSocketChannel() {
     if(socketChannel==null) {
       socketChannel = IOWebSocketChannel.connect(
           dataSourceRepository.getWsAddress()
       );
     }
     return socketChannel;
  }

}

abstract class IWeb3ClientProvider{

  Web3Client? getClient();
  IOWebSocketChannel? getSocketChannel();

}