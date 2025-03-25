import 'package:medical_recipe_viewer/blockchain/web3_cliente_provider.dart';
import 'package:web3dart/web3dart.dart';

class WalletConectorImpl implements IWalletConector{

  IWeb3ClientProvider clientProvider;

  String privateKey = ""; //this value needs to be solved on the constructor

  Credentials? _credentials;

  EthereumAddress? _ownAddress;

  WalletConectorImpl(
      this.clientProvider,
      this.privateKey
  ) ;

  Future<Credentials?> getCredentials() async {
    print("getCredentials(): asking the Credentials with the pAddress: $privateKey");
    if(_credentials==null){
      _credentials = await clientProvider.getClient()!.credentialsFromPrivateKey(
          privateKey
      );
      print("getCredentials() My Credentials: $_credentials");
    }
    return _credentials;
  }

  Future<EthereumAddress?> getOwnEthAddress() async {
    print("asking the Eth Address");
    if(_credentials==null){
      print("asking the credentials");
      await getCredentials();
    }
    if(_ownAddress==null){
      _ownAddress = await _credentials!.extractAddress();
      print("Eth Address: $_ownAddress");
    }
    return _ownAddress;
  }

  String? getOwnHexAddress() {
    return _ownAddress!.hex;
  }

}

abstract class IWalletConector {

  Future<Credentials?> getCredentials();
  Future<EthereumAddress?> getOwnEthAddress();
  String? getOwnHexAddress();

}