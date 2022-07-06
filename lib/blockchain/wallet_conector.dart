import 'package:medical_recipe_viewer/blockchain/web3_cliente_provider.dart';
import 'package:web3dart/web3dart.dart';

class WalletConectorImpl implements IWalletConector{

  IWeb3ClientProvider clientProvider;

  String privateKey = "0x"+"5f5761ec0e6ae960332bccd71312e2b15a710f2b1b4530c3276435fde245f417";

  late Credentials? _credentials;

  EthereumAddress? _ownAddress;

  WalletConectorImpl(
      this.clientProvider,
      this.privateKey
  ) ;

  Future<Credentials?> getCredentials() async {
    if(_credentials==null){
      _credentials = await clientProvider.getClient()!.credentialsFromPrivateKey(
          privateKey
      );
    }
    return _credentials;
  }

  Future<EthereumAddress?> getOwnEthAddress() async {
    if(_ownAddress==null){
      _ownAddress = await _credentials!.extractAddress();
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