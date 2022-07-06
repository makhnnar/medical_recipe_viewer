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
    await getOwnedTokens();
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
    int totalTokens = await getTotalBalance(client, contract);
    recipes.clear();
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
    print("temp: ${temp[0]}");
    return Recipe(
      id: "${myTokenIndex.toInt()}",
      nombre: temp[0],
      dosis: temp[0],
      unidad: temp[0],
      frecuencia: temp[0],
      lapso: temp[0],
      descripcion: temp[0],
      tipo: temp[0],
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
      DeployedContract contract
  ) async {
    var totalTokensInList = await client!.call(
        contract: contract,
        function: _balanceOf,
        params: []
    );
    BigInt totalTokens = totalTokensInList[0];
    print("total tokens in balance: $totalTokens");
    return totalTokens.toInt();
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
  }

}