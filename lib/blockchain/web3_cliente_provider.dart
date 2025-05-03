import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:medical_recipe_viewer/repository/data_source_repository.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class Web3ClientProviderImpl implements IWeb3ClientProvider{

  CollectionReference documentos = FirebaseFirestore.instance.collection('serverDir');

  final String _rpcUrl = "http://192.168.15.162:7545";
  final String _wsUrl = "ws://192.168.15.162:7545/";

  Web3Client? _client;
  IOWebSocketChannel? socketChannel;

  DataSourceRepository dataSourceRepository = DataSourceRepository();

  Future<bool> resolveServerDirs() async {
    DocumentSnapshot snapshot = await documentos.doc("values").get();
    if (snapshot.exists) {
      dataSourceRepository.setIpAddress(snapshot['ipAddress']??_rpcUrl);
      dataSourceRepository.setWsAddress(snapshot['wsAddress']??_wsUrl);
      return true;
    }
    return false;
  }

  Web3ClientProviderImpl(){
    resolveServerDirs().then((value) {
      if(value){
        print("Server dirs resolved");
      } else{
        print("Server dirs not resolved");
      }
    });
  }

  @override
  Web3Client? getClient() {
    if(_client==null){
      IOWebSocketChannel? socket = getSocketChannel();
      _client = Web3Client(
          dataSourceRepository.getIpAddress(),
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
           dataSourceRepository.getWsAddress()
       );
     }
     return socketChannel;
  }

}

abstract class IWeb3ClientProvider{

  Web3Client? getClient();
  IOWebSocketChannel? getSocketChannel();

}