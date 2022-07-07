import 'package:http/http.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class Web3ClientProviderImpl implements IWeb3ClientProvider{

  final String _rpcUrl = "http://192.168.15.6:7545";
  final String _wsUrl = "ws://192.168.15.6:7545/";

  Web3Client? _client;
  IOWebSocketChannel? socketChannel;

  @override
  Web3Client? getClient() {
    if(_client==null){
      IOWebSocketChannel? socket = getSocketChannel();
      _client = Web3Client(
          _rpcUrl,
          Client(),
          socketConnector: () {
            return socket!.cast<String>();
          }
      );
    }
    return _client;
  }

  IOWebSocketChannel? getSocketChannel() {
     if(socketChannel==null) {
       socketChannel = IOWebSocketChannel.connect(
           _wsUrl
       );
     }
     return socketChannel;
  }

}

abstract class IWeb3ClientProvider{

  Web3Client? getClient();
  IOWebSocketChannel? getSocketChannel();

}