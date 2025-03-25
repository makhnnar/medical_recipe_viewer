import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/blockchain/contract_resolver.dart';
import 'package:medical_recipe_viewer/blockchain/wallet_conector.dart';
import 'package:medical_recipe_viewer/blockchain/web3_cliente_provider.dart';
import 'package:medical_recipe_viewer/profile/model/profile.dart';
import 'package:medical_recipe_viewer/profile/repository/profile_id_repository.dart';
import 'package:web3dart/web3dart.dart';

import '../../utils/forms.dart';
import '../../values/contanst.dart';


//{
//     "0": "123456",
//     "1": "Aramando Penas",
//     "2": "1",
//     "id": "123456",
//     "nombre": "Aramando Penas",
//     "tipo": "1"
// }
class ProfileRepository{

  Profile _profile = Profile(id: "", name: "", tipo: -1, photo: "", dir: "");

  late ContractFunction _totalSupply;
  late ContractFunction _balanceOf;
  late ContractFunction _tokenOfOwnerByIndex;
  late ContractFunction _mint;
  late ContractFunction _getProfile;
  late ContractFunction _getProfileWithAdress;
  late ContractEvent _addedUser;

  IWeb3ClientProvider clientProvider;
  IWalletConector walletConector;
  IContracResolver contracResolver;

  ProfileIdRepository _profileIdRepository = ProfileIdRepository();

  ProfileRepository(
      this.clientProvider,
      this.walletConector,
      this.contracResolver
      ) {
    initiateSetup();
  }

  EthereumAddress getAddress(String value){
    EthereumAddress address = EthereumAddress.fromHex(value);
    return address;
  }

  Future<void> initiateSetup() async {
    await getDeployedContract();
    var socketChannel = clientProvider.getSocketChannel();
    StreamBuilder(
      stream: socketChannel!.stream,
      builder: (context, snapshot) {
        print("data del sockect: ${snapshot.data}");
        return Container();
      },
    );
  }

  Future<void> getDeployedContract() async {
    var contract = await contracResolver.getDeployedContract();
    _totalSupply = contract.function("totalSupply");
    _balanceOf = contract.function("balanceOf");
    _mint = contract.function("addNewProfile");
    _tokenOfOwnerByIndex = contract.function("tokenOfOwnerByIndex");
    _getProfile = contract.function("profiles");
    _getProfileWithAdress = contract.function("getProfileWithAdress");
    _addedUser = contract.event("addedUser");
  }

  Future<Profile> getProfileOnBlockchain(Profile profile) async{
    var client = clientProvider.getClient();
    print("getOwnedProfile cliente on profile repo is null? ${client==null}");
    var contract = await contracResolver.getDeployedContract();
    print("contract: $contract");
    var ownAddress = await walletConector.getOwnEthAddress();
    print("getOwnedProfile ownAddress: $ownAddress");
    Profile profileFromBlockChain = await getProfileWithAdress(
        client,
        contract,
        ownAddress!
    );
    print("_profile from blockchain: ${profileFromBlockChain.toString()}");
    if(profileFromBlockChain.isEmpty()){
      return profile;
    }
    profileFromBlockChain.photo = profile.photo;
    return profileFromBlockChain;
  }

  Future<Profile> getOwnedProfile(String? documentId) async{
    if(documentId!=null && documentId.isNotEmpty){
      var firestoreProfile = await _profileIdRepository.checkIfIdProfileExists(documentId);
      var blockchainProfile = await getProfileOnBlockchain(firestoreProfile);
      await _profileIdRepository.updateDir(documentId,blockchainProfile.dir);
      return blockchainProfile;
    }
    return getProfileOnBlockchain(_profile);
  }


  Future<Profile> getProfileWithAdress(
      Web3Client? client,
      DeployedContract contract,
      EthereumAddress ownAddress
  ) async {
    print("getProfileWithAdress: ${ownAddress.toString()}");
    try {
      var temp = await client!.call(
          contract: contract,
          function: _getProfileWithAdress,
          params: [ownAddress]
      );
      print("getProfileWithAdress: ${temp.toString()}");
      var toReturn = Profile(
          id: temp[0][0],
          name: temp[0][1],
          tipo: temp[0][2].toInt(),
          photo: "",
          dir: walletConector.getOwnHexAddress()!
      );
      print("_getProfileWithAdress: ${toReturn.toString()}");
      return toReturn;
    }catch(error){
      print("error getProfileWithAdress: $error");
      return _profile;
    }
  }

  Future<BigInt> getIndexOfOwnedToken(
      Web3Client? client,
      DeployedContract contract,
      EthereumAddress? ownAddress,
      int i
      ) async {
    var tempIndex = await client!.call(
        contract: contract,
        function: _tokenOfOwnerByIndex,
        params: [ownAddress,BigInt.from(i)]
    );
    print("tempIndex: ${tempIndex[0]}");
    return tempIndex[0]-BigInt.from(1);
  }

  Future<int> getTotalSuply(
      Web3Client? client,
      DeployedContract contract
      ) async {
    var totalTokensInList = await client!.call(
        contract: contract,
        function: _totalSupply,
        params: []
    );
    BigInt totalTokens = totalTokensInList[0];
    print("total tokens: $totalTokens");
    return totalTokens.toInt();
  }

  Future<int> getTotalBalance(
      Web3Client? client,
      DeployedContract contract,
      EthereumAddress ownAddress
      ) async {
    try{
      var totalTokensInList = await client!.call(
          contract: contract,
          function: _balanceOf,
          params: [ownAddress]
      );
      BigInt totalTokens = totalTokensInList[0];
      print("total tokens in balance: $totalTokens");
      return totalTokens.toInt();
    }catch(exception){
      return 0;
    }
  }

  Future<String> createProfile(
      String id,
      String nombre,
      int tipo
  ) async {
    var client = clientProvider.getClient();
    var contract = await contracResolver.getDeployedContract();
    var credentials = await walletConector.getCredentials();
    print("createProfile credenciales: $credentials contract: $contract client: $client");
    try{
      var result = await client!.sendTransaction(
          credentials!,
          Transaction.callContract(
              contract: contract,
              function: _mint,
              parameters: [id,nombre,BigInt.from(tipo)],
              gasPrice: EtherAmount.inWei(BigInt.from(574560130)),
              maxGas:600000,
          ),
          chainId: 1337,
          fetchChainIdFromNetworkId: false
      );
      //todo: validar que pasa con el proceso de creacion de perfiles
      // 0x864acf22e48b75c1bd402cda01ed4d89a04fc0aa0209b8590fa4367a7b36a3a9
      //es el valor de retorno cuando una transaccion es valida
      //todo: colocar el log del error para la consola de firebase
      return (validateValue(result,RegularExpressions.privAddr))?ContractResponse.SUCCESS:ContractResponse.FAILED;
    }catch(exception){
      print("createProfile error: $exception");
      return "Problema de conexion";
    }
  }

}