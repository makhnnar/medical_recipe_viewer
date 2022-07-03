import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:medical_recipe_viewer/recipes/model/recipe.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class RecipesRepository{
  List<Recipe> todos = [];
  bool isLoading = true;
  final String _rpcUrl = "http://192.168.0.103:7545";
  final String _wsUrl = "ws://192.168.0.103:7545/";

  //final String _privateKey = "5dfa9e15caabb7a70ecde735119337eea43fe7874c75b41c68dfa810c5d88384";
  final String _privateKey = "092f7460828b06f09efc08cc3214e28ee558b77c659b697cdccdb6166f1e0c2a";
  final String _myWalletAdr = "x750A04854a99C4c5DD4143485C1ccec854c15E17";
  int taskCount = 0;
  Web3Client _client;
  String _abiCode;
  Credentials _credentials;
  EthereumAddress _contractAddress;
  EthereumAddress _ownAddress;
  DeployedContract _contract;
  ContractFunction _taskCount;
  ContractFunction _todos;
  ContractFunction _tokenOfOwnerByIndex;
  ContractFunction _balanceOf;
  ContractFunction _createTask;
  ContractFunction _transferFrom;
  ContractFunction _tokensOfOwner;
  ContractEvent _taskCreatedEvent;

  RecipesRepository() {
    initiateSetup();
  }

  EthereumAddress getAddress(String value){
    EthereumAddress address = EthereumAddress.fromHex(value);
    return address;
  }

  Future<void> initiateSetup() async {
    _client = Web3Client(
        _rpcUrl,
        Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(
              _wsUrl
          ).cast<String>();
        }
    );
    await getAbi();
    await getCredentials();
    await getDeployedContract();
    await getTokenInventory();
  }

  Future<void> getAbi() async {
    String abiStringFile = await rootBundle.loadString(
        "src/abis/Color.json"
    );
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress = EthereumAddress.fromHex(
        jsonAbi["networks"]["5777"]["address"]
    );
    print(_contractAddress);
  }

  Future<void> getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(
        _privateKey
    );
    _ownAddress = await _credentials.extractAddress();
    EtherAmount balance = await _client.getBalance(_ownAddress);
    print("My total ETH: ${balance.getValueInUnit(EtherUnit.ether)}");
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(
            _abiCode,
            "Color"
        ),
        _contractAddress
    );
    _taskCount = _contract.function("totalSupply");
    _createTask = _contract.function("mint");
    _todos = _contract.function("colors");
    _balanceOf = _contract.function("balanceOf");
    _tokenOfOwnerByIndex = _contract.function("tokenOfOwnerByIndex");
    _tokensOfOwner = _contract.function("_tokensOfOwner");
    _transferFrom = _contract.function("transferFrom");
    //_taskCreatedEvent = _contract.event("TaskCreated");
    //getTodos();
    //getTokenInventory();
    // print("");
  }

  Future<void> getTokenInventory() async{
    List totalTokensList = await _client.call(
        contract: _contract,
        function: _balanceOf,
        params: [_ownAddress]
    );
    BigInt totalTokens = totalTokensList[0];
    taskCount = totalTokens.toInt();
    print("total tokens: $totalTokens");
    todos.clear();
    for (var i = 0; i < totalTokens.toInt(); i++) {
      var tempIndex = await _client.call(
          contract: _contract,
          function: _tokenOfOwnerByIndex,
          params: [_ownAddress,BigInt.from(i)]
      );
      print("tempIndex: ${tempIndex[0]}");
      //print("tempIndex: ${tempIndex[0]}");
      var auxIndex = tempIndex[0]-BigInt.from(1);
      print("auxIndex: ${auxIndex}");
      var temp = await _client.call(
          contract: _contract,
          function: _todos,
          params: [auxIndex]
      );
      print("temp: ${temp[0]}");
      todos.add(
          Task(
              taskName: temp[0],
              id: auxIndex
          )
      );
    }
    isLoading = false;
  }

  Future<void> addTask(String taskNameData) async {
    //isLoading = true;
    //notifyListeners();
    print("credenciales: $_credentials");
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _createTask,
            parameters: [taskNameData],
            gasPrice: EtherAmount.inWei(BigInt.one),
            maxGas:600000
        ),
        fetchChainIdFromNetworkId: true
    );
    //getTodos();
    getTokenInventory();
  }

  Future<void> transfer(
      String addressReceiver,
      BigInt id
      ) async {
    //isLoading = true;
    //notifyListeners();
    print("id: $id addressReceiver: $addressReceiver");
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _transferFrom,
            parameters: [
              _ownAddress,
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