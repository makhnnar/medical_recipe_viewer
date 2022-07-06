import 'package:medical_recipe_viewer/blockchain/contract_resolver.dart';
import 'package:medical_recipe_viewer/blockchain/wallet_conector.dart';
import 'package:medical_recipe_viewer/blockchain/web3_cliente_provider.dart';
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
class RecipesRepository{

  List<Recipe> recipes = [];

  late ContractFunction _recipesCount;
  late ContractFunction _tokenOfOwnerByIndex;
  late ContractFunction _balanceOf;
  late ContractFunction _mint;
  late ContractFunction _transferFrom;
  late ContractFunction _tokensOfOwner;
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
    await getTokenInventory();
  }

  Future<void> getDeployedContract() async {
    var contract = await contracResolver.getDeployedContract();
    _recipesCount = contract.function("totalSupply");
    _mint = contract.function("mint");
    _balanceOf = contract.function("balanceOf");
    _tokenOfOwnerByIndex = contract.function("tokenOfOwnerByIndex");
    _tokensOfOwner = contract.function("_tokensOfOwner");
    _transferFrom = contract.function("transferFrom");

  }

  Future<void> getTokenInventory() async{
    var contract = await contracResolver.getDeployedContract();
    var ownAddress = await walletConector.getOwnEthAddress();
    var client = await clientProvider.getClient();
    List totalTokensList = await client!.call(
        contract: contract,
        function: _balanceOf,
        params: [ownAddress]
    );
    BigInt totalTokens = totalTokensList[0];
    //replce this
    taskCount = totalTokens.toInt();
    print("total tokens: $totalTokens");
    recipes.clear();
    for (var i = 0; i < totalTokens.toInt(); i++) {
      var tempIndex = await client.call(
          contract: contract,
          function: _tokenOfOwnerByIndex,
          params: [ownAddress,BigInt.from(i)]
      );
      print("tempIndex: ${tempIndex[0]}");
      //print("tempIndex: ${tempIndex[0]}");
      var auxIndex = tempIndex[0]-BigInt.from(1);
      print("auxIndex: ${auxIndex}");
      var temp = await client!.call(
          contract: contract,
          function: todos,
          params: [auxIndex]
      );
      print("temp: ${temp[0]}");
      recipes.add(
          Task(
              taskName: temp[0],
              id: auxIndex
          )
      );
    }
  }

  Future<void> addTask(String taskNameData) async {
    var contract = await contracResolver.getDeployedContract();
    var credentials = await walletConector.getCredentials();
    var client = await clientProvider.getClient();
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
    getTokenInventory();
  }

  Future<void> transfer(
      String addressReceiver,
      BigInt id
      ) async {
    var contract = await contracResolver.getDeployedContract();
    var credentials = await walletConector.getCredentials();
    var client = await clientProvider.getClient();
    var ownAddress = await walletConector.getOwnEthAddress();
    print("id: $id addressReceiver: $addressReceiver");
    await client!.sendTransaction(
        credentials!,
        Transaction.callContract(
            contract: contract,
            function: _transferFrom,
            parameters: [
              ownAddress,
              getAddress(addressReceiver),
              id+BigInt.from(1)
            ],
            gasPrice: EtherAmount.inWei(BigInt.one),
            maxGas:600000
        ),
        fetchChainIdFromNetworkId: true
    );
    //getTodos();
    getTokenInventory();
  }

}