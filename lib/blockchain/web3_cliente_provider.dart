import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class Web3ClientProviderImpl implements IWeb3ClientProvider{

  final String _rpcUrl = "http://192.168.0.103:7545";
  final String _wsUrl = "ws://192.168.0.103:7545/";

  Web3Client? _client;

  @override
  Web3Client? getClient() {
    if(_client==null){
      _client = Web3Client(
          _rpcUrl,
          Client(),
          socketConnector: () {
            return IOWebSocketChannel.connect(
                _wsUrl
            ).cast<String>();
          }
      );
      return _client;
    }
  }

}

abstract class IWeb3ClientProvider{

  Web3Client? getClient();

}