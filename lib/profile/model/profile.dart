class Profile {

  String id;
  String name;
  int tipo;
  String photo;
  String dir;
  String privateKey;

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

}