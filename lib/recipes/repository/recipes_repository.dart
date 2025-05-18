import 'package:flutter/cupertino.dart';
import 'package:medical_recipe_viewer/blockchain/contract_resolver.dart';
import 'package:medical_recipe_viewer/blockchain/wallet_conector.dart';
import 'package:medical_recipe_viewer/blockchain/web3_cliente_provider.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:web3dart/web3dart.dart';

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
class RecipesRepository{

  List<Recipe> recipes = [];

  late ContractFunction _totalSupply;
  late ContractFunction _balanceOf;
  late ContractFunction _tokenOfOwnerByIndex;
  late ContractFunction _mint;
  late ContractFunction _transferFrom;
  late ContractFunction _getRecipe;
  late ContractEvent _taskCreatedEvent;

  IWeb3ClientProvider clientProvider;
  IWalletConector walletConector;
  IContracResolver contracResolver;

  RecipesRepository(
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
    /*todo:el socket no funciona pero podemos recibir un hash de transaccion al final de cada accion
       de transferencia o de creacion. usar eso para dar feedback al usuario
    */
    StreamBuilder(
      stream: socketChannel!.stream,
      builder: (context, snapshot) {
        print("StreamBuilder data del sockect: ${snapshot.data}");
        return Container();
      },
    );
  }

  Future<void> getDeployedContract() async {
    var contract = await contracResolver.getDeployedContract();
    _totalSupply = contract.function("totalSupply");
    _balanceOf = contract.function("balanceOf");
    _mint = contract.function("mint");
    _tokenOfOwnerByIndex = contract.function("tokenOfOwnerByIndex");
    _getRecipe = contract.function("getRecipe");
    _transferFrom = contract.function("transferFrom");

  }

  Future<List<Recipe>> getOwnedTokens() async{
    var contract = await contracResolver.getDeployedContract();
    var ownAddress = await walletConector.getOwnEthAddress();
    var client = await clientProvider.getClient();
    //int totalTokens = await getTotalSuply(client, contract);
    int totalTokens = await getTotalBalance(
        client,
        contract,
        ownAddress!
    );
    recipes.clear();
    if(totalTokens>0) {
      for (var i = 0; i < totalTokens; i++) {
        BigInt myTokenIndex = await getIndexOfOwnedToken(
            client,
            contract,
            ownAddress,
            i
        );
        print("auxIndex: $myTokenIndex");
        Recipe temp = await getRecipeAtIndex(
            client,
            contract,
            myTokenIndex
        );
        recipes.add(
            temp
        );
      }
    }
    print("recipes: ${recipes.length}");
    return recipes;
  }

  Future<Recipe> getRecipeAtIndex(
      Web3Client? client,
      DeployedContract contract,
      BigInt myTokenIndex
  ) async {
    var temp = await client!.call(
        contract: contract,
        function: _getRecipe,
        params: [myTokenIndex]
    );
    print("temp: $temp");
    return Recipe(
      id: myTokenIndex,
      nombre: temp[0][0],
      dosis: temp[0][1],
      unidad: temp[0][2],
      frecuencia: temp[0][3],
      lapso: temp[0][4],
      descripcion: temp[0][5],
      tipo: temp[0][6],
      idCreador: temp[0][7],
    );
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

  Future<String> createRecipe(
      Recipe recipe,
      int gasLimit,
      EthereumAddress profileContractAddr
  ) async {
    var contract = await contracResolver.getDeployedContract();
    var credentials = await walletConector.getCredentials();
    var client = clientProvider.getClient();
    var gasPrice = await client!.getGasPrice();
    try{
      var result = await client!.sendTransaction(
          credentials!,
          Transaction.callContract(
              contract: contract,
              function: _mint,
              parameters: [
                recipe.nombre,
                recipe.dosis,
                recipe.unidad,
                recipe.frecuencia,
                recipe.lapso,
                recipe.descripcion,
                BigInt.from(int.parse(recipe.tipo??"0")),
                recipe.idCreador,
                profileContractAddr
              ],
              // 1000000000 is 1Gwei
              gasPrice: EtherAmount.inWei(
                  selectGasPrice(
                      BigInt.from(gasLimit)*BigInt.from(1000000000),//selected by user
                      gasPrice.getInWei //get from the network
                  )
              ),
              //maxGas: gasPrice.getInWei.toInt()//get from the network
          ),
          chainId: CHAIN_ID,
          fetchChainIdFromNetworkId: false
      );
      print("transactionHash: ${result}");
      await Future.delayed(
          const Duration(seconds: 30),
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
    }catch(e){
      print("Error: $e");
      return ContractResponse.FAILED;
    }
  }

  //with this function we can select the gas price to use always selecting the biggest one
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

  Future<String> sendRecipeToAddress(
      String addressReceiver,
      BigInt id
  ) async {
    var contract = await contracResolver.getDeployedContract();
    var credentials = await walletConector.getCredentials();
    var client = clientProvider.getClient();
    var ownAddress = await walletConector.getOwnEthAddress();
    print("id: $id addressReceiver: $addressReceiver");
    var result = await client!.sendTransaction(
        credentials!,
        Transaction.callContract(
            contract: contract,
            function: _transferFrom,
            parameters: [
              ownAddress,
              getAddress(addressReceiver),
              id+BigInt.from(1)
            ],
            gasPrice: EtherAmount.inWei(BigInt.from(574560130)),
            maxGas:600000
        ),
        chainId: CHAIN_ID,
        fetchChainIdFromNetworkId: false
    );
    return (validateValueWithRexExpression(result,RegularExpressions.privAddr))?ContractResponse.SUCCESS:ContractResponse.FAILED;
  }

}