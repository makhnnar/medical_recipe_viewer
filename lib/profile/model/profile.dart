import 'dart:convert';
import 'dart:typed_data';

enum ProfileCreationStatus {
  NEW,
  CREATED,
  ERROR
}

class Profile {

  String id;
  String name;
  int tipo;
  String photo;
  String dir;
  String privateKey;
  ProfileCreationStatus status = ProfileCreationStatus.NEW;

  Profile({
    required this.id,
    required this.name,
    required this.tipo,
    required this.photo,
    required this.dir,
    this.privateKey = ""
  });

  @override
  String toString() {
    return 'Profile{id: $id, name: $name, tipo: $tipo, photo: $photo, dir: $dir, privateKey: $privateKey}';
  }

  bool isEmpty() {
    return id.isEmpty && name.isEmpty && tipo<0 && photo.isEmpty && dir.isEmpty && privateKey.isEmpty;
  }

  //using the method base64Decode and split(',').last return a Uint8List from a base64 string on the photo attribute
  Uint8List getPhotoAsUint8List(){
    return base64Decode(photo.split(',').last);
  }

}