import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/blockchain/contract_resolver.dart';
import 'package:medical_recipe_viewer/blockchain/wallet_conector.dart';
import 'package:medical_recipe_viewer/blockchain/web3_cliente_provider.dart';
import 'package:medical_recipe_viewer/profile/model/profile.dart';
import 'package:medical_recipe_viewer/profile/repository/profile_id_repository.dart';
import 'package:web3dart/web3dart.dart';

import '../../repository/data_source_repository.dart';
import '../../utils/data_validations.dart';
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

  DataSourceRepository dataSourceRepository = DataSourceRepository();

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

  Future<Profile> getProfileOnBlockchain() async{
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
    return profileFromBlockChain;
  }

  Future<Profile> getFirestoreProfile(String? documentId) async {
    if(documentId!=null && documentId.isNotEmpty){
      var firestoreProfile = await _profileIdRepository.checkIfIdProfileExists(documentId);
      if(firestoreProfile.dir.isEmpty) {
        var ownAddress = await walletConector.getOwnEthAddress();
        firestoreProfile.dir = ownAddress!.hex;
        await _profileIdRepository.updateDir(documentId, ownAddress!.hex);
      }
      return firestoreProfile;
    }
    return Profile(
        id: "",
        name: "",
        tipo: -1,
        photo: "",
        dir: ""
    );
  }

  Future<Profile> getOwnedProfile(String? documentId) async{
    var profileFromFirestore = await getFirestoreProfile(documentId);
    var profileFromBlockChain = await getProfileOnBlockchain();
    if(profileFromBlockChain.isEmpty()){
      return profileFromFirestore;
    }
    profileFromBlockChain.photo = profileFromFirestore.photo;
    profileFromBlockChain.status = ProfileCreationStatus.CREATED;
    return profileFromBlockChain;
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
      int tipo,
      int gasLimit,
  ) async {
    var client = clientProvider.getClient();
    var gasPrice = await client!.getGasPrice();
    var contract = await contracResolver.getDeployedContract();
    var credentials = await walletConector.getCredentials();
    print("createProfile credenciales: ${credentials?.address} contract: $contract client: ${client.toString()}");
    print("Gas price: ${gasPrice.getInWei}");
    try{
      var contractCall = Transaction.callContract(
        contract: contract,
        function: _mint,
        parameters: [id,nombre,BigInt.from(tipo)],
        // 1000000000 is 1Gwei
        gasPrice: EtherAmount.inWei(
            selectGasPrice(
                BigInt.from(gasLimit)*BigInt.from(1000000000),//selected by user
                gasPrice.getInWei //get from the network
            )
        )
      );
      var result = await client.sendTransaction(
          credentials!,
          contractCall,
          chainId: int.parse(dataSourceRepository.getChainId()),
          fetchChainIdFromNetworkId: false
      );
      //todo: colocar el log del error para la consola de firebase
      print("transactionHash: ${result}");
      await Future.delayed(
          Duration(seconds: OP_DELAY),
              () => print("Waiting for transaction ${result} to be mined...")
      );
      final transactionResult = await checkTransactionStatus(result);
      print("transactionResult: ${transactionResult.toString()}");
      if(transactionResult==null){
        return ContractResponse.FAILED;
      }
      if(transactionResult.status!= null && transactionResult.status == true){
        return ContractResponse.SUCCESS;
      }
      return ContractResponse.FAILED;
    }catch(exception){
      print("createProfile error: $exception");
      return "Problema de conexion";
    }
  }

  BigInt selectGasPrice(BigInt gasLimit, BigInt gasPrice) {
    print("gasPrice: $gasPrice gasLimit: $gasLimit");
    return gasPrice>gasLimit
        ? gasPrice
        : gasLimit;
  }

  Future<TransactionReceipt?> checkTransactionStatus(String transactionHash) async {
    var client = clientProvider.getClient();
    final TransactionReceipt? receipt = await client?.getTransactionReceipt(transactionHash);
    return receipt;
  }

}