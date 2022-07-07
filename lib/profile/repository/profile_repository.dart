import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_recipe_viewer/blockchain/contract_resolver.dart';
import 'package:medical_recipe_viewer/blockchain/wallet_conector.dart';
import 'package:medical_recipe_viewer/blockchain/web3_cliente_provider.dart';
import 'package:medical_recipe_viewer/profile/model/profile.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:web3dart/web3dart.dart';


//{
//     "0": "123456",
//     "1": "Aramando Penas",
//     "2": "1",
//     "id": "123456",
//     "nombre": "Aramando Penas",
//     "tipo": "1"
// }
class ProfileRepository{

  Profile _profile = Profile(id: "", name: "", lastName: "", photo: "", dir: "");

  late ContractFunction _totalSupply;
  late ContractFunction _balanceOf;
  late ContractFunction _tokenOfOwnerByIndex;
  late ContractFunction _mint;
  late ContractFunction _getProfile;
  late ContractEvent _addedUser;

  IWeb3ClientProvider clientProvider;
  IWalletConector walletConector;
  IContracResolver contracResolver;

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
    await getOwnedProfile();
    var socketChannel = clientProvider.getSocketChannel();
    StreamBuilder(
      stream: socketChannel!.stream,
      builder: (context, snapshot) {
        print("${snapshot.data}");
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
    _addedUser = contract.event("addedUser");
  }

  Future<Profile> getOwnedProfile() async{
    var client = clientProvider.getClient();
    print("cliente on profile repo is null? ${client==null}");
    var contract = await contracResolver.getDeployedContract();
    print("contract: $contract");
    var ownAddress = await walletConector.getOwnEthAddress();
    print("ownAddress: $ownAddress");
    //int totalTokens = await getTotalSuply(client, contract);
    int totalTokens = await getTotalBalance(
        client,
        contract,
        ownAddress!
    );
    for (var i = 0; i < totalTokens; i++) {
      BigInt myTokenIndex = await getIndexOfOwnedToken(
          client,
          contract,
          ownAddress,
          i
      );
      print("auxIndex: $myTokenIndex");
      _profile = await getProfileAtIndex(
          client,
          contract,
          myTokenIndex
      );
    }
    print("_profile: ${_profile.toString()}");
    return _profile;
  }

  Future<Profile> getProfileAtIndex(
      Web3Client? client,
      DeployedContract contract,
      BigInt myTokenIndex
  ) async {
    var temp = await client!.call(
        contract: contract,
        function: _getProfile,
        params: [myTokenIndex]
    );
    print("temp: ${temp.toString()}");
    var toReturn = Profile(
        id: temp[0],
        name: temp[1],
        lastName: "${temp[2]}",
        photo: "",
        dir: walletConector.getOwnHexAddress()!
    );
    print("toReturn: ${toReturn.toString()}");
    return toReturn;
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
    var totalTokensInList = await client!.call(
        contract: contract,
        function: _balanceOf,
        params: [ownAddress]
    );
    BigInt totalTokens = totalTokensInList[0];
    print("total tokens in balance: $totalTokens");
    return totalTokens.toInt();
  }

  Future<void> generateNewProfile(String taskNameData) async {
    var client = clientProvider.getClient();
    var contract = await contracResolver.getDeployedContract();
    var credentials = await walletConector.getCredentials();
    print("credenciales: $credentials");
    await client!.sendTransaction(
        credentials!,
        Transaction.callContract(
            contract: contract,
            function: _mint,
            parameters: [taskNameData],
            gasPrice: EtherAmount.inWei(BigInt.one),
            maxGas:600000
        ),
        fetchChainIdFromNetworkId: true
    );
  }

}