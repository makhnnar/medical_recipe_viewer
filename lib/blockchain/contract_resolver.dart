import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:medical_recipe_viewer/blockchain/web3_cliente_provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
//the old values are for ganache on eth network
class ContracResolverImpl implements IContracResolver{

  late String jsonPath;

  late DeployedContract _contract;

  String nameContract;

  String contractAddress;

  ContracResolverImpl(
      this.jsonPath,
      this.nameContract,
      this.contractAddress
  );

  Future<dynamic> _getJsonAsDecodeAbi() async {
    String abiStringFile = await rootBundle.loadString(
        jsonPath
    );
    return jsonDecode(abiStringFile);
  }

  String _getAbiString(dynamic jsonAbi){
    return jsonEncode(jsonAbi["abi"]);
  }

  EthereumAddress _getContractAddress(){
    //the old value was ["networks"]["5777"]["address"]
    return EthereumAddress.fromHex(
        contractAddress
    );
  }

  Future<DeployedContract> getDeployedContract() async {
    var decodeAbi = await _getJsonAsDecodeAbi();
    _contract = DeployedContract(
        ContractAbi.fromJson(
            _getAbiString(decodeAbi),
            nameContract
        ),
        _getContractAddress()
    );
    return _contract;
  }

}

abstract class IContracResolver {

  Future<DeployedContract> getDeployedContract();

}